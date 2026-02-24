@TestOn('vm')
library;

import 'package:checks/checks.dart';
import 'package:jsoup/jsoup.dart';
import 'package:test/scaffolding.dart';

void main() {
  setUpAll(JreManager.ensureInitialized);

  late Jsoup jsoup;

  setUp(() {
    jsoup = Jsoup();
  });

  tearDown(() {
    jsoup.dispose();
  });

  // -- Parsing --

  group('Jsoup.parse', () {
    test('parses full HTML document', () {
      final Document doc = jsoup.parse('<html><body><p>Hello</p></body></html>');
      final Element? p = doc.selectFirst('p');
      check(p).isNotNull().has((e) => e.text, 'text').equals('Hello');
    });

    test('parses with baseUri', () {
      final Document doc = jsoup.parse(
        '<a href="/path">link</a>',
        baseUri: 'https://example.com',
      );
      final Element a = doc.selectFirst('a')!;
      check(a.absUrl('href')).equals('https://example.com/path');
    });

    test('document tagName is #root', () {
      final Document doc = jsoup.parse('<p>hello</p>');
      check(doc.tagName).equals('#root');
    });

    test('document select finds body content', () {
      final Document doc = jsoup.parse('<html><body><p>hello</p></body></html>');
      check(doc.selectFirst('body')).isNotNull();
      check(doc.selectFirst('p')!.text).equals('hello');
    });

    test('baseUri propagates to child elements', () {
      final Document doc = jsoup.parse(
        '<div><a href="/page">link</a></div>',
        baseUri: 'https://example.com',
      );
      final Element a = doc.selectFirst('div a')!;
      check(a.baseUri).equals('https://example.com');
    });
  });

  group('Jsoup.parseFragment', () {
    test('parses HTML fragment', () {
      final Document doc = jsoup.parseFragment('<span>one</span><span>two</span>');
      final Elements spans = doc.select('span');
      check(spans.length).equals(2);
    });

    test('parses fragment with baseUri', () {
      final Document doc = jsoup.parseFragment(
        '<a href="/page">link</a>',
        baseUri: 'https://example.com',
      );
      final Element a = doc.selectFirst('a')!;
      check(a.absUrl('href')).equals('https://example.com/page');
    });
  });

  // -- CSS Selectors --

  group('CSS selectors', () {
    late Document doc;

    setUp(() {
      doc = jsoup.parse('''
        <div id="main" class="container">
          <p class="intro">First</p>
          <p>Second</p>
          <ul>
            <li>A</li>
            <li>B</li>
            <li>C</li>
          </ul>
        </div>
        <div class="footer">
          <p>Footer text</p>
        </div>
      ''');
    });

    test('select by tag name', () {
      check(doc.select('p').length).equals(3);
    });

    test('select by class', () {
      check(doc.select('.intro').length).equals(1);
    });

    test('select by id', () {
      final Element? el = doc.selectFirst('#main');
      check(el).isNotNull().has((e) => e.tagName, 'tagName').equals('div');
    });

    test('select by attribute', () {
      check(doc.select('[id]').length).equals(1);
    });

    test('nested selector (div > p)', () {
      check(doc.select('div > p').length).equals(3);
    });

    test('descendant selector (ul li)', () {
      check(doc.select('ul li').length).equals(3);
    });

    test('pseudo-selector :first-child', () {
      final Element? first = doc.selectFirst('li:first-child');
      check(first).isNotNull().has((e) => e.text, 'text').equals('A');
    });

    test('pseudo-selector :contains(text)', () {
      final Elements els = doc.select('p:contains(Footer)');
      check(els.length).equals(1);
      check(els[0].text).equals('Footer text');
    });

    test('selectFirst returns null when no match', () {
      check(doc.selectFirst('.nonexistent')).isNull();
    });

    test('select returns empty Elements when no match', () {
      final Elements result = doc.select('.nonexistent');
      check(result.length).equals(0);
      check(result.isEmpty).isTrue();
    });

    test('select with invalid selector returns empty', () {
      // JNI bridge returns -1 for invalid selectors, which maps to empty Elements
      final Elements result = doc.select('[[');
      check(result.isEmpty).isTrue();
    });
  });

  // -- Attributes --

  group('Attributes', () {
    late Element div;

    setUp(() {
      final Document doc = jsoup.parse(
        '<div id="test" class="foo bar" data-value="42"></div>',
      );
      div = doc.selectFirst('#test')!;
    });

    test('attr returns value', () {
      check(div.attr('data-value')).equals('42');
    });

    test('attr returns empty string for missing attribute', () {
      check(div.attr('data-missing')).equals('');
    });

    test('hasAttr true for existing attribute', () {
      check(div.hasAttr('data-value')).isTrue();
    });

    test('hasAttr false for missing attribute', () {
      check(div.hasAttr('data-missing')).isFalse();
    });

    test('setAttr / attr round-trip', () {
      div.setAttr('data-new', 'hello');
      check(div.attr('data-new')).equals('hello');
    });

    test('removeAttr removes attribute', () {
      div.removeAttr('data-value');
      check(div.hasAttr('data-value')).isFalse();
    });

    test('absUrl resolves relative URL', () {
      final Document doc = jsoup.parse(
        '<a href="/about">About</a>',
        baseUri: 'https://example.com/page',
      );
      final Element a = doc.selectFirst('a')!;
      check(a.absUrl('href')).equals('https://example.com/about');
    });

    test('absUrl returns empty for missing attribute', () {
      final Document doc = jsoup.parse('<div></div>', baseUri: 'https://example.com');
      final Element div = doc.selectFirst('div')!;
      check(div.absUrl('href')).equals('');
    });
  });

  // -- Text & HTML --

  group('Text & HTML', () {
    test('text returns combined descendant text', () {
      final Document doc = jsoup.parse('<div>Hello <span>World</span></div>');
      check(doc.selectFirst('div')!.text).equals('Hello World');
    });

    test('ownText returns direct text only', () {
      final Document doc = jsoup.parse('<div>Hello <span>World</span></div>');
      check(doc.selectFirst('div')!.ownText).equals('Hello');
    });

    test('html returns inner HTML', () {
      final Document doc = jsoup.parse('<div><p>text</p></div>');
      final String inner = doc.selectFirst('div')!.html;
      check(inner).contains('<p>');
      check(inner).contains('text');
    });

    test('outerHtml returns element with tag', () {
      final Document doc = jsoup.parse('<p>hello</p>');
      final String outer = doc.selectFirst('p')!.outerHtml;
      check(outer).startsWith('<p>');
      check(outer).endsWith('</p>');
    });

    test('data returns script content', () {
      final Document doc = jsoup.parse('<script>var x = 1;</script>');
      check(doc.selectFirst('script')!.data).contains('var x = 1');
    });

    test('text setter replaces text', () {
      final Document doc = jsoup.parse('<p>old</p>');
      final Element p = doc.selectFirst('p')!;
      p.text = 'new';
      check(p.text).equals('new');
    });

    test('html setter replaces inner HTML', () {
      final Document doc = jsoup.parse('<div>old</div>');
      final Element div = doc.selectFirst('div')!;
      div.html = '<em>new</em>';
      check(div.selectFirst('em')).isNotNull();
      check(div.text).equals('new');
    });
  });

  // -- Identity --

  group('Identity', () {
    test('tagName', () {
      final Document doc = jsoup.parse('<article>x</article>');
      check(doc.selectFirst('article')!.tagName).equals('article');
    });

    test('id', () {
      final Document doc = jsoup.parse('<div id="myid"></div>');
      check(doc.selectFirst('div')!.id).equals('myid');
    });

    test('className', () {
      final Document doc = jsoup.parse('<div class="a b"></div>');
      check(doc.selectFirst('div')!.className).equals('a b');
    });

    test('hasClass / addClass / removeClass', () {
      final Document doc = jsoup.parse('<div class="a"></div>');
      final Element div = doc.selectFirst('div')!;
      check(div.hasClass('a')).isTrue();
      check(div.hasClass('b')).isFalse();

      div.addClass('b');
      check(div.hasClass('b')).isTrue();

      div.removeClass('a');
      check(div.hasClass('a')).isFalse();
    });
  });

  // -- Navigation --

  group('Navigation', () {
    late Document doc;

    setUp(() {
      doc = jsoup.parse('''
        <div>
          <p id="first">A</p>
          <p id="second">B</p>
          <p id="third">C</p>
        </div>
      ''');
    });

    test('parent returns parent element', () {
      final Element p = doc.selectFirst('#first')!;
      check(p.parent).isNotNull().has((e) => e.tagName, 'tagName').equals('div');
    });

    test('children returns child elements', () {
      final Element div = doc.selectFirst('div')!;
      check(div.children.length).equals(3);
    });

    test('nextElementSibling', () {
      final Element first = doc.selectFirst('#first')!;
      check(first.nextElementSibling)
          .isNotNull()
          .has((e) => e.id, 'id')
          .equals('second');
    });

    test('previousElementSibling', () {
      final Element second = doc.selectFirst('#second')!;
      check(second.previousElementSibling)
          .isNotNull()
          .has((e) => e.id, 'id')
          .equals('first');
    });

    test('nextElementSibling returns null for last', () {
      final Element third = doc.selectFirst('#third')!;
      check(third.nextElementSibling).isNull();
    });

    test('previousElementSibling returns null for first', () {
      final Element first = doc.selectFirst('#first')!;
      check(first.previousElementSibling).isNull();
    });

    test('siblingElements excludes self', () {
      final Element second = doc.selectFirst('#second')!;
      final Elements siblings = second.siblingElements;
      check(siblings.length).equals(2);
    });

    test('textNodes returns direct text nodes', () {
      final Document doc = jsoup.parse('<p>Hello <b>world</b> end</p>');
      final List<TextNode> nodes = doc.selectFirst('p')!.textNodes;
      check(nodes.length).equals(2);
      check(nodes[0].text).equals('Hello ');
      check(nodes[1].text).equals(' end');
    });

    test('childNodes returns mixed elements and text nodes', () {
      final Document doc = jsoup.parse('<p>text<b>bold</b>more</p>');
      final List<Node> nodes = doc.selectFirst('p')!.childNodes;
      check(nodes.length).equals(3);
      check(nodes[0]).isA<TextNode>();
      check(nodes[1]).isA<Element>();
      check(nodes[2]).isA<TextNode>();
    });
  });

  // -- Mutation --

  group('Mutation', () {
    test('remove() detaches element from parent', () {
      final Document doc = jsoup.parse('<div><p>keep</p><p>remove</p></div>');
      final Element toRemove = doc.select('p')[1];
      toRemove.remove();
      check(doc.select('p').length).equals(1);
      check(doc.selectFirst('p')!.text).equals('keep');
    });

    test('prepend adds HTML at the start', () {
      final Document doc = jsoup.parse('<div><p>existing</p></div>');
      doc.selectFirst('div')!.prepend('<span>first</span>');
      final Element first = doc.selectFirst('div')!.children[0];
      check(first.tagName).equals('span');
      check(first.text).equals('first');
    });

    test('append adds HTML at the end', () {
      final Document doc = jsoup.parse('<div><p>existing</p></div>');
      doc.selectFirst('div')!.append('<span>last</span>');
      final Elements children = doc.selectFirst('div')!.children;
      check(children[children.length - 1].tagName).equals('span');
    });
  });

  // -- Node base class --

  group('Node', () {
    test('nodeName returns tag for elements', () {
      final Document doc = jsoup.parse('<p>text</p>');
      check(doc.selectFirst('p')!.nodeName).equals('p');
    });

    test('nodeName returns #text for text nodes', () {
      final Document doc = jsoup.parse('<p>text</p>');
      final List<Node> nodes = doc.selectFirst('p')!.childNodes;
      check(nodes[0].nodeName).equals('#text');
    });

    test('parentNode returns parent as Element', () {
      final Document doc = jsoup.parse('<div><p>text</p></div>');
      final Element p = doc.selectFirst('p')!;
      check(p.parentNode).isNotNull().isA<Element>();
    });

    test('childNode by index', () {
      final Document doc = jsoup.parse('<div><p>A</p><p>B</p></div>');
      final Element div = doc.selectFirst('div')!;
      final Node child = div.childNode(0);
      check(child).isA<Element>();
    });

    test('childNode throws RangeError for invalid index', () {
      final Document doc = jsoup.parse('<div></div>');
      final Element div = doc.selectFirst('div')!;
      check(() => div.childNode(5)).throws<RangeError>();
    });

    test('childNodeSize returns count', () {
      final Document doc = jsoup.parse('<div><p>A</p><p>B</p></div>');
      final Element div = doc.selectFirst('div')!;
      check(div.childNodeSize).isGreaterOrEqual(2);
    });

    test('outerHtml on node', () {
      final Document doc = jsoup.parse('<p>hello</p>');
      final Node node = doc.selectFirst('p')!;
      check(node.outerHtml).contains('hello');
    });

    test('baseUri get/set', () {
      final Document doc = jsoup.parse('<p>x</p>', baseUri: 'https://a.com');
      final Element p = doc.selectFirst('p')!;
      check(p.baseUri).equals('https://a.com');
      p.baseUri = 'https://b.com';
      check(p.baseUri).equals('https://b.com');
    });

    test('remove on node', () {
      final Document doc = jsoup.parse('<div>text<p>child</p></div>');
      final Element div = doc.selectFirst('div')!;
      final int initialSize = div.childNodeSize;
      div.childNode(0).remove();
      check(div.childNodeSize).equals(initialSize - 1);
    });
  });

  // -- TextNode --

  group('TextNode', () {
    test('text get/set', () {
      final TextNode tn = jsoup.textNode('hello');
      check(tn.text).equals('hello');
      tn.text = 'world';
      check(tn.text).equals('world');
    });

    test('wholeText preserves whitespace', () {
      final Document doc = jsoup.parse('<p>  spaced  </p>');
      final List<TextNode> nodes = doc.selectFirst('p')!.textNodes;
      check(nodes).isNotEmpty();
      check(nodes[0].wholeText).contains('  spaced  ');
    });

    test('isBlank true for whitespace-only', () {
      final TextNode tn = jsoup.textNode('   ');
      check(tn.isBlank).isTrue();
    });

    test('isBlank false for non-empty text', () {
      final TextNode tn = jsoup.textNode('hello');
      check(tn.isBlank).isFalse();
    });

    test('nodeName is #text', () {
      final TextNode tn = jsoup.textNode('x');
      check(tn.nodeName).equals('#text');
    });
  });

  // -- Elements collection --

  group('Elements', () {
    test('length and indexing', () {
      final Document doc = jsoup.parse('<ul><li>A</li><li>B</li><li>C</li></ul>');
      final Elements lis = doc.select('li');
      check(lis.length).equals(3);
      check(lis[0].text).equals('A');
      check(lis[1].text).equals('B');
      check(lis[2].text).equals('C');
    });

    test('iteration', () {
      final Document doc = jsoup.parse('<ul><li>A</li><li>B</li></ul>');
      final List<String> texts = doc.select('li').map((e) => e.text).toList();
      check(texts).deepEquals(['A', 'B']);
    });

    test('empty collection', () {
      final Document doc = jsoup.parse('<div></div>');
      final Elements empty = doc.select('.none');
      check(empty.length).equals(0);
      check(empty.isEmpty).isTrue();
    });

    test('Elements constructor from list', () {
      final Element a = jsoup.element('span');
      final Element b = jsoup.element('span');
      final Elements collection = jsoup.elements([a, b]);
      check(collection.length).equals(2);
    });

    test('[] throws RangeError for invalid index', () {
      final Document doc = jsoup.parse('<p>x</p>');
      final Elements els = doc.select('p');
      check(() => els[5]).throws<RangeError>();
    });

    test('baseUri delegates to first element', () {
      final Document doc = jsoup.parse(
        '<ul><li>A</li><li>B</li></ul>',
        baseUri: 'https://example.com',
      );
      final Elements lis = doc.select('li');
      check(lis.baseUri).equals('https://example.com');
    });

    test('baseUri returns empty for empty collection', () {
      final Document doc = jsoup.parse('<div></div>');
      final Elements empty = doc.select('.none');
      check(empty.baseUri).equals('');
    });
  });

  // -- Element creation --

  group('Element creation', () {
    test('jsoup.element creates standalone element', () {
      final Element el = jsoup.element('div');
      check(el.tagName).equals('div');
      check(el.parent).isNull();
    });

    test('jsoup.textNode creates standalone text node', () {
      final TextNode tn = jsoup.textNode('hello');
      check(tn.text).equals('hello');
    });

    test('jsoup.elements creates collection', () {
      final Elements els = jsoup.elements([
        jsoup.element('a'),
        jsoup.element('b'),
      ]);
      check(els.length).equals(2);
    });
  });

  // -- Resource lifecycle --

  group('Resource lifecycle', () {
    test('dispose completes without error', () {
      final j = Jsoup();
      j.parse('<p>test</p>');
      j.dispose();
    });

    test('multiple dispose calls do not throw', () {
      final j = Jsoup();
      j.dispose();
      j.dispose();
    });
  });
}
