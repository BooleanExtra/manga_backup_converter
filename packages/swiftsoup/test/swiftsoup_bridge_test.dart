@TestOn('vm')
library;

import 'dart:ffi';
import 'dart:io';

import 'package:checks/checks.dart';
import 'package:objective_c/objective_c.dart' as objc;
import 'package:swiftsoup/swiftsoup.dart';
import 'package:test/scaffolding.dart';

objc.NSString _ns(String s) => s.toNSString();
String? _str(objc.NSString? ns) => ns?.toDartString();

List<int> _handleList(objc.NSArray arr) {
  final int count = arr.count;
  final handles = <int>[];
  for (var i = 0; i < count; i++) {
    final num = objc.NSNumber.as(arr.objectAtIndex(i));
    handles.add(num.intValue);
  }
  return handles;
}

/// Locate and load the SwiftSoupWrapper dylib so ObjC classes are registered
/// before any getClass call.
void _loadSwiftSoupDylib() {
  // The hooks runner places the built dylib at .dart_tool/lib/ relative to the
  // package root. Walk upward from cwd to find it.
  Directory dir = Directory.current;
  for (var i = 0; i < 5; i++) {
    final dylib = File(
      '${dir.path}/.dart_tool/lib/libSwiftSoupWrapper.dylib',
    );
    if (dylib.existsSync()) {
      DynamicLibrary.open(dylib.path);
      return;
    }
    dir = dir.parent;
  }
  throw StateError(
    'Could not find libSwiftSoupWrapper.dylib — '
    'run `dart test` from the swiftsoup package directory',
  );
}

