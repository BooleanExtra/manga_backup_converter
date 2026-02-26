import Foundation
import SwiftSoup

/// Thin @objc wrapper around SwiftSoup for use with swiftgen/ffigen.
///
/// SwiftSoup's native Swift API uses generics, throws, and non-@objc types.
/// This wrapper exposes a handle-based C-compatible interface that Dart can
/// call via Objective-C FFI.

// MARK: - Handle Store

/// Global handle store mapping integer handles to SwiftSoup objects.
/// Elements (including Documents), node lists, and text nodes share
/// the same handle namespace.
private var nextHandle: Int32 = 1
private var elementStore: [Int32: SwiftSoup.Element] = [:]
private var nodeListStore: [Int32: [SwiftSoup.Element]] = [:]
private var textNodeStore: [Int32: SwiftSoup.TextNode] = [:]

private func addElement(_ el: SwiftSoup.Element) -> Int32 {
    let handle = nextHandle
    nextHandle += 1
    elementStore[handle] = el
    return handle
}

private func addNodeList(_ els: [SwiftSoup.Element]) -> Int32 {
    let handle = nextHandle
    nextHandle += 1
    nodeListStore[handle] = els
    return handle
}

private func addTextNode(_ tn: SwiftSoup.TextNode) -> Int32 {
    let handle = nextHandle
    nextHandle += 1
    textNodeStore[handle] = tn
    return handle
}

/// Look up a Node by handle — checks elementStore first, then textNodeStore.
private func getNode(_ handle: Int32) -> SwiftSoup.Node? {
    if let el = elementStore[handle] { return el }
    if let tn = textNodeStore[handle] { return tn }
    return nil
}

/// Store a child node (Element or TextNode) and return its handle.
private func addNode(_ node: SwiftSoup.Node) -> Int32 {
    if let el = node as? SwiftSoup.Element {
        return addElement(el)
    } else if let tn = node as? SwiftSoup.TextNode {
        return addTextNode(tn)
    }
    // Unsupported node type.
    return -1
}

// MARK: - Public @objc API

@objc public class SwiftSoupBridge: NSObject {

    // MARK: Parsing

    @objc public static func parse(_ html: String, baseUri: String) -> Int32 {
        do {
            let doc = try SwiftSoup.parse(html, baseUri)
            return addElement(doc)
        } catch {
            return -1
        }
    }

    @objc public static func parseFragment(_ html: String, baseUri: String) -> Int32 {
        return parse(html, baseUri: baseUri)
    }

    // MARK: Selection

    @objc public static func select(_ handle: Int32, selector: String) -> Int32 {
        guard let el = elementStore[handle] else { return -1 }
        do {
            let results = try el.select(selector)
            return addNodeList(results.array())
        } catch {
            return -1
        }
    }

    @objc public static func selectFirst(_ handle: Int32, selector: String) -> Int32 {
        guard let el = elementStore[handle] else { return -1 }
        do {
            guard let result = try el.select(selector).first() else { return -1 }
            return addElement(result)
        } catch {
            return -1
        }
    }

    // MARK: Attributes

    @objc public static func attr(_ handle: Int32, key: String) -> String? {
        guard let el = elementStore[handle] else { return nil }
        do {
            let val = try el.attr(key)
            if val.isEmpty && !el.hasAttr(key) { return nil }
            return val
        } catch {
            return nil
        }
    }

    @objc public static func hasAttr(_ handle: Int32, key: String) -> Bool {
        guard let el = elementStore[handle] else { return false }
        return el.hasAttr(key)
    }

    @objc public static func setAttr(_ handle: Int32, key: String, value: String) {
        guard let el = elementStore[handle] else { return }
        do {
            try el.attr(key, value)
        } catch {}
    }

    @objc public static func removeAttr(_ handle: Int32, key: String) {
        guard let el = elementStore[handle] else { return }
        do {
            try el.removeAttr(key)
        } catch {}
    }

    // MARK: Text & HTML

    @objc public static func text(_ handle: Int32) -> String? {
        guard let el = elementStore[handle] else { return nil }
        do {
            return try el.text()
        } catch {
            return nil
        }
    }

    @objc public static func ownText(_ handle: Int32) -> String? {
        guard let el = elementStore[handle] else { return nil }
        return el.ownText()
    }

    @objc public static func innerHtml(_ handle: Int32) -> String? {
        guard let el = elementStore[handle] else { return nil }
        do {
            return try el.html()
        } catch {
            return nil
        }
    }

