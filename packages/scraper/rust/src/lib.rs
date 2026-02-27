mod contains_filter;
mod handle_store;
mod mutation;
mod url_resolver;

use ego_tree::NodeRef;
use handle_store::{
    free_handle, get_node, get_node_list, is_document, release_all, store_document, store_node,
    store_node_list, with_doc, with_node_doc, NodeEntry,
};
use html5ever::tree_builder::QuirksMode;
use markup5ever::{ns, LocalName, QualName};
use scraper::{Html, Node, Selector};
use std::ffi::{c_char, c_int, CStr, CString};
use std::ptr;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

unsafe fn cstr_to_str<'a>(s: *const c_char) -> Option<&'a str> {
    if s.is_null() {
        return None;
    }
    unsafe { CStr::from_ptr(s) }.to_str().ok()
}

fn to_cstring(s: &str) -> *mut c_char {
    CString::new(s).map(CString::into_raw).unwrap_or(ptr::null_mut())
}

fn html_escape(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for c in s.chars() {
        match c {
            '&' => out.push_str("&amp;"),
            '<' => out.push_str("&lt;"),
            '>' => out.push_str("&gt;"),
            _ => out.push(c),
        }
    }
    out
}

fn node_to_entry(node_ref: &NodeRef<Node>, doc_handle: i64) -> NodeEntry {
    let is_text = matches!(node_ref.value(), Node::Text(_));
    NodeEntry {
        node_id: node_ref.id(),
        doc_handle,
        is_text,
    }
}

/// Store a node from a document, returning its handle.
fn store_node_from_doc(node_ref: &NodeRef<Node>, doc_handle: i64) -> i64 {
    store_node(node_to_entry(node_ref, doc_handle))
}

