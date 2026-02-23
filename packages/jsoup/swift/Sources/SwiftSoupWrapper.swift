import Foundation
import SwiftSoup

/// Thin @objc wrapper around SwiftSoup for use with swiftgen/ffigen.
///
/// SwiftSoup's native Swift API uses generics, throws, and non-@objc types.
/// This wrapper exposes a handle-based C-compatible interface that Dart can
/// call via Objective-C FFI.

// MARK: - Handle Store

/// Global handle store mapping integer handles to SwiftSoup objects.
/// Elements (including Documents) and node lists (Elements arrays) share
/// the same handle namespace.
private var nextHandle: Int32 = 1
private var elementStore: [Int32: SwiftSoup.Element] = [:]
private var nodeListStore: [Int32: [SwiftSoup.Element]] = [:]

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
        // SwiftSoup.parse handles fragments well.
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
        // parent() returns Node?; if it's an Element, wrap it
        if let parentEl = p as? SwiftSoup.Element {
            return addElement(parentEl)
        }
        return -1
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
        do {
            let sibs = try el.siblingElements().array()
            return addNodeList(sibs)
        } catch {
            return -1
        }
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

    // MARK: Lifecycle

    @objc public static func free(_ handle: Int32) {
        elementStore.removeValue(forKey: handle)
        nodeListStore.removeValue(forKey: handle)
    }

    @objc public static func dispose() {
        elementStore.removeAll()
        nodeListStore.removeAll()
        nextHandle = 1
    }
}