    @objc public static func outerHtml(_ handle: Int32) -> String? {
        guard let el = elementStore[handle] else { return nil }
        do {
            return try el.outerHtml()
        } catch {
            return nil
        }
    }

    @objc public static func setText(_ handle: Int32, text: String) {
        guard let el = elementStore[handle] else { return }
        do {
            try el.text(text)
        } catch {}
    }

    @objc public static func setHtml(_ handle: Int32, html: String) {
        guard let el = elementStore[handle] else { return }
        do {
            try el.html(html)
        } catch {}
    }

    @objc public static func data(_ handle: Int32) -> String? {
        guard let el = elementStore[handle] else { return nil }
        return el.data()
    }

    // MARK: Element Info

    @objc public static func tagName(_ handle: Int32) -> String? {
        guard let el = elementStore[handle] else { return nil }
        return el.tagName()
    }

    @objc public static func elementId(_ handle: Int32) -> String? {
        guard let el = elementStore[handle] else { return nil }
        let val = el.id()
        return val.isEmpty ? nil : val
    }

    @objc public static func className(_ handle: Int32) -> String? {
        guard let el = elementStore[handle] else { return nil }
        do {
            return try el.className()
        } catch {
            return nil
        }
    }

    @objc public static func hasClass(_ handle: Int32, name: String) -> Bool {
        guard let el = elementStore[handle] else { return false }
        return el.hasClass(name)
    }

    @objc public static func addClass(_ handle: Int32, name: String) {
        guard let el = elementStore[handle] else { return }
        do {
            try el.addClass(name)
        } catch {}
    }

    @objc public static func removeClass(_ handle: Int32, name: String) {
        guard let el = elementStore[handle] else { return }
        do {
            try el.removeClass(name)
        } catch {}
    }

    // MARK: Node List

    @objc public static func size(_ handle: Int32) -> Int32 {
        guard let list = nodeListStore[handle] else { return -1 }
        return Int32(list.count)
    }

    @objc public static func get(_ handle: Int32, index: Int32) -> Int32 {
        guard let list = nodeListStore[handle],
              index >= 0 && Int(index) < list.count else { return -1 }
        return addElement(list[Int(index)])
    }

    @objc public static func first(_ handle: Int32) -> Int32 {
        guard let list = nodeListStore[handle],
              let el = list.first else { return -1 }
        return addElement(el)
    }

    @objc public static func last(_ handle: Int32) -> Int32 {
        guard let list = nodeListStore[handle],
              let el = list.last else { return -1 }
        return addElement(el)
    }

    // MARK: Tree Navigation

    @objc public static func parent(_ handle: Int32) -> Int32 {
        guard let el = elementStore[handle],
              let p = el.parent() else { return -1 }
        return addElement(p)
    }

    @objc public static func children(_ handle: Int32) -> Int32 {
        guard let el = elementStore[handle] else { return -1 }
        let kids = el.children().array()
        return addNodeList(kids)
    }

    @objc public static func nextSibling(_ handle: Int32) -> Int32 {
        guard let el = elementStore[handle],
              let sib = try? el.nextElementSibling() else { return -1 }
        return addElement(sib)
    }

    @objc public static func prevSibling(_ handle: Int32) -> Int32 {
        guard let el = elementStore[handle],
              let sib = try? el.previousElementSibling() else { return -1 }
        return addElement(sib)
    }

    @objc public static func siblings(_ handle: Int32) -> Int32 {
        guard let el = elementStore[handle] else { return -1 }
        let sibs = el.siblingElements().array()
        return addNodeList(sibs)
    }

    // MARK: DOM Mutation

    @objc public static func remove(_ handle: Int32) {
        guard let el = elementStore[handle] else { return }
        do {
            try el.remove()
        } catch {}
    }

    @objc public static func prepend(_ handle: Int32, html: String) {
        guard let el = elementStore[handle] else { return }
        do {
            try el.prepend(html)
        } catch {}
    }

    @objc public static func append(_ handle: Int32, html: String) {
        guard let el = elementStore[handle] else { return }
        do {
            try el.append(html)
        } catch {}
    }

    // MARK: Base URI

    @objc public static func nodeBaseUri(_ handle: Int32) -> String? {
        guard let node = getNode(handle) else { return nil }
        return node.getBaseUri()
    }

