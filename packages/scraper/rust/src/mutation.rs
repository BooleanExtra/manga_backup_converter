use crate::handle_store::with_node_doc_mut;
use crate::cstr_to_str;
use ego_tree::NodeId;
use html5ever::Attribute;
use markup5ever::{ns, LocalName, QualName};
use scraper::{Html, Node};
use std::ffi::c_char;
use tendril::StrTendril;

fn make_qname(local: &str) -> QualName {
    QualName::new(None, ns!(), LocalName::from(local))
}

/// Rebuild a scraper Element from its name and a new set of attributes.
/// This creates a fresh Element with new OnceCell caches, invalidating any
/// stale cached `id` or `classes` from the old Element.
fn rebuild_element(
    node_mut: &mut ego_tree::NodeMut<Node>,
    new_attrs: Vec<(QualName, StrTendril)>,
) {
    if let Node::Element(ref el) = node_mut.value() {
        let new_el = scraper::node::Element::new(
            el.name.clone(),
            new_attrs
                .iter()
                .map(|(k, v)| Attribute {
                    name: k.clone(),
                    value: v.clone(),
                })
                .collect(),
        );
        *node_mut.value() = Node::Element(new_el);
    }
}

/// Set or insert an attribute value, rebuilding the Element to invalidate caches.
fn upsert_attr(node_mut: &mut ego_tree::NodeMut<Node>, key: &str, value: &str) {
    if let Node::Element(ref el) = node_mut.value() {
        let mut new_attrs: Vec<_> = el.attrs.clone();
        let qname = make_qname(key);
        match new_attrs.binary_search_by(|attr| attr.0.cmp(&qname)) {
            Ok(idx) => {
                new_attrs[idx].1 = value.into();
            }
            Err(idx) => {
                new_attrs.insert(idx, (qname, value.into()));
            }
        }
        rebuild_element(node_mut, new_attrs);
    }
}

/// Remove an attribute by local name, rebuilding the Element to invalidate caches.
fn remove_attr(node_mut: &mut ego_tree::NodeMut<Node>, key: &str) {
    if let Node::Element(ref el) = node_mut.value() {
        let qname = make_qname(key);
        let mut new_attrs: Vec<_> = el.attrs.clone();
        if let Ok(idx) = new_attrs.binary_search_by(|attr| attr.0.cmp(&qname)) {
            new_attrs.remove(idx);
        }
        rebuild_element(node_mut, new_attrs);
    }
}

