// ignore_for_file: lines_longer_than_80_chars

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Names of jsoup-specific pseudo-selectors that are not standard CSS.
const Set<String> _jsoupPseudoNames = <String>{
  'contains',
  'containsOwn',
  'containsWholeText',
  'containsWholeOwnText',
  'containsData',
  'matches',
  'matchesOwn',
  'matchesWholeText',
  'matchesWholeOwnText',
};

/// Result of parsing a selector that may contain jsoup-specific
/// pseudo-selectors.
typedef ParsedSelector = ({
  String cssSelector,
  List<bool Function(JSFunction $, JSObject el)> filters,
});

/// Parse a CSS selector that may contain jsoup-specific pseudo-selectors.
///
/// Returns the cleaned CSS selector and a list of Dart filter functions
/// that must be applied to the Cheerio results.
///
/// **Limitation**: Jsoup pseudo-selectors mid-chain (e.g. `div:contains(x) > a`)
/// apply the filter to the FINAL matched elements, not the intermediate segment.
/// In practice, Aidoku plugins always use pseudo-selectors at the end of a
/// selector chain, so this does not cause issues.
ParsedSelector parseJsoupSelector(String selector) {
  final filters = <bool Function(JSFunction $, JSObject el)>[];
  var remaining = selector;
  final css = StringBuffer();

  while (remaining.isNotEmpty) {
    // Find the next ':' that might be a jsoup pseudo-selector.
    var colonIdx = -1;
    var inBrackets = 0;
    for (var i = 0; i < remaining.length; i++) {
      final String ch = remaining[i];
      if (ch == '[') {
        inBrackets++;
      } else if (ch == ']') {
        inBrackets--;
      } else if (ch == ':' && inBrackets == 0) {
        final String after = remaining.substring(i + 1);
        String? matchedName;
        for (final String name in _jsoupPseudoNames) {
          if (after.startsWith('$name(')) {
            matchedName = name;
            break;
          }
        }
        if (matchedName != null) {
          colonIdx = i;
          break;
        }
      }
    }

    if (colonIdx < 0) {
      css.write(remaining);
      break;
    }

    // Add the CSS part before this pseudo-selector.
    css.write(remaining.substring(0, colonIdx));

    // Extract the pseudo-selector name and argument.
    final String afterColon = remaining.substring(colonIdx + 1);
    String? name;
    for (final String n in _jsoupPseudoNames) {
      if (afterColon.startsWith('$n(')) {
        name = n;
        break;
      }
    }

    // Find the matching closing paren (balanced).
    final int argStart = name!.length + 1; // after "name("
    var depth = 1;
    var argEnd = argStart;
    for (; argEnd < afterColon.length && depth > 0; argEnd++) {
      if (afterColon[argEnd] == '(') depth++;
      if (afterColon[argEnd] == ')') depth--;
    }
    final String arg = afterColon.substring(argStart, argEnd - 1);

    filters.add(_buildFilter(name, arg));
    remaining = afterColon.substring(argEnd);
  }

  return (
    cssSelector: css.toString().trim(),
    filters: filters,
  );
}

/// Run a jsoup-aware CSS select on a Cheerio context.
///
/// [cheerio$] is the `$` function from `cheerio.load()`.
/// [context] is a domhandler node (element).
/// [selector] is the full selector (possibly with jsoup pseudo-selectors).
///
/// Returns a `List<JSObject>` of matching domhandler element nodes.
List<JSObject> jsoupSelect(
  JSFunction cheerio$,
  JSObject context,
  String selector,
) {
  final ParsedSelector parsed = parseJsoupSelector(selector);
  final String css = parsed.cssSelector.isEmpty ? '*' : parsed.cssSelector;

  List<JSObject> results;
  try {
    // $(context).find(css).toArray()
    final wrapped = cheerio$.callAsFunction(null, context)! as JSObject;
    final found = wrapped.callMethod('find'.toJS, css.toJS)! as JSObject;
    final arr = found.callMethod('toArray'.toJS)! as JSArray<JSObject>;
    results = arr.toDart;
  } on Object catch (_) {
    return <JSObject>[];
  }

  for (final bool Function(JSFunction $, JSObject el) filter in parsed.filters) {
    results = results.where((JSObject el) => filter(cheerio$, el)).toList();
  }
  return results;
}

// ---------------------------------------------------------------------------
// Text helpers
// ---------------------------------------------------------------------------

/// Get the own text of an element (direct text node children only), trimmed.
String getOwnText(JSFunction $, JSObject el) {
  return _collectTextNodeData($, el).trim();
}

/// Get the own text of an element, preserving whitespace.
String _getOwnWholeText(JSFunction $, JSObject el) {
  return _collectTextNodeData($, el);
}

/// Collect raw text node data from direct children.
String _collectTextNodeData(JSFunction $, JSObject el) {
  final wrapped = $.callAsFunction(null, el)! as JSObject;
  final contents = wrapped.callMethod('contents'.toJS)! as JSObject;
  final arr = contents.callMethod('toArray'.toJS)! as JSArray<JSObject>;
  final buf = StringBuffer();
  for (final JSObject node in arr.toDart) {
    final JSAny? type = node.getProperty('type'.toJS);
    if (type.dartify() == 'text') {
      final JSAny? data = node.getProperty('data'.toJS);
      if (data != null && !data.isUndefinedOrNull) {
        buf.write((data as JSString).toDart);
      }
    }
  }
  return buf.toString();
}