// ---------------------------------------------------------------------------
// String / array freeing
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_free_string(s: *mut c_char) {
    if !s.is_null() {
        drop(unsafe { CString::from_raw(s) });
    }
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_free_handle_array(arr: *mut i64, _len: c_int) {
    if !arr.is_null() {
        // The array was allocated via Vec::into_raw_parts pattern.
        // We reconstruct a Vec to drop it.
        let len = _len as usize;
        drop(unsafe { Vec::from_raw_parts(arr, len, len) });
    }
}

// ---------------------------------------------------------------------------
// Parsing
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_parse(
    html: *const c_char,
    base_uri: *const c_char,
) -> i64 {
    let html_str = match unsafe { cstr_to_str(html) } {
        Some(s) => s,
        None => return -1,
    };
    let base = unsafe { cstr_to_str(base_uri) }.unwrap_or("");
    let doc = Html::parse_document(html_str);
    store_document(doc, base.to_owned())
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_parse_fragment(
    html: *const c_char,
    base_uri: *const c_char,
) -> i64 {
    let html_str = match unsafe { cstr_to_str(html) } {
        Some(s) => s,
        None => return -1,
    };
    let base = unsafe { cstr_to_str(base_uri) }.unwrap_or("");
    let doc = Html::parse_fragment(html_str);
    store_document(doc, base.to_owned())
}

// ---------------------------------------------------------------------------
// CSS Selectors
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_select(
    handle: i64,
    selector: *const c_char,
) -> i64 {
    let sel_str = match unsafe { cstr_to_str(selector) } {
        Some(s) => s,
        None => return -1,
    };
    let (base_sel, filters) = contains_filter::strip_contains(sel_str);
    let base_sel_str = if base_sel.trim().is_empty() { "*" } else { &base_sel };
    let sel = match Selector::parse(base_sel_str) {
        Ok(s) => s,
        Err(_) => return -1,
    };

    // handle could be a document or a node (element)
    if is_document(handle) {
        with_doc(handle, |doc| {
            let entries: Vec<NodeEntry> = doc
                .html
                .select(&sel)
                .filter(|el| {
                    filters.iter().all(|f| {
                        let node_ref = doc.html.tree.get(el.id()).unwrap();
                        contains_filter::matches_filter(f, el, &node_ref)
                    })
                })
                .map(|el| NodeEntry {
                    node_id: el.id(),
                    doc_handle: handle,
                    is_text: false,
                })
                .collect();
            store_node_list(entries)
        })
        .unwrap_or(-1)
    } else {
        // Node handle — need to select within this element
        let entry = match get_node(handle) {
            Some(e) => e,
            None => return -1,
        };
        with_doc(entry.doc_handle, |doc| {
            let node_ref = match doc.html.tree.get(entry.node_id) {
                Some(n) => n,
                None => return -1,
            };
            // Check if it's an element
            if let Node::Element(_) = node_ref.value() {
                let el_ref = scraper::ElementRef::wrap(node_ref).unwrap();
                let mut entries: Vec<NodeEntry> = Vec::new();
                // Jsoup includes the element itself if it matches the selector.
                if sel.matches(&el_ref)
                    && filters.iter().all(|f| {
                        let nr = doc.html.tree.get(el_ref.id()).unwrap();
                        contains_filter::matches_filter(f, &el_ref, &nr)
                    })
                {
                    entries.push(NodeEntry {
                        node_id: el_ref.id(),
                        doc_handle: entry.doc_handle,
                        is_text: false,
                    });
                }
                entries.extend(
                    el_ref
                        .select(&sel)
                        .filter(|el| {
                            filters.iter().all(|f| {
                                let nr = doc.html.tree.get(el.id()).unwrap();
                                contains_filter::matches_filter(f, el, &nr)
                            })
                        })
                        .map(|el| NodeEntry {
                            node_id: el.id(),
                            doc_handle: entry.doc_handle,
                            is_text: false,
                        }),
                );
                store_node_list(entries)
            } else {
                store_node_list(Vec::new())
            }
        })
        .unwrap_or(-1)
    }
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_select_first(
    handle: i64,
    selector: *const c_char,
) -> i64 {
    let sel_str = match unsafe { cstr_to_str(selector) } {
        Some(s) => s,
        None => return -1,
    };
    let (base_sel, filters) = contains_filter::strip_contains(sel_str);
    let base_sel_str = if base_sel.trim().is_empty() { "*" } else { &base_sel };
    let sel = match Selector::parse(base_sel_str) {
        Ok(s) => s,
        Err(_) => return -1,
    };

    if is_document(handle) {
        with_doc(handle, |doc| {
            doc.html
                .select(&sel)
                .find(|el| {
                    filters.iter().all(|f| {
                        let node_ref = doc.html.tree.get(el.id()).unwrap();
                        contains_filter::matches_filter(f, el, &node_ref)
                    })
                })
                .map_or(-1, |el| {
                    store_node(NodeEntry {
                        node_id: el.id(),
                        doc_handle: handle,
                        is_text: false,
                    })
                })
        })
        .unwrap_or(-1)
    } else {
        let entry = match get_node(handle) {
            Some(e) => e,
            None => return -1,
        };
        with_doc(entry.doc_handle, |doc| {
            let node_ref = doc.html.tree.get(entry.node_id)?;
            if let Node::Element(_) = node_ref.value() {
                let el_ref = scraper::ElementRef::wrap(node_ref)?;
                // Jsoup includes the element itself if it matches the selector.
                if sel.matches(&el_ref)
                    && filters.iter().all(|f| {
                        let nr = doc.html.tree.get(el_ref.id()).unwrap();
                        contains_filter::matches_filter(f, &el_ref, &nr)
                    })
                {
                    return Some(store_node(NodeEntry {
                        node_id: el_ref.id(),
                        doc_handle: entry.doc_handle,
                        is_text: false,
                    }));
                }
                el_ref
                    .select(&sel)
                    .find(|el| {
                        filters.iter().all(|f| {
                            let nr = doc.html.tree.get(el.id()).unwrap();
                            contains_filter::matches_filter(f, el, &nr)
                        })
                    })
                    .map(|el| {
                        store_node(NodeEntry {
                            node_id: el.id(),
                            doc_handle: entry.doc_handle,
                            is_text: false,
                        })
                    })
            } else {
                None
            }
        })
        .flatten()
        .unwrap_or(-1)
    }
}

// ---------------------------------------------------------------------------
// Attributes
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_attr(
    handle: i64,
    key: *const c_char,
) -> *mut c_char {
    let key_str = match unsafe { cstr_to_str(key) } {
        Some(s) => s,
        None => return ptr::null_mut(),
    };
    // Document handles have no attributes — return null (Dart OO layer maps to "")
    if is_document(handle) {
        return ptr::null_mut();
    }
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        if let Node::Element(el) = node_ref.value() {
            el.attr(key_str).map(|v| to_cstring(v))
        } else {
            None
        }
    })
    .flatten()
    .unwrap_or(ptr::null_mut())
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_has_attr(
    handle: i64,
    key: *const c_char,
) -> c_int {
    let key_str = match unsafe { cstr_to_str(key) } {
        Some(s) => s,
        None => return 0,
    };
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        if let Node::Element(el) = node_ref.value() {
            Some(el.attr(key_str).is_some())
        } else {
            Some(false)
        }
    })
    .flatten()
    .map(|b| b as c_int)
    .unwrap_or(0)
}