// ---------------------------------------------------------------------------
// Attribute mutations
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_set_attr(
    handle: i64,
    key: *const c_char,
    value: *const c_char,
) {
    let key_str = match unsafe { cstr_to_str(key) } {
        Some(s) => s,
        None => return,
    };
    let val_str = match unsafe { cstr_to_str(value) } {
        Some(s) => s,
        None => return,
    };
    with_node_doc_mut(handle, |entry, doc| {
        if let Some(mut node_mut) = doc.html.tree.get_mut(entry.node_id) {
            upsert_attr(&mut node_mut, key_str, val_str);
        }
    });
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_remove_attr(
    handle: i64,
    key: *const c_char,
) {
    let key_str = match unsafe { cstr_to_str(key) } {
        Some(s) => s,
        None => return,
    };
    with_node_doc_mut(handle, |entry, doc| {
        if let Some(mut node_mut) = doc.html.tree.get_mut(entry.node_id) {
            remove_attr(&mut node_mut, key_str);
        }
    });
}

// ---------------------------------------------------------------------------
// Class mutations
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_add_class(
    handle: i64,
    name: *const c_char,
) {
    let name_str = match unsafe { cstr_to_str(name) } {
        Some(s) => s,
        None => return,
    };
    with_node_doc_mut(handle, |entry, doc| {
        if let Some(mut node_mut) = doc.html.tree.get_mut(entry.node_id) {
            let current = if let Node::Element(ref el) = node_mut.value() {
                el.attr("class").unwrap_or("").to_string()
            } else {
                return;
            };
            if !current.split_whitespace().any(|c| c == name_str) {
                let new_class = if current.is_empty() {
                    name_str.to_string()
                } else {
                    format!("{current} {name_str}")
                };
                upsert_attr(&mut node_mut, "class", &new_class);
            }
        }
    });
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_remove_class(
    handle: i64,
    name: *const c_char,
) {
    let name_str = match unsafe { cstr_to_str(name) } {
        Some(s) => s,
        None => return,
    };
    with_node_doc_mut(handle, |entry, doc| {
        if let Some(mut node_mut) = doc.html.tree.get_mut(entry.node_id) {
            let current = if let Node::Element(ref el) = node_mut.value() {
                el.attr("class").unwrap_or("").to_string()
            } else {
                return;
            };
            let new_classes: Vec<&str> = current
                .split_whitespace()
                .filter(|c| *c != name_str)
                .collect();
            if new_classes.is_empty() {
                remove_attr(&mut node_mut, "class");
            } else {
                upsert_attr(&mut node_mut, "class", &new_classes.join(" "));
            }
        }
    });
}

// ---------------------------------------------------------------------------
// DOM mutations
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_set_text(
    handle: i64,
    text: *const c_char,
) {
    let text_str = match unsafe { cstr_to_str(text) } {
        Some(s) => s,
        None => return,
    };
    with_node_doc_mut(handle, |entry, doc| {
        remove_all_children(&mut doc.html, entry.node_id);
        let text_node = Node::Text(scraper::node::Text {
            text: text_str.into(),
        });
        if let Some(mut node_mut) = doc.html.tree.get_mut(entry.node_id) {
            node_mut.append(text_node);
        }
    });
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_set_html(
    handle: i64,
    html: *const c_char,
) {
    let html_str = match unsafe { cstr_to_str(html) } {
        Some(s) => s,
        None => return,
    };
    with_node_doc_mut(handle, |entry, doc| {
        remove_all_children(&mut doc.html, entry.node_id);
        let fragment = Html::parse_fragment(html_str);
        transplant_children(&fragment, &mut doc.html, entry.node_id);
    });
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_remove_element(handle: i64) {
    with_node_doc_mut(handle, |entry, doc| {
        if let Some(mut node_mut) = doc.html.tree.get_mut(entry.node_id) {
            node_mut.detach();
        }
    });
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_remove_node(handle: i64) {
    with_node_doc_mut(handle, |entry, doc| {
        if let Some(mut node_mut) = doc.html.tree.get_mut(entry.node_id) {
            node_mut.detach();
        }
    });
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_prepend(
    handle: i64,
    html: *const c_char,
) {
    let html_str = match unsafe { cstr_to_str(html) } {
        Some(s) => s,
        None => return,
    };
    with_node_doc_mut(handle, |entry, doc| {
        let fragment = Html::parse_fragment(html_str);
        let first_child = doc
            .html
            .tree
            .get(entry.node_id)
            .and_then(|n| n.first_child())
            .map(|c| c.id());

        let trees = collect_fragment_trees(&fragment);

        match first_child {
            Some(fc_id) => {
                for subtree in trees {
                    if let Some(mut fc_mut) = doc.html.tree.get_mut(fc_id) {
                        fn insert_tree_before(
                            dst: &mut ego_tree::NodeMut<Node>,
                            src: &ego_tree::Tree<Node>,
                        ) {
                            let root = src.root();
                            let mut new_node = dst.insert_before(root.value().clone());
                            fn append_subtree_before(
                                dst: &mut ego_tree::NodeMut<Node>,
                                src: &ego_tree::NodeRef<Node>,
                            ) {
                                let mut new_node = dst.append(src.value().clone());
                                for child in src.children() {
                                    append_subtree_before(&mut new_node, &child);
                                }
                            }
                            for child in root.children() {
                                append_subtree_before(&mut new_node, &child);
                            }
                        }
                        insert_tree_before(&mut fc_mut, &subtree);
                    }
                }
            }
            None => {
                for subtree in trees {
                    if let Some(mut parent_mut) = doc.html.tree.get_mut(entry.node_id) {
                        fn append_tree(
                            dst: &mut ego_tree::NodeMut<Node>,
                            src: &ego_tree::Tree<Node>,
                        ) {
                            let root = src.root();
                            let mut new_node = dst.append(root.value().clone());
                            fn append_subtree(
                                dst: &mut ego_tree::NodeMut<Node>,
                                src: &ego_tree::NodeRef<Node>,
                            ) {
                                let mut new_node = dst.append(src.value().clone());
                                for child in src.children() {
                                    append_subtree(&mut new_node, &child);
                                }
                            }
                            for child in root.children() {
                                append_subtree(&mut new_node, &child);
                            }
                        }
                        append_tree(&mut parent_mut, &subtree);
                    }
                }
            }
        }
    });
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_append(
    handle: i64,
    html: *const c_char,
) {
    let html_str = match unsafe { cstr_to_str(html) } {
        Some(s) => s,
        None => return,
    };
    with_node_doc_mut(handle, |entry, doc| {
        let fragment = Html::parse_fragment(html_str);
        transplant_children(&fragment, &mut doc.html, entry.node_id);
    });
}

// ---------------------------------------------------------------------------
// TextNode mutations
// ---------------------------------------------------------------------------

#[unsafe(no_mangle)]
pub unsafe extern "C" fn scraper_set_text_node_text(
    handle: i64,
    text: *const c_char,
) {
    let text_str = match unsafe { cstr_to_str(text) } {
        Some(s) => s,
        None => return,
    };
    with_node_doc_mut(handle, |entry, doc| {
        if let Some(mut node_mut) = doc.html.tree.get_mut(entry.node_id) {
            if let Node::Text(ref mut t) = node_mut.value() {
                t.text = text_str.into();
            }
        }
    });
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

fn remove_all_children(html: &mut Html, node_id: NodeId) {
    let child_ids: Vec<NodeId> = html
        .tree
        .get(node_id)
        .map(|n| n.children().map(|c| c.id()).collect())
        .unwrap_or_default();
    for child_id in child_ids {
        if let Some(mut child_mut) = html.tree.get_mut(child_id) {
            child_mut.detach();
        }
    }
}

/// Check if a node is an implicit html5ever wrapper element (html, head, body).
fn is_implicit_wrapper(node: &Node) -> bool {
    if let Node::Element(el) = node {
        let name = el.name.local.as_ref();
        matches!(name, "html" | "head" | "body")
    } else {
        false
    }
}

/// Recursively clone a node and all its descendants from a fragment tree.
fn clone_subtree(node_ref: &ego_tree::NodeRef<Node>) -> ego_tree::Tree<Node> {
    let mut tree = ego_tree::Tree::new(node_ref.value().clone());
    fn clone_children(
        src: &ego_tree::NodeRef<Node>,
        dst: &mut ego_tree::NodeMut<Node>,
    ) {
        for child in src.children() {
            let mut child_mut = dst.append(child.value().clone());
            clone_children(&child, &mut child_mut);
        }
    }
    clone_children(node_ref, &mut tree.root_mut());
    tree
}

/// Collect content nodes from a parsed fragment, unwrapping implicit html5ever
/// wrapper elements (html, head, body) and cloning full subtrees.
fn collect_fragment_trees(fragment: &Html) -> Vec<ego_tree::Tree<Node>> {
    let mut trees = Vec::new();
    fn collect_recursive(
        node_ref: &ego_tree::NodeRef<Node>,
        trees: &mut Vec<ego_tree::Tree<Node>>,
    ) {
        for child in node_ref.children() {
            if matches!(child.value(), Node::Document) || is_implicit_wrapper(child.value()) {
                // Unwrap: recurse into children
                collect_recursive(&child, trees);
            } else {
                // Real content node — clone the entire subtree
                trees.push(clone_subtree(&child));
            }
        }
    }
    collect_recursive(&fragment.tree.root(), &mut trees);
    trees
}

fn transplant_children(fragment: &Html, target_html: &mut Html, target_node_id: NodeId) {
    let trees = collect_fragment_trees(fragment);
    for subtree in trees {
        if let Some(mut target_mut) = target_html.tree.get_mut(target_node_id) {
            fn append_tree(dst: &mut ego_tree::NodeMut<Node>, src: &ego_tree::Tree<Node>) {
                let root = src.root();
                let mut new_node = dst.append(root.value().clone());
                for child in root.children() {
                    append_subtree(&mut new_node, &child);
                }
            }
            fn append_subtree(
                dst: &mut ego_tree::NodeMut<Node>,
                src: &ego_tree::NodeRef<Node>,
            ) {
                let mut new_node = dst.append(src.value().clone());
                for child in src.children() {
                    append_subtree(&mut new_node, &child);
                }
            }
            append_tree(&mut target_mut, &subtree);
        }
    }
}
