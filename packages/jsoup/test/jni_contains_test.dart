@TestOn('vm')
@Tags(['jni'])
library;

import 'package:checks/checks.dart';
import 'package:jsoup/jsoup.dart';
import 'package:jsoup/src/jni/jni_parser.dart';
import 'package:test/scaffolding.dart';

/// Runs :contains() tests against the Java Jsoup JNI backend for
/// compatibility verification with the Rust scraper implementation.
///
/// Tagged 'jni' and excluded from default test runs because JNI tests crash
/// on Windows when combined with scraper tests in the same process (Dart VM
/// isolate teardown corrupts the JVM's VEH chain). Run separately:
///   dart test --reporter expanded -t jni
void main() {
  setUpAll(JreManager.ensureInitialized);

  late Jsoup jsoup;

  setUp(() {
    jsoup = Jsoup.fromParser(JsoupParser());
  });

  tearDown(() {
    jsoup.dispose();
  });

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
    final Elements els = doc.select('div:contains(First)');
    check(els.length).isGreaterOrEqual(1);
  });

  test(':containsOwn matches own text only', () {
    final Document d = jsoup.parse('<div>Hello <span>World</span></div>');
    final Elements els = d.select('div:containsOwn(Hello)');
    check(els.length).equals(1);
    final Elements noMatch = d.select('div:containsOwn(World)');
    check(noMatch.length).equals(0);
  });

  test(':contains with selectFirst', () {
    final Element? el = doc.selectFirst('li:contains(B)');
    check(el).isNotNull().has((e) => e.text, 'text').equals('B');
  });

  test(':contains with bare selector (no tag)', () {
    final Elements els = doc.select(':contains(Footer text)');
    check(els.length).isGreaterOrEqual(1);
  });

  test(':contains with parentheses in search text', () {
    final Document d =
        jsoup.parse('<p>One Piece (Digital Colored)</p><p>Other</p>');
    final Elements els =
        d.select('p:contains(One Piece (Digital Colored))');
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
    final Document d =
        jsoup.parse('<p>Hello World</p><p>hello world</p>');
    final Elements els = d.select('p:containsWholeText(Hello World)');
    check(els.length).equals(1);
    check(els[0].text).equals('Hello World');
  });

  test(':containsWholeOwnText matches own raw text', () {
    final Document d =
        jsoup.parse('<div>Own <span>Child</span></div>');
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
}
