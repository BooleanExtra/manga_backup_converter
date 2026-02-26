import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/import_context.dart';
import 'package:jsoup/jsoup.dart';

/// `html` module host imports.
Map<String, Function> buildHtmlImports(ImportContext ctx) => <String, Function>{
  'parse': (int ptr, int len, [int? baseUriPtr, int? baseUriLen]) {
    if (ctx.joup == null) return -1;
    try {
      final String html = ctx.readString(ptr, len);
      final String baseUri = baseUriPtr != null && baseUriLen != null && baseUriLen > 0
          ? ctx.readString(baseUriPtr, baseUriLen)
          : '';
      final Document doc = ctx.joup!.parse(html, baseUri: baseUri);
      return ctx.store.add(HtmlElementResource(doc));
    } on Object catch (e) {
      ctx.onLog?.call('[CB] html::parse failed: $e');
      return -1;
    }
  },
  'parse_fragment': (int ptr, int len, [int? baseUriPtr, int? baseUriLen]) {
    if (ctx.joup == null) return -1;
    try {
      final String html = ctx.readString(ptr, len);
      final String baseUri = baseUriPtr != null && baseUriLen != null && baseUriLen > 0
          ? ctx.readString(baseUriPtr, baseUriLen)
          : '';
      final Document doc = ctx.joup!.parseFragment(html, baseUri: baseUri);
      return ctx.store.add(HtmlElementResource(doc));
    } on Object catch (e) {
      ctx.onLog?.call('[CB] html::parse_fragment failed: $e');
      return -1;
    }
  },
  'select': (int rid, int selectorPtr, int selectorLen) {
    if (ctx.joup == null) return -1;
    try {
      final String selector = ctx.readString(selectorPtr, selectorLen);
      final HtmlElementResource? res = ctx.store.get<HtmlElementResource>(rid);
      if (res != null) {
        return ctx.store.add(HtmlElementsResource(res.element.select(selector)));
      }
      final HtmlElementsResource? listRes = ctx.store.get<HtmlElementsResource>(rid);
      if (listRes == null || listRes.elements.isEmpty) return -1;
      return ctx.store.add(
        HtmlElementsResource(listRes.elements.first.select(selector)),
      );
    } on Object catch (e) {
      ctx.onLog?.call('[CB] html::select failed: $e');
      return -1;
    }
  },
  'select_first': (int rid, int selectorPtr, int selectorLen) {
    if (ctx.joup == null) return -1;
    try {
      final String selector = ctx.readString(selectorPtr, selectorLen);
      final HtmlElementResource? res = ctx.store.get<HtmlElementResource>(rid);
      if (res != null) {
        final Element? el = res.element.selectFirst(selector);
        if (el == null) return -1;
        return ctx.store.add(HtmlElementResource(el));
      }
      final HtmlElementsResource? listRes = ctx.store.get<HtmlElementsResource>(rid);
      if (listRes == null || listRes.elements.isEmpty) return -1;
      final Element? el = listRes.elements.first.selectFirst(selector);
      if (el == null) return -1;
      return ctx.store.add(HtmlElementResource(el));
    } on Object catch (e) {
      ctx.onLog?.call('[CB] html::select_first failed: $e');
      return -1;
    }
  },
  'attr': (int rid, int keyPtr, int keyLen) {
    if (ctx.joup == null) return -1;
    try {
      final HtmlElementResource? res = ctx.store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      final String key = ctx.readString(keyPtr, keyLen);
      final String value;
      if (key.startsWith('abs:')) {
        value = res.element.absUrl(key.substring(4));
      } else {
        value = res.element.attr(key);
      }
      return ctx.storeString(value);
    } on Object catch (e) {
      ctx.onLog?.call('[CB] html::attr failed: $e');
      return -1;
    }
  },
  'has_attr': (int rid, int keyPtr, int keyLen) {
    if (ctx.joup == null) return 0;
    try {
      final HtmlElementResource? res = ctx.store.get<HtmlElementResource>(rid);
      if (res == null) return 0;
      return res.element.hasAttr(ctx.readString(keyPtr, keyLen)) ? 1 : 0;
    } on Object {
      return 0;
    }
  },

  // --- String property helpers (10 functions) ---
  'text': (int rid) => ctx.elementStringProp(rid, 'text', (e) => e.text),
  'own_text': (int rid) => ctx.elementStringProp(rid, 'own_text', (e) => e.ownText),
  'untrimmed_text': (int rid) => ctx.elementStringProp(rid, 'untrimmed_text', (e) => e.text),
  'html': (int rid) => ctx.elementStringProp(rid, 'html', (e) => e.html),
  'outer_html': (int rid) => ctx.elementStringProp(rid, 'outer_html', (e) => e.outerHtml),
  'tag_name': (int rid) => ctx.elementStringProp(rid, 'tag_name', (e) => e.tagName),
  'id': (int rid) => ctx.elementStringProp(rid, 'id', (e) => e.id),
  'class_name': (int rid) => ctx.elementStringProp(rid, 'class_name', (e) => e.className),
  'base_uri': (int rid) => ctx.elementStringProp(rid, 'base_uri', (e) => e.baseUri),
  'data': (int rid) => ctx.elementStringProp(rid, 'data', (e) => e.data),

  // --- Navigation helpers (3 functions) ---
  'parent': (int rid) => ctx.elementNav(rid, 'parent', (e) => e.parent),
  'next': (int rid) => ctx.elementNav(rid, 'next', (e) => e.nextElementSibling),
  'previous': (int rid) => ctx.elementNav(rid, 'previous', (e) => e.previousElementSibling),

  // --- Elements-at helpers (4 functions) ---
  'first': (int rid) => ctx.elementsAt(rid, 0, 'first'),
  'last': (int rid) {
    if (ctx.joup == null) return -1;
    try {
      final HtmlElementsResource? res = ctx.store.get<HtmlElementsResource>(rid);
      if (res == null || res.elements.isEmpty) return -1;
      return ctx.store.add(HtmlElementResource(res.elements.last));
    } on Object catch (e) {
      ctx.onLog?.call('[CB] html::last failed: $e');
      return -1;
    }
  },
  'get': (int rid, int index) => ctx.elementsAt(rid, index, 'get'),
  'html_get': (int rid, int index) => ctx.elementsAt(rid, index, 'html_get'),

  // --- Elements size ---
  'size': (int rid) {
    if (ctx.joup == null) return -1;
    try {
      final HtmlElementsResource? res = ctx.store.get<HtmlElementsResource>(rid);
      if (res == null) return -1;
      return res.elements.length;
    } on Object catch (e) {
      ctx.onLog?.call('[CB] html::size failed: $e');
      return -1;
    }
  },

  // --- Children / siblings (return Elements) ---
  'children': (int rid) {
    if (ctx.joup == null) return -1;
    try {
      final HtmlElementResource? res = ctx.store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return ctx.store.add(HtmlElementsResource(res.element.children));
    } on Object catch (e) {
      ctx.onLog?.call('[CB] html::children failed: $e');
      return -1;
    }
  },
  'siblings': (int rid) {
    if (ctx.joup == null) return -1;
    try {
      final HtmlElementResource? res = ctx.store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return ctx.store.add(HtmlElementsResource(res.element.siblingElements));
    } on Object catch (e) {
      ctx.onLog?.call('[CB] html::siblings failed: $e');
      return -1;
    }
  },

  // --- Mutation helpers (9 functions) ---
  'set_text': (int rid, int ptr, int len) => ctx.elementMutate(
    rid,
    'set_text',
    (e) => e.text = ctx.readString(ptr, len),
  ),
  'set_html': (int rid, int ptr, int len) => ctx.elementMutate(
    rid,
    'set_html',
    (e) => e.html = ctx.readString(ptr, len),
  ),
  'remove': (int rid) => ctx.elementMutate(rid, 'remove', (e) => e.remove()),
  'add_class': (int rid, int classPtr, int classLen) => ctx.elementMutate(
    rid,
    'add_class',
    (e) => e.addClass(ctx.readString(classPtr, classLen)),
  ),
  'remove_class': (int rid, int classPtr, int classLen) => ctx.elementMutate(
    rid,
    'remove_class',
    (e) => e.removeClass(ctx.readString(classPtr, classLen)),
  ),
  'set_attr': (int rid, int keyPtr, int keyLen, int valPtr, int valLen) => ctx.elementMutate(
    rid,
    'set_attr',
    (e) => e.setAttr(
      ctx.readString(keyPtr, keyLen),
      ctx.readString(valPtr, valLen),
    ),
  ),
  'remove_attr': (int rid, int keyPtr, int keyLen) => ctx.elementMutate(
    rid,
    'remove_attr',
    (e) => e.removeAttr(ctx.readString(keyPtr, keyLen)),
  ),
  'prepend': (int rid, int ptr, int len) => ctx.elementMutate(
    rid,
    'prepend',
    (e) => e.prepend(ctx.readString(ptr, len)),
  ),
  'append': (int rid, int ptr, int len) => ctx.elementMutate(
    rid,
    'append',
    (e) => e.append(ctx.readString(ptr, len)),
  ),

  // --- Escape / unescape (work without htmlParser) ---
  'escape': (int ptr, int len) {
    final String str = ctx.readString(ptr, len);
    final String escaped = str
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');
    return ctx.storeString(escaped);
  },
  'unescape': (int ptr, int len) {
    final String str = ctx.readString(ptr, len);
    final String unescaped = str
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#39;', "'");
    return ctx.storeString(unescaped);
  },

  // --- has_class (returns bool as 0/1) ---
  'has_class': (int rid, int classPtr, int classLen) {
    if (ctx.joup == null) return 0;
    try {
      final HtmlElementResource? res = ctx.store.get<HtmlElementResource>(rid);
      if (res == null) return 0;
      return res.element.hasClass(ctx.readString(classPtr, classLen)) ? 1 : 0;
    } on Object {
      return 0;
    }
  },
};
