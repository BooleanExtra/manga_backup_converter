import 'package:jsoup/src/element.dart';
import 'package:jsoup/src/jsoup_api.dart';
import 'package:jsoup/src/jsoup_class.dart';
import 'package:meta/meta.dart';

/// A list of [Element]s, similar to Java Jsoup's `Elements`.
class Elements extends Iterable<Element> {
  /// Create from a list of existing elements.
  Elements(Jsoup jsoup, List<Element> elements)
    : _parser = jsoup.parser,
      _handle = jsoup.parser.createElements(
        elements.map((Element e) => e.handle).toList(),
      );

  /// Wrap a native node list handle.
  @internal
  Elements.fromHandle(
    NativeHtmlParser parser,
    int handle,
  ) : _parser = parser,
      _handle = handle;

  final NativeHtmlParser _parser;
  final int _handle;

  /// The base URI (from the first element, or empty).
  String get baseUri => isEmpty ? '' : first.baseUri;

  /// The underlying native handle. Package-internal. Returns -1 for dart-list mode.
  @internal
  int get handle => _handle;

  @override
  int get length => _parser.size(_handle);

  /// Access element at [index]. Throws [RangeError] if out of bounds.
  Element operator [](int index) {
    final int size = length;
    RangeError.checkValidIndex(index, this, 'index', size);
    final int elHandle = _parser.get(_handle, index);
    if (elHandle < 0) throw RangeError.index(index, this);
    return Element.fromHandle(_parser, elHandle);
  }

  @override
  Iterator<Element> get iterator => _ElementsIterator(this);
}

class _ElementsIterator implements Iterator<Element> {
  _ElementsIterator(this._elements);
  final Elements _elements;
  int _index = -1;
  Element? _current;

  @override
  Element get current => _current!;

  @override
  bool moveNext() {
    _index++;
    if (_index >= _elements.length) {
      _current = null;
      return false;
    }
    _current = _elements[_index];
    return true;
  }
}
