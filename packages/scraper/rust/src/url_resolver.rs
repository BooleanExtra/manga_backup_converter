use crate::handle_store::{get_node, is_document, with_doc, with_doc_mut, with_node_doc};
use crate::{cstr_to_str, to_cstring};
use scraper::Node;
use std::ffi::{c_char, c_int};
use std::ptr;
use url::Url;

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_node_base_uri(handle: i64) -> *mut c_char {
    // If it's a document handle, return the document's baseUri directly
    if is_document(handle) {
        return with_doc(handle, |doc| to_cstring(&doc.base_uri)).unwrap_or(ptr::null_mut());
    }
    // For node handles, get the owning document's baseUri
    let entry = match get_node(handle) {
        Some(e) => e,
        None => return ptr::null_mut(),
    };
    with_doc(entry.doc_handle, |doc| to_cstring(&doc.base_uri)).unwrap_or(ptr::null_mut())
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_node_abs_url(
    handle: i64,
    key: *const c_char,
) -> *mut c_char {
    let key_str = match unsafe { cstr_to_str(key) } {
        Some(s) => s,
        None => return to_cstring(""),
    };

    with_node_doc(handle, |entry, doc| {
        let node_ref = doc.html.tree.get(entry.node_id)?;
        let attr_val = if let Node::Element(el) = node_ref.value() {
            el.attr(key_str)?
        } else {
            return Some(to_cstring(""));
        };

        if attr_val.is_empty() {
            return Some(to_cstring(""));
        }

        // Jsoup returns "" when base URI is empty and URL is relative
        if doc.base_uri.is_empty() {
            // If the attr value is already an absolute URL, return it
            return match Url::parse(attr_val) {
                Ok(url) => Some(to_cstring(url.as_str())),
                Err(_) => Some(to_cstring("")),
            };
        }

        match Url::parse(&doc.base_uri) {
            Ok(base) => match base.join(attr_val) {
                Ok(resolved) => Some(to_cstring(resolved.as_str())),
                Err(_) => Some(to_cstring(attr_val)),
            },
            Err(_) => Some(to_cstring(attr_val)),
        }
    })
    .flatten()
    .unwrap_or(to_cstring(""))
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_set_node_base_uri(
    handle: i64,
    value: *const c_char,
) {
    let val_str = match unsafe { cstr_to_str(value) } {
        Some(s) => s,
        None => return,
    };

    if is_document(handle) {
        with_doc_mut(handle, |doc| {
            doc.base_uri = val_str.to_owned();
        });
        return;
    }

    // For node handles, update the owning document's baseUri
    let entry = match get_node(handle) {
        Some(e) => e,
        None => return,
    };
    with_doc_mut(entry.doc_handle, |doc| {
        doc.base_uri = val_str.to_owned();
    });
}
