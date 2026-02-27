use ego_tree::NodeId;
use scraper::Html;
use std::cell::RefCell;
use std::collections::HashMap;
use std::sync::atomic::{AtomicI64, Ordering};

/// Global atomic counter for unique handle generation.
static NEXT_HANDLE: AtomicI64 = AtomicI64::new(1);

fn next_handle() -> i64 {
    NEXT_HANDLE.fetch_add(1, Ordering::Relaxed)
}

/// A parsed document with its base URI.
pub struct DocEntry {
    pub html: Html,
    pub base_uri: String,
}

/// A node reference: NodeId + owning document handle.
#[derive(Clone, Copy)]
pub struct NodeEntry {
    pub node_id: NodeId,
    pub doc_handle: i64,
    pub is_text: bool,
}

/// Thread-local handle stores.
thread_local! {
    static DOCUMENTS: RefCell<HashMap<i64, DocEntry>> = RefCell::new(HashMap::new());
    static NODES: RefCell<HashMap<i64, NodeEntry>> = RefCell::new(HashMap::new());
    static NODE_LISTS: RefCell<HashMap<i64, Vec<NodeEntry>>> = RefCell::new(HashMap::new());
}

pub fn store_document(html: Html, base_uri: String) -> i64 {
    let handle = next_handle();
    DOCUMENTS.with(|docs| {
        docs.borrow_mut().insert(handle, DocEntry { html, base_uri });
    });
    handle
}

pub fn store_node(entry: NodeEntry) -> i64 {
    let handle = next_handle();
    NODES.with(|nodes| {
        nodes.borrow_mut().insert(handle, entry);
    });
    handle
}

pub fn store_node_list(entries: Vec<NodeEntry>) -> i64 {
    let handle = next_handle();
    NODE_LISTS.with(|lists| {
        lists.borrow_mut().insert(handle, entries);
    });
    handle
}

/// Access a document by handle, calling `f` with a reference.
pub fn with_doc<R>(handle: i64, f: impl FnOnce(&DocEntry) -> R) -> Option<R> {
    DOCUMENTS.with(|docs| {
        let docs = docs.borrow();
        docs.get(&handle).map(f)
    })
}

/// Access a document by handle mutably.
pub fn with_doc_mut<R>(handle: i64, f: impl FnOnce(&mut DocEntry) -> R) -> Option<R> {
    DOCUMENTS.with(|docs| {
        let mut docs = docs.borrow_mut();
        docs.get_mut(&handle).map(f)
    })
}

/// Get a node entry by handle.
pub fn get_node(handle: i64) -> Option<NodeEntry> {
    NODES.with(|nodes| {
        let nodes = nodes.borrow();
        nodes.get(&handle).copied()
    })
}

/// Access a node's document and the node entry together.
pub fn with_node_doc<R>(handle: i64, f: impl FnOnce(&NodeEntry, &DocEntry) -> R) -> Option<R> {
    let entry = get_node(handle)?;
    with_doc(entry.doc_handle, |doc| f(&entry, doc))
}

/// Access a node's document mutably and the node entry together.
pub fn with_node_doc_mut<R>(
    handle: i64,
    f: impl FnOnce(&NodeEntry, &mut DocEntry) -> R,
) -> Option<R> {
    let entry = get_node(handle)?;
    with_doc_mut(entry.doc_handle, |doc| f(&entry, doc))
}

/// Get the node list entries by handle.
pub fn get_node_list(handle: i64) -> Option<Vec<NodeEntry>> {
    NODE_LISTS.with(|lists| {
        let lists = lists.borrow();
        lists.get(&handle).cloned()
    })
}

/// Free a handle from any store.
pub fn free_handle(handle: i64) {
    DOCUMENTS.with(|docs| {
        docs.borrow_mut().remove(&handle);
    });
    NODES.with(|nodes| {
        nodes.borrow_mut().remove(&handle);
    });
    NODE_LISTS.with(|lists| {
        lists.borrow_mut().remove(&handle);
    });
}

/// Release all handles.
pub fn release_all() {
    DOCUMENTS.with(|docs| docs.borrow_mut().clear());
    NODES.with(|nodes| nodes.borrow_mut().clear());
    NODE_LISTS.with(|lists| lists.borrow_mut().clear());
}

/// Check if a handle is a document.
pub fn is_document(handle: i64) -> bool {
    DOCUMENTS.with(|docs| docs.borrow().contains_key(&handle))
}

/// Check if a handle is in the node list store.
pub fn is_node_list(handle: i64) -> bool {
    NODE_LISTS.with(|lists| lists.borrow().contains_key(&handle))
}