/// Get data text (script/style content, comments, or fallback to text).
String _getDataText(JSFunction $, JSObject el) {
  final JSAny? nameVal = el.getProperty('name'.toJS);
  final String tagName = nameVal.isUndefinedOrNull ? '' : (nameVal! as JSString).toDart.toLowerCase();
  if (tagName == 'script' || tagName == 'style') {
    final wrapped = $.callAsFunction(null, el)! as JSObject;
    final JSAny? html = wrapped.callMethod('html'.toJS);
    return html.isUndefinedOrNull ? '' : (html! as JSString).toDart;
  }

  // Check children for comments and nested script/style.
  final wrapped = $.callAsFunction(null, el)! as JSObject;
  final contents = wrapped.callMethod('contents'.toJS)! as JSObject;
  final arr = contents.callMethod('toArray'.toJS)! as JSArray<JSObject>;
  final buf = StringBuffer();
  for (final JSObject node in arr.toDart) {
    final JSAny? type = node.getProperty('type'.toJS);
    final String typeStr = type.isUndefinedOrNull ? '' : (type! as JSString).toDart;
    if (typeStr == 'comment') {
      final JSAny? data = node.getProperty('data'.toJS);
      if (data != null && !data.isUndefinedOrNull) {
        buf.write((data as JSString).toDart);
      }
    }
    final JSAny? nName = node.getProperty('name'.toJS);
    final String nTag = nName.isUndefinedOrNull ? '' : (nName! as JSString).toDart.toLowerCase();
    if (nTag == 'script' || nTag == 'style') {
      final nWrapped = $.callAsFunction(null, node)! as JSObject;
      final JSAny? html = nWrapped.callMethod('html'.toJS);
      if (html != null && !html.isUndefinedOrNull) {
        buf.write((html as JSString).toDart);
      }
    }
  }
  final result = buf.toString();
  if (result.isNotEmpty) return result;

  // Fallback to text.
  final JSAny? text = wrapped.callMethod('text'.toJS);
  return text.isUndefinedOrNull ? '' : (text! as JSString).toDart;
}

/// Get whole text of an element (all text nodes, recursively, preserving
/// whitespace).
String getWholeText(JSFunction $, JSObject el) {
  final buf = StringBuffer();
  _walkTextNodes($, el, buf);
  return buf.toString();
}

void _walkTextNodes(JSFunction $, JSObject el, StringBuffer buf) {
  final wrapped = $.callAsFunction(null, el)! as JSObject;
  final contents = wrapped.callMethod('contents'.toJS)! as JSObject;
  final arr = contents.callMethod('toArray'.toJS)! as JSArray<JSObject>;
  for (final JSObject node in arr.toDart) {
    final JSAny? type = node.getProperty('type'.toJS);
    final String typeStr = type.isUndefinedOrNull ? '' : (type! as JSString).toDart;
    if (typeStr == 'text') {
      final JSAny? data = node.getProperty('data'.toJS);
      if (data != null && !data.isUndefinedOrNull) {
        buf.write((data as JSString).toDart);
      }
    } else {
      _walkTextNodes($, node, buf);
    }
  }
}

// ---------------------------------------------------------------------------
// Filter builders
// ---------------------------------------------------------------------------

bool Function(JSFunction $, JSObject el) _buildFilter(String name, String arg) {
  return switch (name) {
    'contains' => (JSFunction $, JSObject el) {
      final w = $.callAsFunction(null, el)! as JSObject;
      final JSAny? t = w.callMethod('text'.toJS);
      final String text = t.isUndefinedOrNull ? '' : (t! as JSString).toDart;
      return text.toLowerCase().contains(arg.toLowerCase());
    },
    'containsOwn' => (JSFunction $, JSObject el) {
      return getOwnText($, el).toLowerCase().contains(arg.toLowerCase());
    },
    'containsWholeText' => (JSFunction $, JSObject el) {
      return getWholeText($, el).contains(arg);
    },
    'containsWholeOwnText' => (JSFunction $, JSObject el) {
      return _getOwnWholeText($, el).contains(arg);
    },
    'containsData' => (JSFunction $, JSObject el) {
      return _getDataText($, el).contains(arg);
    },
    'matches' => (JSFunction $, JSObject el) {
      final w = $.callAsFunction(null, el)! as JSObject;
      final JSAny? t = w.callMethod('text'.toJS);
      final String text = t.isUndefinedOrNull ? '' : (t! as JSString).toDart;
      return RegExp(arg).hasMatch(text);
    },
    'matchesOwn' => (JSFunction $, JSObject el) {
      return RegExp(arg).hasMatch(getOwnText($, el));
    },
    'matchesWholeText' => (JSFunction $, JSObject el) {
      return RegExp(arg).hasMatch(getWholeText($, el));
    },
    'matchesWholeOwnText' => (JSFunction $, JSObject el) {
      return RegExp(arg).hasMatch(_getOwnWholeText($, el));
    },
    _ => (JSFunction $, JSObject el) => true,
  };
}