// ---------------------------------------------------------------------------
// Text & HTML
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_text(handle: i64) -> *mut c_char {
    // For a document handle, get text of root element
    if is_document(handle) {
        return with_doc(handle, |doc| {
            let raw: String = doc.html.root_element().text().collect();
            let normalized = raw.split_whitespace().collect::<Vec<&str>>().join(" ");
            to_cstring(&normalized)
        })
        .unwrap_or(ptr::null_mut());
    }
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        if let Node::Element(_) = node_ref.value() {
            let el_ref = scraper::ElementRef::wrap(node_ref)?;
            let raw: String = el_ref.text().collect();
            let normalized = raw.split_whitespace().collect::<Vec<&str>>().join(" ");
            Some(to_cstring(&normalized))
        } else {
            None
        }
    })
    .flatten()
    .unwrap_or(ptr::null_mut())
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_own_text(handle: i64) -> *mut c_char {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        if let Node::Element(_) = node_ref.value() {
            // Collect only direct text children
            let text: String = node_ref
                .children()
                .filter_map(|child| {
                    if let Node::Text(t) = child.value() {
                        Some(t.text.as_ref())
                    } else {
                        None
                    }
                })
                .collect::<Vec<&str>>()
                .join("");
            // Normalize whitespace like Jsoup: collapse runs of whitespace to single space, trim
            let normalized = text.split_whitespace().collect::<Vec<&str>>().join(" ");
            Some(to_cstring(&normalized))
        } else {
            None
        }
    })
    .flatten()
    .unwrap_or(ptr::null_mut())
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_inner_html(handle: i64) -> *mut c_char {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        if let Node::Element(_) = node_ref.value() {
            let el_ref = scraper::ElementRef::wrap(node_ref)?;
            Some(to_cstring(&el_ref.inner_html()))
        } else {
            None
        }
    })
    .flatten()
    .unwrap_or(ptr::null_mut())
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_outer_html(handle: i64) -> *mut c_char {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        if let Node::Element(_) = node_ref.value() {
            let el_ref = scraper::ElementRef::wrap(node_ref)?;
            Some(to_cstring(&el_ref.html()))
        } else {
            None
        }
    })
    .flatten()
    .unwrap_or(ptr::null_mut())
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_tag_name(handle: i64) -> *mut c_char {
    if is_document(handle) {
        return to_cstring("#root");
    }
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        if let Node::Element(el) = node_ref.value() {
            Some(to_cstring(&el.name.local))
        } else {
            None
        }
    })
    .flatten()
    .unwrap_or(ptr::null_mut())
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_id(handle: i64) -> *mut c_char {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        if let Node::Element(el) = node_ref.value() {
            el.attr("id")
                .filter(|s| !s.is_empty())
                .map(|s| to_cstring(s))
        } else {
            None
        }
    })
    .flatten()
    .unwrap_or(ptr::null_mut())
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_class_name(handle: i64) -> *mut c_char {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        if let Node::Element(el) = node_ref.value() {
            Some(to_cstring(el.attr("class").unwrap_or("")))
        } else {
            None
        }
    })
    .flatten()
    .unwrap_or(ptr::null_mut())
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_has_class(
    handle: i64,
    name: *const c_char,
) -> c_int {
    let name_str = match unsafe { cstr_to_str(name) } {
        Some(s) => s,
        None => return 0,
    };
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        if let Node::Element(el) = node_ref.value() {
            Some(el.has_class(name_str, scraper::CaseSensitivity::CaseSensitive) as c_int)
        } else {
            Some(0)
        }
    })
    .flatten()
    .unwrap_or(0)
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_data(handle: i64) -> *mut c_char {
    // Jsoup data() returns content only for DataNode parents (script, style, textarea, title).
    // For all other elements, it returns "".
    if is_document(handle) {
        return to_cstring("");
    }
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        if let Node::Element(el) = node_ref.value() {
            let tag = el.name.local.as_ref();
            if matches!(tag, "script" | "style" | "textarea" | "title") {
                let el_ref = scraper::ElementRef::wrap(node_ref)?;
                let raw: String = el_ref.text().collect();
                Some(to_cstring(&raw))
            } else {
                Some(to_cstring(""))
            }
        } else {
            None
        }
    })
    .flatten()
    .unwrap_or(ptr::null_mut())
}

