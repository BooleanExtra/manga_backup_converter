package dev.mangabackup.jsoup;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Node;
import org.jsoup.nodes.TextNode;
import org.jsoup.select.Elements;
import org.teavm.jso.JSExport;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Bridge between Dart (via JS interop) and the real Jsoup library compiled
 * to JavaScript by TeaVM.
 *
 * All methods are static and use integer handles to reference Java objects.
 * This maps 1:1 to NativeHtmlParser in the Dart jsoup package.
 */
public class JsoupBridge {
    private static int nextHandle = 1;
    private static final HashMap<Integer, Object> store = new HashMap<>();

    private static int put(Object obj) {
        int h = nextHandle++;
        store.put(h, obj);
        return h;
    }

    @SuppressWarnings("unchecked")
    private static <T> T get(int handle, Class<T> type) {
        Object obj = store.get(handle);
        if (obj != null && type.isInstance(obj)) return type.cast(obj);
        return null;
    }

    // -- Required entry point for TeaVM (never called) --
    public static void main(String[] args) {}

    // =========================================================================
    // Parse
    // =========================================================================

    @JSExport
    public static int parse(String html, String baseUri) {
        try {
            Document doc = Jsoup.parse(html, baseUri);
            return put(doc);
        } catch (Exception e) {
            return -1;
        }
    }

    @JSExport
    public static int parseFragment(String html, String baseUri) {
        try {
            Document doc = Jsoup.parseBodyFragment(html, baseUri);
            return put(doc);
        } catch (Exception e) {
            return -1;
        }
    }

    // =========================================================================
    // Select
    // =========================================================================

    @JSExport
    public static int select(int handle, String selector) {
        Element el = get(handle, Element.class);
        if (el == null) return -1;
        try {
            Elements result = el.select(selector);
            return put(result);
        } catch (Exception e) {
            return -1;
        }
    }

    @JSExport
    public static int selectFirst(int handle, String selector) {
        Element el = get(handle, Element.class);
        if (el == null) return -1;
        try {
            Element result = el.selectFirst(selector);
            if (result == null) return -1;
            return put(result);
        } catch (Exception e) {
            return -1;
        }
    }

    // =========================================================================
    // Attributes
    // =========================================================================

    @JSExport
    public static String attr(int handle, String key) {
        Element el = get(handle, Element.class);
        if (el == null) return null;
        try {
            String val = el.attr(key);
            return val.isEmpty() && !el.hasAttr(key) ? null : val;
        } catch (Exception e) {
            return null;
        }
    }

    @JSExport
    public static boolean hasAttr(int handle, String key) {
        Element el = get(handle, Element.class);
        if (el == null) return false;
        return el.hasAttr(key);
    }

    @JSExport
    public static void setAttr(int handle, String key, String value) {
        Element el = get(handle, Element.class);
        if (el == null) return;
        el.attr(key, value);
    }

    @JSExport
    public static void removeAttr(int handle, String key) {
        Element el = get(handle, Element.class);
        if (el == null) return;
        el.removeAttr(key);
    }

    // =========================================================================
    // Text & HTML
    // =========================================================================

    @JSExport
    public static String text(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return null;
        return el.text();
    }

    @JSExport
    public static String ownText(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return null;
        return el.ownText();
    }

    @JSExport
    public static String innerHtml(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return null;
        return el.html();
    }

    @JSExport
    public static String outerHtml(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return null;
        return el.outerHtml();
    }

    @JSExport
    public static String data(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return null;
        return el.data();
    }

    // =========================================================================
    // Identity
    // =========================================================================

    @JSExport
    public static String tagName(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return null;
        return el.tagName();
    }

    @JSExport
    public static String elementId(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return null;
        String id = el.id();
        return id.isEmpty() ? null : id;
    }

    @JSExport
    public static String className(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return null;
        return el.className();
    }

    @JSExport
    public static boolean hasClass(int handle, String name) {
        Element el = get(handle, Element.class);
        if (el == null) return false;
        return el.hasClass(name);
    }

    @JSExport
    public static void addClass(int handle, String name) {
        Element el = get(handle, Element.class);
        if (el == null) return;
        el.addClass(name);
    }

    @JSExport
    public static void removeClass(int handle, String name) {
        Element el = get(handle, Element.class);
        if (el == null) return;
        el.removeClass(name);
    }

    // =========================================================================
    // Node list operations
    // =========================================================================

    @JSExport
    public static int size(int handle) {
        Elements els = get(handle, Elements.class);
        if (els == null) return -1;
        return els.size();
    }

    @JSExport
    public static int getAt(int handle, int index) {
        Elements els = get(handle, Elements.class);
        if (els == null || index < 0 || index >= els.size()) return -1;
        return put(els.get(index));
    }

    @JSExport
    public static int first(int handle) {
        Elements els = get(handle, Elements.class);
        if (els == null || els.isEmpty()) return -1;
        return put(els.first());
    }

    @JSExport
    public static int last(int handle) {
        Elements els = get(handle, Elements.class);
        if (els == null || els.isEmpty()) return -1;
        return put(els.last());
    }

    // =========================================================================
    // Navigation
    // =========================================================================

    @JSExport
    public static int parent(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return -1;
        Element p = el.parent();
        if (p == null) return -1;
        return put(p);
    }

    @JSExport
    public static int children(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return -1;
        return put(el.children());
    }

    @JSExport
    public static int nextSibling(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return -1;
        Element next = el.nextElementSibling();
        if (next == null) return -1;
        return put(next);
    }