void main() {
  setUpAll(_loadSwiftSoupDylib);
  tearDown(SwiftSoupBridge.dispose);

  group('parsing', () {
    test('parse returns valid handle', () {
      final int handle = SwiftSoupBridge.parse(
        _ns('<html><body><p>hello</p></body></html>'),
        baseUri: _ns(''),
      );
      check(handle).isGreaterThan(0);
    });

    test('parseFragment returns valid handle', () {
      final int handle = SwiftSoupBridge.parseFragment(
        _ns('<div>frag</div>'),
        baseUri: _ns(''),
      );
      check(handle).isGreaterThan(0);
    });

    test('parse with baseUri preserves it', () {
      final int doc =
          SwiftSoupBridge.parse(_ns('<a href="/p">x</a>'), baseUri: _ns('https://example.com'));
      check(doc).isGreaterThan(0);
      check(_str(SwiftSoupBridge.nodeBaseUri(doc))).equals('https://example.com');
    });
  });

  group('selection', () {
    late int doc;

    setUp(() {
      doc = SwiftSoupBridge.parse(
        _ns('<div id="a"><p class="x">one</p><p class="y">two</p></div>'),
        baseUri: _ns(''),
      );
    });

    test('select returns node list', () {
      final int listHandle = SwiftSoupBridge.select(doc, selector: _ns('p'));
      check(listHandle).isGreaterThan(0);
      check(SwiftSoupBridge.size(listHandle)).equals(2);
    });

    test('selectFirst returns single element', () {
      final int el = SwiftSoupBridge.selectFirst(doc, selector: _ns('p.y'));
      check(el).isGreaterThan(0);
      check(_str(SwiftSoupBridge.text(el))).equals('two');
    });

    test('selectFirst returns -1 for no match', () {
      final int el = SwiftSoupBridge.selectFirst(doc, selector: _ns('span'));
      check(el).equals(-1);
    });

    test('select returns empty list for no match', () {
      final int listHandle = SwiftSoupBridge.select(doc, selector: _ns('span'));
      check(SwiftSoupBridge.size(listHandle)).equals(0);
    });
  });

  group('attributes', () {
    late int el;

    setUp(() {
      final int doc = SwiftSoupBridge.parse(
        _ns('<a href="/link" data-x="42">text</a>'),
        baseUri: _ns('https://example.com'),
      );
      el = SwiftSoupBridge.selectFirst(doc, selector: _ns('a'));
    });

    test('attr returns value', () {
      check(_str(SwiftSoupBridge.attr(el, key: _ns('href')))).equals('/link');
    });

    test('attr returns null for missing key', () {
      check(_str(SwiftSoupBridge.attr(el, key: _ns('title')))).isNull();
    });

    test('hasAttr', () {
      check(SwiftSoupBridge.hasAttr(el, key: _ns('href'))).isTrue();
      check(SwiftSoupBridge.hasAttr(el, key: _ns('title'))).isFalse();
    });

    test('setAttr and removeAttr', () {
      SwiftSoupBridge.setAttr(el, key: _ns('title'), value: _ns('hello'));
      check(_str(SwiftSoupBridge.attr(el, key: _ns('title')))).equals('hello');

      SwiftSoupBridge.removeAttr(el, key: _ns('title'));
      check(SwiftSoupBridge.hasAttr(el, key: _ns('title'))).isFalse();
    });

    test('nodeAbsUrl resolves relative URL', () {
      check(_str(SwiftSoupBridge.nodeAbsUrl(el, key: _ns('href'))))
          .equals('https://example.com/link');
    });
  });

  group('text and html', () {
    late int doc;

    setUp(() {
      doc = SwiftSoupBridge.parse(
        _ns('<div><p>hello <b>world</b></p></div>'),
        baseUri: _ns(''),
      );
    });

    test('text returns combined text', () {
      final int p = SwiftSoupBridge.selectFirst(doc, selector: _ns('p'));
      check(_str(SwiftSoupBridge.text(p))).equals('hello world');
    });

    test('ownText returns direct text only', () {
      final int p = SwiftSoupBridge.selectFirst(doc, selector: _ns('p'));
      check(_str(SwiftSoupBridge.ownText(p))).equals('hello');
    });

    test('innerHtml', () {
      final int p = SwiftSoupBridge.selectFirst(doc, selector: _ns('p'));
      check(_str(SwiftSoupBridge.innerHtml(p))).equals('hello <b>world</b>');
    });

    test('outerHtml', () {
      final int p = SwiftSoupBridge.selectFirst(doc, selector: _ns('p'));
      check(_str(SwiftSoupBridge.outerHtml(p)))
          .equals('<p>hello <b>world</b></p>');
    });

    test('setText replaces content', () {
      final int p = SwiftSoupBridge.selectFirst(doc, selector: _ns('p'));
      SwiftSoupBridge.setText(p, text: _ns('replaced'));
      check(_str(SwiftSoupBridge.text(p))).equals('replaced');
    });

    test('setHtml replaces inner html', () {
      final int p = SwiftSoupBridge.selectFirst(doc, selector: _ns('p'));
      SwiftSoupBridge.setHtml(p, html: _ns('<em>new</em>'));
      check(_str(SwiftSoupBridge.innerHtml(p))).equals('<em>new</em>');
    });

    test('data returns script content', () {
      final int scriptDoc = SwiftSoupBridge.parse(
        _ns('<script>var x = 1;</script>'),
        baseUri: _ns(''),
      );
      final int script =
          SwiftSoupBridge.selectFirst(scriptDoc, selector: _ns('script'));
      check(_str(SwiftSoupBridge.data(script))).equals('var x = 1;');
    });
  });

  group('element info', () {
    late int el;

    setUp(() {
      final int doc = SwiftSoupBridge.parse(
        _ns('<div id="main" class="foo bar">content</div>'),
        baseUri: _ns(''),
      );
      el = SwiftSoupBridge.selectFirst(doc, selector: _ns('div'));
    });

    test('tagName', () {
      check(_str(SwiftSoupBridge.tagName(el))).equals('div');
    });

    test('elementId', () {
      check(_str(SwiftSoupBridge.elementId(el))).equals('main');
    });

    test('elementId returns null when absent', () {
      final int doc = SwiftSoupBridge.parse(_ns('<p>x</p>'), baseUri: _ns(''));
      final int p = SwiftSoupBridge.selectFirst(doc, selector: _ns('p'));
      check(_str(SwiftSoupBridge.elementId(p))).isNull();
    });

    test('className', () {
      check(_str(SwiftSoupBridge.className(el))).equals('foo bar');
    });

    test('hasClass', () {
      check(SwiftSoupBridge.hasClass(el, name: _ns('foo'))).isTrue();
      check(SwiftSoupBridge.hasClass(el, name: _ns('baz'))).isFalse();
    });

    test('addClass and removeClass', () {
      SwiftSoupBridge.addClass(el, name: _ns('baz'));
      check(SwiftSoupBridge.hasClass(el, name: _ns('baz'))).isTrue();

      SwiftSoupBridge.removeClass(el, name: _ns('baz'));
      check(SwiftSoupBridge.hasClass(el, name: _ns('baz'))).isFalse();
    });
  });

  group('node list operations', () {
    late int listHandle;

    setUp(() {
      final int doc = SwiftSoupBridge.parse(
        _ns('<ul><li>a</li><li>b</li><li>c</li></ul>'),
        baseUri: _ns(''),
      );
      listHandle = SwiftSoupBridge.select(doc, selector: _ns('li'));
    });

    test('size', () {
      check(SwiftSoupBridge.size(listHandle)).equals(3);
    });

    test('get by index', () {
      final int second = SwiftSoupBridge.get(listHandle, index: 1);
      check(_str(SwiftSoupBridge.text(second))).equals('b');
    });

    test('get out of bounds returns -1', () {
      check(SwiftSoupBridge.get(listHandle, index: 99)).equals(-1);
    });

    test('first and last', () {
      final int f = SwiftSoupBridge.first(listHandle);
      check(_str(SwiftSoupBridge.text(f))).equals('a');

      final int l = SwiftSoupBridge.last(listHandle);
      check(_str(SwiftSoupBridge.text(l))).equals('c');
    });
  });

  group('tree navigation', () {
    late int doc;

    setUp(() {
      doc = SwiftSoupBridge.parse(
        _ns('<div><span>a</span><span>b</span><span>c</span></div>'),
        baseUri: _ns(''),
      );
    });

    test('parent', () {
      final int span = SwiftSoupBridge.selectFirst(doc, selector: _ns('span'));
      final int p = SwiftSoupBridge.parent(span);
      check(_str(SwiftSoupBridge.tagName(p))).equals('div');
    });

    test('children', () {
      final int div = SwiftSoupBridge.selectFirst(doc, selector: _ns('div'));
      final int kids = SwiftSoupBridge.children(div);
      check(SwiftSoupBridge.size(kids)).equals(3);
    });

    test('nextSibling and prevSibling', () {
      final int listHandle = SwiftSoupBridge.select(doc, selector: _ns('span'));
      final int second = SwiftSoupBridge.get(listHandle, index: 1);

      final int next = SwiftSoupBridge.nextSibling(second);
      check(_str(SwiftSoupBridge.text(next))).equals('c');

      final int prev = SwiftSoupBridge.prevSibling(second);
      check(_str(SwiftSoupBridge.text(prev))).equals('a');
    });

    test('siblings', () {
      final int span = SwiftSoupBridge.selectFirst(doc, selector: _ns('span'));
      final int sibs = SwiftSoupBridge.siblings(span);
      // siblings excludes self
      check(SwiftSoupBridge.size(sibs)).equals(2);
    });
  });

  group('DOM mutation', () {
    test('remove element', () {
      final int doc = SwiftSoupBridge.parse(
        _ns('<div><p>keep</p><p>remove</p></div>'),
        baseUri: _ns(''),
      );
      final int listHandle = SwiftSoupBridge.select(doc, selector: _ns('p'));
      final int second = SwiftSoupBridge.get(listHandle, index: 1);
      SwiftSoupBridge.remove(second);

      final int remaining = SwiftSoupBridge.select(doc, selector: _ns('p'));
      check(SwiftSoupBridge.size(remaining)).equals(1);
    });

    test('append and prepend html', () {
      final int doc = SwiftSoupBridge.parse(
        _ns('<ul><li>b</li></ul>'),
        baseUri: _ns(''),
      );
      final int ul = SwiftSoupBridge.selectFirst(doc, selector: _ns('ul'));

      SwiftSoupBridge.prepend(ul, html: _ns('<li>a</li>'));
      SwiftSoupBridge.append(ul, html: _ns('<li>c</li>'));

      final int items = SwiftSoupBridge.select(doc, selector: _ns('li'));
      check(SwiftSoupBridge.size(items)).equals(3);

      final int first = SwiftSoupBridge.first(items);
      check(_str(SwiftSoupBridge.text(first))).equals('a');

      final int last = SwiftSoupBridge.last(items);
      check(_str(SwiftSoupBridge.text(last))).equals('c');
    });
  });

  group('element and text node creation', () {
    test('createElement', () {
      final int el = SwiftSoupBridge.createElement(_ns('span'));
      check(el).isGreaterThan(0);
      check(_str(SwiftSoupBridge.tagName(el))).equals('span');
    });

    test('createTextNode', () {
      final int tn = SwiftSoupBridge.createTextNode(_ns('hello'));
      check(tn).isGreaterThan(0);
      check(SwiftSoupBridge.isTextNode(tn)).isTrue();
      check(_str(SwiftSoupBridge.textNodeText(tn))).equals('hello');
    });

    test('createElements from handles', () {
      final int doc = SwiftSoupBridge.parse(
        _ns('<p>a</p><p>b</p>'),
        baseUri: _ns(''),
      );
      final int listHandle = SwiftSoupBridge.select(doc, selector: _ns('p'));
      final int h0 = SwiftSoupBridge.get(listHandle, index: 0);
      final int h1 = SwiftSoupBridge.get(listHandle, index: 1);

      final objc.NSMutableArray arr = objc.NSMutableArray.new$();
      arr.addObject(h0.toNSNumber());
      arr.addObject(h1.toNSNumber());

      final int created = SwiftSoupBridge.createElements(arr);
      check(SwiftSoupBridge.size(created)).equals(2);
    });
  });

  group('node-level methods', () {
    late int doc;

    setUp(() {
      doc = SwiftSoupBridge.parse(
        _ns('<div>hello<span>world</span></div>'),
        baseUri: _ns(''),
      );
    });

    test('nodeName', () {
      final int div = SwiftSoupBridge.selectFirst(doc, selector: _ns('div'));
      check(_str(SwiftSoupBridge.nodeName(div))).equals('div');
    });

    test('childNodeSize and childNode', () {
      final int div = SwiftSoupBridge.selectFirst(doc, selector: _ns('div'));
      final int count = SwiftSoupBridge.childNodeSize(div);
      check(count).equals(2); // text node + span

      // First child is a text node.
      final int first = SwiftSoupBridge.childNode(div, index: 0);
      check(SwiftSoupBridge.isTextNode(first)).isTrue();

      // Second child is the span element.
      final int second = SwiftSoupBridge.childNode(div, index: 1);
      check(SwiftSoupBridge.isTextNode(second)).isFalse();
      check(_str(SwiftSoupBridge.tagName(second))).equals('span');
    });

    test('childNodeHandles returns all child handles', () {
      final int div = SwiftSoupBridge.selectFirst(doc, selector: _ns('div'));
      final List<int> handles = _handleList(SwiftSoupBridge.childNodeHandles(div));
      check(handles.length).equals(2);
    });

    test('parentNode', () {
      final int span = SwiftSoupBridge.selectFirst(doc, selector: _ns('span'));
      final int p = SwiftSoupBridge.parentNode(span);
      check(_str(SwiftSoupBridge.nodeName(p))).equals('div');
    });

    test('nodeOuterHtml for element', () {
      final int span = SwiftSoupBridge.selectFirst(doc, selector: _ns('span'));
      check(_str(SwiftSoupBridge.nodeOuterHtml(span)))
          .equals('<span>world</span>');
    });

    test('removeNode', () {
      final int div = SwiftSoupBridge.selectFirst(doc, selector: _ns('div'));
      final int first = SwiftSoupBridge.childNode(div, index: 0);
      SwiftSoupBridge.removeNode(first);
      check(SwiftSoupBridge.childNodeSize(div)).equals(1);
    });
  });

  group('text node methods', () {
    late int textNode;

    setUp(() {
      final int doc = SwiftSoupBridge.parse(
        _ns('<p>  hello world  </p>'),
        baseUri: _ns(''),
      );
      final int p = SwiftSoupBridge.selectFirst(doc, selector: _ns('p'));
      final List<int> handles = _handleList(SwiftSoupBridge.textNodeHandles(p));
      textNode = handles.first;
    });

    test('isTextNode', () {
      check(SwiftSoupBridge.isTextNode(textNode)).isTrue();
    });

    test('textNodeText returns normalized text', () {
      check(_str(SwiftSoupBridge.textNodeText(textNode))).isNotNull();
    });

    test('textNodeWholeText preserves whitespace', () {
      final String? whole = _str(SwiftSoupBridge.textNodeWholeText(textNode));
      check(whole).isNotNull();
      check(whole!).contains('hello world');
    });

    test('setTextNodeText', () {
      SwiftSoupBridge.setTextNodeText(textNode, text: _ns('changed'));
      check(_str(SwiftSoupBridge.textNodeText(textNode))).equals('changed');
    });

    test('textNodeIsBlank', () {
      check(SwiftSoupBridge.textNodeIsBlank(textNode)).isFalse();

      final int blank = SwiftSoupBridge.createTextNode(_ns('   '));
      check(SwiftSoupBridge.textNodeIsBlank(blank)).isTrue();
    });
  });

  group('base URI', () {
    test('nodeBaseUri and setNodeBaseUri', () {
      final int doc = SwiftSoupBridge.parse(
        _ns('<p>x</p>'),
        baseUri: _ns('https://a.com'),
      );
      final int p = SwiftSoupBridge.selectFirst(doc, selector: _ns('p'));
      check(_str(SwiftSoupBridge.nodeBaseUri(p))).equals('https://a.com');

      SwiftSoupBridge.setNodeBaseUri(p, value: _ns('https://b.com'));
      check(_str(SwiftSoupBridge.nodeBaseUri(p))).equals('https://b.com');
    });
  });

  group('lifecycle', () {
    test('free releases handle', () {
      final int doc = SwiftSoupBridge.parse(_ns('<p>x</p>'), baseUri: _ns(''));
      final int p = SwiftSoupBridge.selectFirst(doc, selector: _ns('p'));
      check(p).isGreaterThan(0);

      SwiftSoupBridge.free(p);
      // After free, text should return null (handle not found).
      check(_str(SwiftSoupBridge.text(p))).isNull();
    });

    test('releaseAll clears all handles', () {
      final int doc = SwiftSoupBridge.parse(_ns('<p>x</p>'), baseUri: _ns(''));
      final int p = SwiftSoupBridge.selectFirst(doc, selector: _ns('p'));

      SwiftSoupBridge.releaseAll();

      check(_str(SwiftSoupBridge.text(doc))).isNull();
      check(_str(SwiftSoupBridge.text(p))).isNull();
    });

    test('dispose clears all handles', () {
      final int doc = SwiftSoupBridge.parse(_ns('<p>x</p>'), baseUri: _ns(''));
      SwiftSoupBridge.dispose();
      check(_str(SwiftSoupBridge.text(doc))).isNull();
    });
  });

  group('invalid handles', () {
    test('operations on invalid handle return sentinel values', () {
      check(SwiftSoupBridge.select(9999, selector: _ns('p'))).equals(-1);
      check(SwiftSoupBridge.selectFirst(9999, selector: _ns('p'))).equals(-1);
      check(_str(SwiftSoupBridge.attr(9999, key: _ns('x')))).isNull();
      check(SwiftSoupBridge.hasAttr(9999, key: _ns('x'))).isFalse();
      check(_str(SwiftSoupBridge.text(9999))).isNull();
      check(_str(SwiftSoupBridge.tagName(9999))).isNull();
      check(SwiftSoupBridge.parent(9999)).equals(-1);
      check(SwiftSoupBridge.children(9999)).equals(-1);
      check(SwiftSoupBridge.size(9999)).equals(-1);
      check(SwiftSoupBridge.childNodeSize(9999)).equals(0);
    });
  });
}