// ---------------------------------------------------------------------------
// Node list operations
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_list_size(handle: i64) -> c_int {
    get_node_list(handle)
        .map(|v| v.len() as c_int)
        .unwrap_or(-1)
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_list_get(handle: i64, index: c_int) -> i64 {
    get_node_list(handle)
        .and_then(|v| v.get(index as usize).map(|e| store_node(*e)))
        .unwrap_or(-1)
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_list_first(handle: i64) -> i64 {
    get_node_list(handle)
        .and_then(|v| v.first().map(|e| store_node(*e)))
        .unwrap_or(-1)
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_list_last(handle: i64) -> i64 {
    get_node_list(handle)
        .and_then(|v| v.last().map(|e| store_node(*e)))
        .unwrap_or(-1)
}

// ---------------------------------------------------------------------------
// Navigation
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_parent(handle: i64) -> i64 {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        let parent = node_ref.parent()?;
        // Skip the implicit root Document node
        if matches!(parent.value(), Node::Document) {
            return None;
        }
        if let Node::Element(_) = parent.value() {
            Some(store_node(NodeEntry {
                node_id: parent.id(),
                doc_handle: entry.doc_handle,
                is_text: false,
            }))
        } else {
            None
        }
    })
    .flatten()
    .unwrap_or(-1)
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_children(handle: i64) -> i64 {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        let entries: Vec<NodeEntry> = node_ref
            .children()
            .filter(|child| matches!(child.value(), Node::Element(_)))
            .map(|child| NodeEntry {
                node_id: child.id(),
                doc_handle: entry.doc_handle,
                is_text: false,
            })
            .collect();
        Some(store_node_list(entries))
    })
    .flatten()
    .unwrap_or(-1)
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_next_sibling(handle: i64) -> i64 {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        // Find next sibling that is an element
        let mut sib = node_ref.next_sibling();
        while let Some(s) = sib {
            if let Node::Element(_) = s.value() {
                return Some(store_node(NodeEntry {
                    node_id: s.id(),
                    doc_handle: entry.doc_handle,
                    is_text: false,
                }));
            }
            sib = s.next_sibling();
        }
        None
    })
    .flatten()
    .unwrap_or(-1)
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_prev_sibling(handle: i64) -> i64 {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        let mut sib = node_ref.prev_sibling();
        while let Some(s) = sib {
            if let Node::Element(_) = s.value() {
                return Some(store_node(NodeEntry {
                    node_id: s.id(),
                    doc_handle: entry.doc_handle,
                    is_text: false,
                }));
            }
            sib = s.prev_sibling();
        }
        None
    })
    .flatten()
    .unwrap_or(-1)
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_siblings(handle: i64) -> i64 {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        let parent = node_ref.parent()?;
        let entries: Vec<NodeEntry> = parent
            .children()
            .filter(|child| {
                matches!(child.value(), Node::Element(_)) && child.id() != entry.node_id
            })
            .map(|child| NodeEntry {
                node_id: child.id(),
                doc_handle: entry.doc_handle,
                is_text: false,
            })
            .collect();
        Some(store_node_list(entries))
    })
    .flatten()
    .unwrap_or(-1)
}