    @JSExport
    public static int prevSibling(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return -1;
        Element prev = el.previousElementSibling();
        if (prev == null) return -1;
        return put(prev);
    }

    @JSExport
    public static int siblings(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return -1;
        Elements sibs = el.siblingElements();
        return put(sibs);
    }

    // =========================================================================
    // Mutation
    // =========================================================================

    @JSExport
    public static void setText(int handle, String text) {
        Element el = get(handle, Element.class);
        if (el == null) return;
        el.text(text);
    }

    @JSExport
    public static void setHtml(int handle, String html) {
        Element el = get(handle, Element.class);
        if (el == null) return;
        el.html(html);
    }

    @JSExport
    public static void removeElement(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return;
        el.remove();
    }

    @JSExport
    public static void prepend(int handle, String html) {
        Element el = get(handle, Element.class);
        if (el == null) return;
        el.prepend(html);
    }

    @JSExport
    public static void append(int handle, String html) {
        Element el = get(handle, Element.class);
        if (el == null) return;
        el.append(html);
    }

    // =========================================================================
    // Base URI
    // =========================================================================

    @JSExport
    public static String nodeBaseUri(int handle) {
        Object obj = store.get(handle);
        if (obj instanceof Node) return ((Node) obj).baseUri();
        return null;
    }

    @JSExport
    public static String nodeAbsUrl(int handle, String key) {
        Element el = get(handle, Element.class);
        if (el == null) return "";
        return el.absUrl(key);
    }

    @JSExport
    public static void setNodeBaseUri(int handle, String value) {
        Object obj = store.get(handle);
        if (obj instanceof Node) ((Node) obj).setBaseUri(value);
    }

    // =========================================================================
    // Create
    // =========================================================================

    @JSExport
    public static int createElement(String tag) {
        try {
            Element el = new Element(tag);
            return put(el);
        } catch (Exception e) {
            return -1;
        }
    }

    @JSExport
    public static int createTextNode(String text) {
        try {
            TextNode tn = new TextNode(text);
            return put(tn);
        } catch (Exception e) {
            return -1;
        }
    }

    @JSExport
    public static int createElements(int[] elementHandles) {
        Elements result = new Elements();
        for (int h : elementHandles) {
            Element el = get(h, Element.class);
            if (el != null) result.add(el);
        }
        return put(result);
    }

    // =========================================================================
    // Node-level methods
    // =========================================================================

    @JSExport
    public static String nodeName(int handle) {
        Object obj = store.get(handle);
        if (obj instanceof Node) return ((Node) obj).nodeName();
        return null;
    }

    @JSExport
    public static int childNodeSize(int handle) {
        Object obj = store.get(handle);
        if (obj instanceof Node) return ((Node) obj).childNodeSize();
        return 0;
    }

    @JSExport
    public static int childNode(int handle, int index) {
        Object obj = store.get(handle);
        if (!(obj instanceof Node)) return -1;
        Node node = (Node) obj;
        if (index < 0 || index >= node.childNodeSize()) return -1;
        return put(node.childNode(index));
    }

    @JSExport
    public static int[] childNodeHandles(int handle) {
        Object obj = store.get(handle);
        if (!(obj instanceof Node)) return new int[0];
        List<Node> children = ((Node) obj).childNodes();
        int[] handles = new int[children.size()];
        for (int i = 0; i < children.size(); i++) {
            handles[i] = put(children.get(i));
        }
        return handles;
    }

    @JSExport
    public static boolean isTextNode(int handle) {
        return store.get(handle) instanceof TextNode;
    }

    @JSExport
    public static int parentNode(int handle) {
        Object obj = store.get(handle);
        if (!(obj instanceof Node)) return -1;
        Node p = ((Node) obj).parentNode();
        if (p == null) return -1;
        return put(p);
    }

    @JSExport
    public static String nodeOuterHtml(int handle) {
        Object obj = store.get(handle);
        if (obj instanceof Node) return ((Node) obj).outerHtml();
        return null;
    }

    @JSExport
    public static void removeNode(int handle) {
        Object obj = store.get(handle);
        if (obj instanceof Node) ((Node) obj).remove();
    }

    // =========================================================================
    // Element-level: textNodes
    // =========================================================================

    @JSExport
    public static int[] textNodeHandles(int handle) {
        Element el = get(handle, Element.class);
        if (el == null) return new int[0];
        List<TextNode> textNodes = el.textNodes();
        int[] handles = new int[textNodes.size()];
        for (int i = 0; i < textNodes.size(); i++) {
            handles[i] = put(textNodes.get(i));
        }
        return handles;
    }

    // =========================================================================
    // TextNode-level methods
    // =========================================================================

    @JSExport
    public static String textNodeText(int handle) {
        TextNode tn = get(handle, TextNode.class);
        if (tn == null) return null;
        return tn.text();
    }

    @JSExport
    public static void setTextNodeText(int handle, String text) {
        TextNode tn = get(handle, TextNode.class);
        if (tn == null) return;
        tn.text(text);
    }

    @JSExport
    public static String textNodeWholeText(int handle) {
        TextNode tn = get(handle, TextNode.class);
        if (tn == null) return null;
        return tn.getWholeText();
    }

    @JSExport
    public static boolean textNodeIsBlank(int handle) {
        TextNode tn = get(handle, TextNode.class);
        if (tn == null) return true;
        return tn.isBlank();
    }

    // =========================================================================
    // Cleanup
    // =========================================================================

    @JSExport
    public static void free(int handle) {
        store.remove(handle);
    }

    @JSExport
    public static void disposeAll() {
        store.clear();
        nextHandle = 1;
    }
}
