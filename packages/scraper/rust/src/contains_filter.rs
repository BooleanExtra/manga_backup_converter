use ego_tree::NodeRef;
use scraper::Node;

/// Parsed :contains-family pseudo-selector extracted from a CSS selector string.
pub(crate) struct ContainsFilter {
    pub search_text: String,
    pub kind: ContainsKind,
}

#[derive(Clone, Copy)]
pub(crate) enum ContainsKind {
    /// :contains(text) — case-insensitive, whitespace-normalized, all text
    Contains,
    /// :containsOwn(text) — case-insensitive, whitespace-normalized, own text
    ContainsOwn,
    /// :containsWholeText(text) — case-sensitive, raw, all text
    WholeText,
    /// :containsWholeOwnText(text) — case-sensitive, raw, own text
    WholeOwnText,
    /// :containsData(text) — case-insensitive, raw, element data
    ContainsData,
}

fn normalise_whitespace(s: &str) -> String {
    s.split_whitespace().collect::<Vec<&str>>().join(" ")
}

fn get_element_text(el: &scraper::ElementRef) -> String {
    normalise_whitespace(&el.text().collect::<String>())
}

fn get_own_text(node_ref: &NodeRef<Node>) -> String {
    let raw: String = node_ref
        .children()
        .filter_map(|c| match c.value() {
            Node::Text(t) => Some(t.text.as_ref()),
            _ => None,
        })
        .collect::<Vec<&str>>()
        .join("");
    normalise_whitespace(&raw)
}

fn get_whole_text(el: &scraper::ElementRef) -> String {
    el.text().collect()
}

fn get_whole_own_text(node_ref: &NodeRef<Node>) -> String {
    node_ref
        .children()
        .filter_map(|c| match c.value() {
            Node::Text(t) => Some(t.text.to_string()),
            _ => None,
        })
        .collect::<Vec<String>>()
        .join("")
}

fn get_data(node_ref: &NodeRef<Node>) -> String {
    get_whole_own_text(node_ref)
}

// Ordered longest-prefix-first to avoid `:contains(` matching before `:containsOwn(`.
const CONTAINS_PREFIXES: &[(&str, ContainsKind)] = &[
    (":containsWholeOwnText(", ContainsKind::WholeOwnText),
    (":containsWholeText(", ContainsKind::WholeText),
    (":containsData(", ContainsKind::ContainsData),
    (":containsOwn(", ContainsKind::ContainsOwn),
    (":contains(", ContainsKind::Contains),
];

/// Find the closing `)` that balances nested parentheses.
fn find_closing_paren(s: &str) -> Option<usize> {
    let mut depth = 0;
    for (i, c) in s.char_indices() {
        match c {
            '(' => depth += 1,
            ')' if depth > 0 => depth -= 1,
            ')' => return Some(i),
            _ => {}
        }
    }
    None
}

/// Strip all :contains-family pseudo-selectors from a CSS selector string.
/// Returns the base selector and a list of filters (all must match).
pub(crate) fn strip_contains(sel_str: &str) -> (String, Vec<ContainsFilter>) {
    let mut remaining = sel_str.to_string();
    let mut filters = Vec::new();

    'outer: loop {
        for &(prefix, kind) in CONTAINS_PREFIXES {
            if let Some(start) = remaining.find(prefix) {
                let text_start = start + prefix.len();
                if let Some(rel_end) = find_closing_paren(&remaining[text_start..]) {
                    let raw_text = &remaining[text_start..text_start + rel_end];
                    let base = format!(
                        "{}{}",
                        &remaining[..start],
                        &remaining[text_start + rel_end + 1..]
                    );
                    let search_text = match kind {
                        ContainsKind::Contains | ContainsKind::ContainsOwn => {
                            normalise_whitespace(raw_text).to_lowercase()
                        }
                        ContainsKind::ContainsData => raw_text.to_lowercase(),
                        ContainsKind::WholeText | ContainsKind::WholeOwnText => {
                            raw_text.to_string()
                        }
                    };
                    filters.push(ContainsFilter {
                        search_text,
                        kind,
                    });
                    remaining = base;
                    continue 'outer;
                }
            }
        }
        break;
    }

    (remaining, filters)
}

/// Check if an element matches a contains filter.
pub(crate) fn matches_filter(
    filter: &ContainsFilter,
    el: &scraper::ElementRef,
    node_ref: &NodeRef<Node>,
) -> bool {
    match filter.kind {
        ContainsKind::Contains => get_element_text(el)
            .to_lowercase()
            .contains(&filter.search_text),
        ContainsKind::ContainsOwn => get_own_text(node_ref)
            .to_lowercase()
            .contains(&filter.search_text),
        ContainsKind::WholeText => get_whole_text(el).contains(&filter.search_text),
        ContainsKind::WholeOwnText => get_whole_own_text(node_ref).contains(&filter.search_text),
        ContainsKind::ContainsData => get_data(node_ref)
            .to_lowercase()
            .contains(&filter.search_text),
    }
}