// ---------------------------------------------------------------------------
// Node-level methods
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_node_name(handle: i64) -> *mut c_char {
    // Check documents first
    if is_document(handle) {
        return to_cstring("#root");
    }
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        Some(match node_ref.value() {
            Node::Element(el) => to_cstring(&el.name.local),
            Node::Text(_) => to_cstring("#text"),
            Node::Comment(_) => to_cstring("#comment"),
            Node::Document => to_cstring("#document"),
            _ => to_cstring("#unknown"),
        })
    })
    .flatten()
    .unwrap_or(ptr::null_mut())
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_child_node_size(handle: i64) -> c_int {
    if is_document(handle) {
        return with_doc(handle, |doc| {
            doc.html
                .tree
                .root()
                .children()
                .count() as c_int
        })
        .unwrap_or(0);
    }
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        Some(node_ref.children().count() as c_int)
    })
    .flatten()
    .unwrap_or(0)
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_child_node(
    handle: i64,
    index: c_int,
) -> i64 {
    let doc_handle = if is_document(handle) { handle } else { get_node(handle).map(|e| e.doc_handle).unwrap_or(-1) };
    if is_document(handle) {
        return with_doc(handle, |doc| {
            doc.html
                .tree
                .root()
                .children()
                .nth(index as usize)
                .map(|child| store_node_from_doc(&child, handle))
        })
        .flatten()
        .unwrap_or(-1);
    }
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        node_ref
            .children()
            .nth(index as usize)
            .map(|child| store_node_from_doc(&child, doc_handle))
    })
    .flatten()
    .unwrap_or(-1)
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_child_node_handles(
    handle: i64,
    out_handles: *mut *mut i64,
    out_len: *mut c_int,
) {
    let result = if is_document(handle) {
        with_doc(handle, |doc| {
            doc.html
                .tree
                .root()
                .children()
                .map(|child| store_node_from_doc(&child, handle))
                .collect::<Vec<i64>>()
        })
    } else {
        with_node_doc(handle, |entry, doc| {
            let node_ref = doc.html.tree.get(entry.node_id)?;
            Some(
                node_ref
                    .children()
                    .map(|child| store_node_from_doc(&child, entry.doc_handle))
                    .collect::<Vec<i64>>(),
            )
        })
        .flatten()
    };

    match result {
        Some(handles) => {
            let len = handles.len();
            let mut boxed = handles.into_boxed_slice();
            unsafe {
                *out_handles = boxed.as_mut_ptr();
                *out_len = len as c_int;
            }
            std::mem::forget(boxed);
        }
        None => unsafe {
            *out_handles = ptr::null_mut();
            *out_len = 0;
        },
    }
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_is_text_node(handle: i64) -> c_int {
    get_node(handle).map(|e| e.is_text as c_int).unwrap_or(0)
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_parent_node(handle: i64) -> i64 {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        let parent = node_ref.parent()?;
        if matches!(parent.value(), Node::Document) {
            return None;
        }
        Some(store_node_from_doc(&parent, entry.doc_handle))
    })
    .flatten()
    .unwrap_or(-1)
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_node_outer_html(handle: i64) -> *mut c_char {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        Some(match node_ref.value() {
            Node::Element(_) => {
                let el_ref = scraper::ElementRef::wrap(node_ref)?;
                to_cstring(&el_ref.html())
            }
            Node::Text(t) => to_cstring(&html_escape(t.text.as_ref())),
            Node::Comment(c) => to_cstring(&format!("<!--{}-->", c.comment)),
            _ => to_cstring(""),
        })
    })
    .flatten()
    .unwrap_or(ptr::null_mut())
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_text_node_handles(
    handle: i64,
    out_handles: *mut *mut i64,
    out_len: *mut c_int,
) {
    let result = with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        Some(
            node_ref
                .children()
                .filter(|child| matches!(child.value(), Node::Text(_)))
                .map(|child| {
                    store_node(NodeEntry {
                        node_id: child.id(),
                        doc_handle: entry.doc_handle,
                        is_text: true,
                    })
                })
                .collect::<Vec<i64>>(),
        )
    })
    .flatten();

    match result {
        Some(handles) => {
            let len = handles.len();
            let mut boxed = handles.into_boxed_slice();
            unsafe {
                *out_handles = boxed.as_mut_ptr();
                *out_len = len as c_int;
            }
            std::mem::forget(boxed);
        }
        None => unsafe {
            *out_handles = ptr::null_mut();
            *out_len = 0;
        },
    }
}

