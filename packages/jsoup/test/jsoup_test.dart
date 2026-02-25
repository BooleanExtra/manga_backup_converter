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

    test(':contains is case-insensitive', () {
      final Elements els = doc.select('p:contains(footer)');
      check(els.length).equals(1);
      check(els[0].text).equals('Footer text');
    });

    test(':contains matches descendant text', () {
      // "First" is inside <p class="intro"> which is inside <div id="main">
      final Elements els = doc.select('div:contains(First)');
      check(els.length).isGreaterOrEqual(1);
    });

    test(':containsOwn matches own text only', () {
      final Document d = jsoup.parse('<div>Hello <span>World</span></div>');
      // div's own text is "Hello ", span's own text is "World"
      final Elements els = d.select('div:containsOwn(Hello)');
      check(els.length).equals(1);
      // :containsOwn(World) should NOT match div (only the span has "World" as own text)
      final Elements noMatch = d.select('div:containsOwn(World)');
      check(noMatch.length).equals(0);
    });

    test(':contains with selectFirst', () {
      final Element? el = doc.selectFirst('li:contains(B)');
      check(el).isNotNull().has((e) => e.text, 'text').equals('B');
    });

    test(':contains with bare selector (no tag)', () {
      final Elements els = doc.select(':contains(Footer text)');
      // Should match elements that contain "Footer text"
      check(els.length).isGreaterOrEqual(1);
    });

    test(':contains with parentheses in search text', () {
      final Document d = jsoup.parse('<p>One Piece (Digital Colored)</p><p>Other</p>');
      final Elements els = d.select('p:contains(One Piece (Digital Colored))');
      check(els.length).equals(1);
      check(els[0].text).equals('One Piece (Digital Colored)');
    });

    test('chained :contains filters (both must match)', () {
      final Document d = jsoup.parse('''
        <p>Hello World</p>
        <p>Hello</p>
        <p>World</p>
      ''');
      final Elements els = d.select('p:contains(Hello):contains(World)');
      check(els.length).equals(1);
      check(els[0].text).equals('Hello World');
    });

    test(':containsWholeText is case-sensitive', () {
      final Document d = jsoup.parse('<p>Hello World</p><p>hello world</p>');
      final Elements els = d.select('p:containsWholeText(Hello World)');
      check(els.length).equals(1);
      check(els[0].text).equals('Hello World');
    });

    test(':containsWholeOwnText matches own raw text', () {
      final Document d = jsoup.parse('<div>Own <span>Child</span></div>');
      // div's own text is "Own ", span's is "Child"
      final Elements els = d.select('div:containsWholeOwnText(Own )');
      check(els.length).equals(1);
    });

    test(':containsData matches script content', () {
      final Document d = jsoup.parse(
        '<script>var x = 42;</script><script>var y = 0;</script>',
      );
      final Elements els = d.select('script:containsData(var x)');
      check(els.length).equals(1);
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
      check(first.nextElementSibling).isNotNull().has((e) => e.id, 'id').equals('second');
    });

    test('previousElementSibling', () {
      final Element second = doc.selectFirst('#second')!;
      check(second.previousElementSibling).isNotNull().has((e) => e.id, 'id').equals('first');
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
      // TextNode.text normalizes whitespace (like Jsoup); use wholeText for raw
      check(nodes[0].text).equals('Hello');
      check(nodes[1].text).equals('end');
      check(nodes[0].wholeText).equals('Hello ');
      check(nodes[1].wholeText).equals(' end');
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

  // -- Scraper/Jsoup parity --

  group('Parity: text() whitespace normalization', () {
    test('text() collapses whitespace runs to single space', () {
      final Document doc = jsoup.parse('<div>  Hello   World  </div>');
      check(doc.selectFirst('div')!.text).equals('Hello World');
    });

    test('text() normalizes nested element whitespace', () {
      final Document doc = jsoup.parse(
        '<div>\n  <span>  A  </span>\n  <span>  B  </span>\n</div>',
      );
      check(doc.selectFirst('div')!.text).equals('A B');
    });

    test('text() trims leading/trailing whitespace', () {
      final Document doc = jsoup.parse('<p>   trimmed   </p>');
      check(doc.selectFirst('p')!.text).equals('trimmed');
    });
  });

  group('Parity: TextNode.text vs wholeText normalization', () {
    test('TextNode.text normalizes whitespace', () {
      final Document doc = jsoup.parse('<p>  spaced  text  </p>');
      final List<TextNode> nodes = doc.selectFirst('p')!.textNodes;
      check(nodes).isNotEmpty();
      check(nodes[0].text).equals('spaced text');
    });

    test('TextNode.wholeText preserves raw whitespace', () {
      final Document doc = jsoup.parse('<p>  spaced  text  </p>');
      final List<TextNode> nodes = doc.selectFirst('p')!.textNodes;
      check(nodes).isNotEmpty();
      check(nodes[0].wholeText).contains('  spaced  text  ');
    });
  });

  group('Parity: nodeOuterHtml text escaping', () {
    test('outerHtml on text node escapes HTML entities', () {
      final Document doc = jsoup.parse('<p>1 &lt; 2 &amp; 3 &gt; 0</p>');
      final List<Node> nodes = doc.selectFirst('p')!.childNodes;
      final String outer = nodes[0].outerHtml;
      check(outer).contains('&lt;');
      check(outer).contains('&amp;');
      check(outer).contains('&gt;');
    });
  });

  group('Parity: absUrl with empty base URI', () {
    test('absUrl returns empty for relative URL without baseUri', () {
      final Document doc = jsoup.parse('<a href="/path">link</a>');
      final Element a = doc.selectFirst('a')!;
      check(a.absUrl('href')).equals('');
    });

    test('absUrl returns absolute URL even without baseUri', () {
      final Document doc =
          jsoup.parse('<a href="https://example.com/page">link</a>');
      final Element a = doc.selectFirst('a')!;
      check(a.absUrl('href')).equals('https://example.com/page');
    });
  });

  group('Parity: data() element tag check', () {
    test('data() returns content for script elements', () {
      final Document doc = jsoup.parse('<script>var x = 1;</script>');
      check(doc.selectFirst('script')!.data).contains('var x = 1');
    });

    test('data() returns content for style elements', () {
      final Document doc = jsoup.parse('<style>body { color: red; }</style>');
      check(doc.selectFirst('style')!.data).contains('color: red');
    });

    test('data() returns empty for non-data elements', () {
      final Document doc = jsoup.parse('<div>Hello</div>');
      check(doc.selectFirst('div')!.data).equals('');
    });

    test('data() returns empty for p elements', () {
      final Document doc = jsoup.parse('<p>text</p>');
      check(doc.selectFirst('p')!.data).equals('');
    });
  });

  group('Parity: className returns empty for classless elements', () {
    test('className returns empty string when no class attribute', () {
      final Document doc = jsoup.parse('<div></div>');
      check(doc.selectFirst('div')!.className).equals('');
    });
  });

  group('Parity: :matches() and :matchesOwn()', () {
    test(':matches(regex) filters by all text', () {
      final Document doc = jsoup.parse('''
        <div><p>Chapter 123</p></div>
        <div><p>Volume 1</p></div>
      ''');
      final Elements els = doc.select('div:matches(Chapter \\d+)');
      check(els.length).equals(1);
      check(els[0].text).contains('Chapter 123');
    });

    test(':matchesOwn(regex) filters by own text only', () {
      final Document doc =
          jsoup.parse('<div>Item 42<span>Child</span></div>');
      final Elements els = doc.select('div:matchesOwn(Item \\d+)');
      check(els.length).equals(1);
    });

    test(':matchesOwn(regex) does not match child text', () {
      final Document doc =
          jsoup.parse('<div>Parent<span>Item 42</span></div>');
      final Elements els = doc.select('div:matchesOwn(Item \\d+)');
      check(els.length).equals(0);
    });

    test(':matches with invalid regex returns empty', () {
      final Document doc = jsoup.parse('<p>text</p>');
      final Elements els = doc.select('p:matches([invalid)');
      check(els.isEmpty).isTrue();
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