    @objc public static func nodeAbsUrl(_ handle: Int32, key: String) -> String? {
        guard let el = elementStore[handle] else { return nil }
        do {
            let url = try el.absUrl(key)
            return url.isEmpty ? nil : url
        } catch {
            return nil
        }
    }

    @objc public static func setNodeBaseUri(_ handle: Int32, value: String) {
        guard let node = getNode(handle) else { return }
        do {
            try node.setBaseUri(value)
        } catch {}
    }

    // MARK: Element/TextNode Creation

    @objc public static func createElement(_ tag: String) -> Int32 {
        do {
            let el = try SwiftSoup.Element(Tag.valueOf(tag), "")
            return addElement(el)
        } catch {
            return -1
        }
    }

    @objc public static func createTextNode(_ text: String) -> Int32 {
        let tn = SwiftSoup.TextNode(text, nil)
        return addTextNode(tn)
    }

    @objc public static func createElements(_ handles: [NSNumber]) -> Int32 {
        var elements: [SwiftSoup.Element] = []
        for num in handles {
            let h = num.int32Value
            if let el = elementStore[h] {
                elements.append(el)
            }
        }
        return addNodeList(elements)
    }

    // MARK: Node-Level Methods

    @objc public static func nodeName(_ handle: Int32) -> String? {
        guard let node = getNode(handle) else { return nil }
        return node.nodeName()
    }

    @objc public static func childNodeSize(_ handle: Int32) -> Int32 {
        guard let node = getNode(handle) else { return 0 }
        return Int32(node.childNodeSize())
    }

    @objc public static func childNode(_ handle: Int32, index: Int32) -> Int32 {
        guard let node = getNode(handle),
              Int(index) < node.childNodeSize() else { return -1 }
        let child = node.childNode(Int(index))
        return addNode(child)
    }

    @objc public static func childNodeHandles(_ handle: Int32) -> [NSNumber] {
        guard let node = getNode(handle) else { return [] }
        let children = node.getChildNodes()
        var handles: [NSNumber] = []
        for child in children {
            let h = addNode(child)
            if h != -1 {
                handles.append(NSNumber(value: h))
            }
        }
        return handles
    }

    @objc public static func isTextNode(_ handle: Int32) -> Bool {
        return textNodeStore[handle] != nil
    }

    @objc public static func parentNode(_ handle: Int32) -> Int32 {
        guard let node = getNode(handle),
              let p = node.parent() else { return -1 }
        return addNode(p)
    }

    @objc public static func nodeOuterHtml(_ handle: Int32) -> String? {
        guard let node = getNode(handle) else { return nil }
        do {
            return try node.outerHtml()
        } catch {
            return nil
        }
    }

    @objc public static func removeNode(_ handle: Int32) {
        guard let node = getNode(handle) else { return }
        do {
            try node.remove()
        } catch {}
    }

    // MARK: Element → TextNode Children

    @objc public static func textNodeHandles(_ handle: Int32) -> [NSNumber] {
        guard let el = elementStore[handle] else { return [] }
        let textNodes = el.textNodes()
        var handles: [NSNumber] = []
        for tn in textNodes {
            handles.append(NSNumber(value: addTextNode(tn)))
        }
        return handles
    }

    // MARK: TextNode-Level Methods

    @objc public static func textNodeText(_ handle: Int32) -> String? {
        guard let tn = textNodeStore[handle] else { return nil }
        return tn.text()
    }

    @objc public static func setTextNodeText(_ handle: Int32, text: String) {
        guard let tn = textNodeStore[handle] else { return }
        _ = tn.text(text)
    }

    @objc public static func textNodeWholeText(_ handle: Int32) -> String? {
        guard let tn = textNodeStore[handle] else { return nil }
        return tn.getWholeText()
    }

    @objc public static func textNodeIsBlank(_ handle: Int32) -> Bool {
        guard let tn = textNodeStore[handle] else { return true }
        return tn.isBlank()
    }

    // MARK: Lifecycle

    @objc public static func free(_ handle: Int32) {
        elementStore.removeValue(forKey: handle)
        nodeListStore.removeValue(forKey: handle)
        textNodeStore.removeValue(forKey: handle)
    }

    @objc public static func releaseAll() {
        elementStore.removeAll()
        nodeListStore.removeAll()
        textNodeStore.removeAll()
        nextHandle = 1
    }

    @objc public static func dispose() {
        elementStore.removeAll()
        nodeListStore.removeAll()
        textNodeStore.removeAll()
        nextHandle = 1
    }
}