// ---------------------------------------------------------------------------
// TextNode-level methods
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_text_node_text(handle: i64) -> *mut c_char {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        if let Node::Text(t) = node_ref.value() {
            let normalized = t.text.split_whitespace().collect::<Vec<&str>>().join(" ");
            Some(to_cstring(&normalized))
        } else {
            None
        }
    })
    .flatten()
    .unwrap_or(ptr::null_mut())
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_text_node_whole_text(handle: i64) -> *mut c_char {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        if let Node::Text(t) = node_ref.value() {
            Some(to_cstring(t.text.as_ref()))
        } else {
            None
        }
    })
    .flatten()
    .unwrap_or(ptr::null_mut())
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_text_node_is_blank(handle: i64) -> c_int {
    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        if let Node::Text(t) = node_ref.value() {
            Some(t.text.trim().is_empty() as c_int)
        } else {
            Some(1)
        }
    })
    .flatten()
    .unwrap_or(1)
}

// ---------------------------------------------------------------------------
// Element creation
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_create_element(tag: *const c_char) -> i64 {
    let tag_str = match unsafe { cstr_to_str(tag) } {
        Some(s) => s,
        None => return -1,
    };
    // Construct the tree directly to avoid html5ever's implicit wrappers.
    // The element's parent is the Document node, so scraper_parent returns -1.
    let mut tree = ego_tree::Tree::new(Node::Document);
    let el = scraper::node::Element::new(
        QualName::new(None, ns!(html), LocalName::from(tag_str)),
        vec![],
    );
    let el_id = tree.root_mut().append(Node::Element(el)).id();
    let html = Html {
        errors: vec![],
        quirks_mode: QuirksMode::NoQuirks,
        tree,
    };
    let doc_handle = store_document(html, String::new());
    store_node(NodeEntry {
        node_id: el_id,
        doc_handle,
        is_text: false,
    })
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_create_text_node(text: *const c_char) -> i64 {
    let text_str = match unsafe { cstr_to_str(text) } {
        Some(s) => s,
        None => return -1,
    };
    // Construct the tree directly to avoid html5ever's implicit wrappers.
    let mut tree = ego_tree::Tree::new(Node::Document);
    let text_node = Node::Text(scraper::node::Text {
        text: text_str.into(),
    });
    let text_id = tree.root_mut().append(text_node).id();
    let html = Html {
        errors: vec![],
        quirks_mode: QuirksMode::NoQuirks,
        tree,
    };
    let doc_handle = store_document(html, String::new());
    store_node(NodeEntry {
        node_id: text_id,
        doc_handle,
        is_text: true,
    })
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_create_elements(
    element_handles: *const i64,
    count: c_int,
) -> i64 {
    if element_handles.is_null() || count <= 0 {
        return store_node_list(Vec::new());
    }
    let handles = unsafe { std::slice::from_raw_parts(element_handles, count as usize) };
    let entries: Vec<NodeEntry> = handles
        .iter()
        .filter_map(|&h| get_node(h))
        .collect();
    store_node_list(entries)
}

// ---------------------------------------------------------------------------
// Lifecycle
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_free(handle: i64) {
    free_handle(handle);
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_release_all() {
    release_all();
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_dispose() {
    release_all();
}
