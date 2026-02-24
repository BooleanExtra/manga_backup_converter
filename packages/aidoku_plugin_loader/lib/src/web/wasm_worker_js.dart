// ignore_for_file: lines_longer_than_80_chars
/// Embedded JavaScript source for the Aidoku WASM Web Worker.
///
/// The worker runs WASM in a dedicated thread where synchronous XMLHttpRequest
/// is allowed, enabling HTTP host imports (`net::send`) to work on web.
///
/// Created as a Blob URL at runtime — no external file serving needed.
const String workerJs = r'''
"use strict";

// ---------------------------------------------------------------------------
// Host-side resource store (mirrors Dart HostStore)
// ---------------------------------------------------------------------------

const store = new Map();
let nextRid = 1;

function storeAdd(resource) {
  const rid = nextRid++;
  store.set(rid, resource);
  return rid;
}

function storeAddBytes(bytes) {
  return storeAdd({ type: 'bytes', data: new Uint8Array(bytes) });
}

function storeGet(rid) {
  return store.get(rid) || null;
}

function storeRemove(rid) {
  const removed = store.get(rid);
  store.delete(rid);
  // Clean up cheerio context if no other resources reference it.
  if (removed && removed.ctxId != null) {
    var inUse = false;
    for (const [, v] of store) {
      if (v.ctxId === removed.ctxId) { inUse = true; break; }
    }
    if (!inUse) cheerioContexts.delete(removed.ctxId);
  }
  if (store.size === 0) { nextRid = 1; cheerioContexts.clear(); nextCtxId = 1; }
}

// ---------------------------------------------------------------------------
// WASM memory helpers
// ---------------------------------------------------------------------------

let wasmMemory = null;
let wasmExports = null;

function refreshMemory() {
  if (wasmMemory) return new Uint8Array(wasmMemory.buffer);
  return null;
}

function readString(ptr, len) {
  const mem = refreshMemory();
  return new TextDecoder().decode(mem.subarray(ptr, ptr + len));
}

function writeToMemory(ptr, bytes) {
  const mem = refreshMemory();
  mem.set(bytes, ptr);
}

function encodeString(s) {
  return new TextEncoder().encode(s);
}

// Postcard varint encoding for string: varint(len) + utf8 bytes
function postcardEncodeString(s) {
  const utf8 = encodeString(s);
  const varint = encodeVarint(utf8.length);
  const result = new Uint8Array(varint.length + utf8.length);
  result.set(varint, 0);
  result.set(utf8, varint.length);
  return result;
}

function encodeVarint(value) {
  const bytes = [];
  while (value >= 0x80) {
    bytes.push((value & 0x7f) | 0x80);
    value >>>= 7;
  }
  bytes.push(value & 0x7f);
  return new Uint8Array(bytes);
}

// ---------------------------------------------------------------------------
// Result buffer reader (matches Rust __handle_result layout)
// ---------------------------------------------------------------------------

function readResult(ptr) {
  const mem = refreshMemory();
  const view = new DataView(mem.buffer);
  const totalLen = view.getInt32(ptr, true);
  if (totalLen < 0) {
    try { wasmExports.free_result(ptr); } catch (e) { /* ignore */ }
    return null;
  }
  const payloadLen = totalLen - 8;
  const data = new Uint8Array(mem.buffer.slice(ptr + 8, ptr + 8 + payloadLen));
  try { wasmExports.free_result(ptr); } catch (e) { /* ignore */ }
  return data;
}

// ---------------------------------------------------------------------------
// Defaults store (per-source preferences)
// ---------------------------------------------------------------------------

const defaults = new Map();
let sourceId = '';

// ---------------------------------------------------------------------------
// HTTP method names
// ---------------------------------------------------------------------------

const HTTP_METHODS = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'];

// ---------------------------------------------------------------------------
// std module
// ---------------------------------------------------------------------------

function buildStdImports() {
  return {
    destroy(rid) { storeRemove(rid); },
    buffer_len(rid) {
      const r = storeGet(rid);
      if (!r || r.type !== 'bytes') return -1;
      return r.data.length;
    },
    _read_buffer(rid, ptr, len) {
      const r = storeGet(rid);
      if (!r || r.type !== 'bytes') return -1;
      const bytes = r.data.length <= len ? r.data : r.data.subarray(0, len);
      writeToMemory(ptr, bytes);
      return 0;
    },
    read_buffer(rid, ptr, len) {
      const r = storeGet(rid);
      if (!r || r.type !== 'bytes') return -1;
      const bytes = r.data.length <= len ? r.data : r.data.subarray(0, len);
      writeToMemory(ptr, bytes);
      return 0;
    },
    _current_date() { return Date.now() / 1000.0; },
    current_date() { return Date.now() / 1000.0; },
    utc_offset() { return new Date().getTimezoneOffset() * -60; },
    // TODO: support format string (fmtPtr/fmtLen), locale, and timezone params
    _parse_date(strPtr, strLen, fmtPtr, fmtLen, localePtr, localeLen, tzPtr, tzLen) {
      try {
        const dateStr = readString(strPtr, strLen).trim();
        if (!dateStr) return -1.0;
        const ms = Date.parse(dateStr);
        if (isNaN(ms)) return -1.0;
        return ms / 1000.0;
      } catch (e) {
        console.warn('[aidoku] _parse_date failed:', e);
        return -1.0;
      }
    },
    // TODO: support format string (fmtPtr/fmtLen), locale, and timezone params
    parse_date(strPtr, strLen, fmtPtr, fmtLen, localePtr, localeLen, tzPtr, tzLen) {
      try {
        const dateStr = readString(strPtr, strLen).trim();
        if (!dateStr) return -1.0;
        const ms = Date.parse(dateStr);
        if (isNaN(ms)) return -1.0;
        return ms / 1000.0;
      } catch (e) {
        console.warn('[aidoku] parse_date failed:', e);
        return -1.0;
      }
    },
  };
}

// ---------------------------------------------------------------------------
// env module
// ---------------------------------------------------------------------------

function buildEnvImports() {
  return {
    _print(ptr, len) {
      if (len > 0) console.log('[aidoku]', readString(ptr, len));
    },
    print(ptr, len) {
      if (len > 0) console.log('[aidoku]', readString(ptr, len));
    },
    _sleep(seconds) {
      // Busy-wait — blocking the worker is fine.
      const end = Date.now() + seconds * 1000;
      while (Date.now() < end) { /* spin */ }
    },
    abort() {
      console.warn('[aidoku] WASM abort called (plugin panic)');
    },
    _send_partial_result(ptr) {
      try {
        const mem = refreshMemory();
        const view = new DataView(mem.buffer);
        const length = view.getUint32(ptr, true);
        if (length > 0) {
          const data = new Uint8Array(mem.buffer.slice(ptr + 8, ptr + 8 + length));
          self.postMessage({ type: 'partial_result', data: data }, [data.buffer]);
        }
      } catch (e) {
        console.warn('[aidoku] _send_partial_result failed:', e);
      }
    },
    send_partial_result(ptr) {
      try {
        const mem = refreshMemory();
        const view = new DataView(mem.buffer);
        const length = view.getUint32(ptr, true);
        if (length > 0) {
          const data = new Uint8Array(mem.buffer.slice(ptr + 8, ptr + 8 + length));
          self.postMessage({ type: 'partial_result', data: data }, [data.buffer]);
        }
      } catch (e) {
        console.warn('[aidoku] send_partial_result failed:', e);
      }
    },
  };
}

// ---------------------------------------------------------------------------
// net module
// ---------------------------------------------------------------------------

function buildNetImports() {
  return {
    init(method) {
      return storeAdd({
        type: 'http',
        method: method,
        url: null,
        headers: {},
        body: null,
        timeout: 30.0,
        statusCode: null,
        responseBody: null,
        responseHeaders: {},
      });
    },
    set_url(rid, ptr, len) {
      const r = storeGet(rid);
      if (!r || r.type !== 'http') return -1;
      r.url = readString(ptr, len);
      return 0;
    },
    set_header(rid, kp, kl, vp, vl) {
      const r = storeGet(rid);
      if (!r || r.type !== 'http') return -1;
      r.headers[readString(kp, kl)] = readString(vp, vl);
      return 0;
    },
    set_body(rid, ptr, len) {
      const r = storeGet(rid);
      if (!r || r.type !== 'http') return -1;
      const mem = refreshMemory();
      r.body = new Uint8Array(mem.buffer.slice(ptr, ptr + len));
      return 0;
    },
    set_timeout(rid, timeout) {
      const r = storeGet(rid);
      if (!r || r.type !== 'http') return -1;
      r.timeout = timeout;
      return 0;
    },
    send(rid) {
      const r = storeGet(rid);
      if (!r || r.type !== 'http' || !r.url) return -1;
      try {
        const methodStr = r.method < HTTP_METHODS.length ? HTTP_METHODS[r.method] : 'GET';
        console.log('[aidoku/net]', methodStr, r.url);
        const xhr = new XMLHttpRequest();
        xhr.open(methodStr, r.url, false); // synchronous
        xhr.responseType = 'arraybuffer';
        // TODO: xhr.timeout is ignored for synchronous XHR; implement timeout
        // via AbortController or async XHR + Atomics.wait if needed
        xhr.timeout = r.timeout * 1000;
        for (const [k, v] of Object.entries(r.headers)) {
          try { xhr.setRequestHeader(k, v); } catch (e) { /* forbidden header */ }
        }
        xhr.send(r.body);
        r.statusCode = xhr.status;
        r.responseBody = new Uint8Array(xhr.response || new ArrayBuffer(0));
        // Parse response headers
        const headerStr = xhr.getAllResponseHeaders();
        if (headerStr) {
          for (const line of headerStr.trim().split(/\r?\n/)) {
            const idx = line.indexOf(':');
            if (idx > 0) {
              r.responseHeaders[line.substring(0, idx).trim().toLowerCase()] = line.substring(idx + 1).trim();
            }
          }
        }
        console.log('[aidoku/net]', r.statusCode, r.responseBody.length + 'b');
        return rid;
      } catch (e) {
        console.warn('[aidoku/net] error:', e);
        return -1;
      }
    },
    send_all(ridsPtr, count) {
      const mem = refreshMemory();
      const view = new DataView(mem.buffer);
      for (let i = 0; i < count; i++) {
        const rid = view.getInt32(ridsPtr + i * 4, true);
        // Reuse send logic
        this.send(rid);
      }
      return 0;
    },
    data_len(rid) {
      const r = storeGet(rid);
      if (!r || r.type !== 'http' || !r.responseBody) return -1;
      return r.responseBody.length;
    },
    read_data(rid, ptr, len) {
      const r = storeGet(rid);
      if (!r || r.type !== 'http' || !r.responseBody) return -1;
      const n = Math.min(len, r.responseBody.length);
      writeToMemory(ptr, r.responseBody.subarray(0, n));
      return n;
    },
    get_status_code(rid) {
      const r = storeGet(rid);
      if (!r || r.type !== 'http') return -1;
      return r.statusCode || -1;
    },
    get_header(rid, kp, kl) {
      const r = storeGet(rid);
      if (!r || r.type !== 'http') return -1;
      const key = readString(kp, kl).toLowerCase();
      const val = r.responseHeaders[key];
      if (val == null) return -1;
      return storeAddBytes(postcardEncodeString(val));
    },
    html(rid) {
      const r = storeGet(rid);
      if (!r || r.type !== 'http' || !r.responseBody) return -1;
      const htmlStr = new TextDecoder().decode(r.responseBody);
      const baseUri = r.url || '';
      const $ = cheerio.load(htmlStr);
      const ctxId = nextCtxId++;
      cheerioContexts.set(ctxId, $);
      return storeAdd({ type: 'html', node: $.root()[0], ctxId: ctxId, baseUri: baseUri });
    },
    get_image(rid) {
      const r = storeGet(rid);
      if (!r || r.type !== 'http' || !r.responseBody) return -1;
      return storeAddBytes(r.responseBody);
    },
    // TODO: implement rate limit enforcement
    net_set_rate_limit(permits, period, unit) { /* no-op */ },
    // TODO: implement rate limit enforcement
    set_rate_limit(permits, period, unit) { /* no-op */ },
  };
}

// ---------------------------------------------------------------------------
// html module — using Cheerio (self.cheerio loaded before this script)
// ---------------------------------------------------------------------------

// Cheerio context management: each cheerio.load() creates a $ function.
// Resources track which $ they belong to via ctxId.
const cheerioContexts = new Map();
let nextCtxId = 1;

// Access cheerio — loaded as a UMD global before this script.
const cheerio = (typeof self !== 'undefined' && self.cheerio) || {};
if (typeof cheerio.load !== 'function') {
  console.error('[aidoku] cheerio not loaded — HTML parsing will fail');
}

function getCtx(ctxId) {
  return cheerioContexts.get(ctxId) || null;
}

function resolveUrl(baseUri, raw) {
  if (!baseUri || !raw) return raw || '';
  try { return new URL(raw, baseUri).href; }
  catch (e) { return raw; }
}

// Get the resource and its cheerio context for an html-type RID.
function asHtml(rid) {
  const r = storeGet(rid);
  if (!r || r.type !== 'html') return null;
  return r;
}

// ---------------------------------------------------------------------------
// Jsoup pseudo-selector engine
// ---------------------------------------------------------------------------

// Text helpers for jsoup pseudo-selectors.
function getOwnText($, el) {
  return $(el).contents().filter(function(_, n) { return n.type === 'text'; })
    .map(function(_, n) { return n.data || ''; }).get().join('').trim();
}

function getOwnWholeText($, el) {
  return $(el).contents().filter(function(_, n) { return n.type === 'text'; })
    .map(function(_, n) { return n.data || ''; }).get().join('');
}

function getDataText($, el) {
  // In Cheerio, elements have type:'tag' and name:'script'/'style'.
  var tagName = (el.name || '').toLowerCase();
  if (tagName === 'script' || tagName === 'style') {
    return $(el).html() || '';
  }
  // For comments and nested script/style, check children.
  var text = '';
  $(el).contents().each(function(_, n) {
    if (n.type === 'comment') text += n.data || '';
    var nTag = (n.name || '').toLowerCase();
    if (nTag === 'script' || nTag === 'style') text += $(n).html() || '';
  });
  return text || $(el).text() || '';
}

// Whole text (preserves original whitespace, unlike $.text() which normalizes).
function getWholeText($, el) {
  var text = '';
  $(el).contents().each(function walk(_, n) {
    if (n.type === 'text') text += n.data || '';
    else $(n).contents().each(walk);
  });
  return text;
}

// Filter factories for jsoup-specific pseudo-selectors.
const jsoupFilters = {
  'contains': function(arg) { return function($, el) {
    return $(el).text().toLowerCase().indexOf(arg.toLowerCase()) >= 0;
  }; },
  'containsOwn': function(arg) { return function($, el) {
    return getOwnText($, el).toLowerCase().indexOf(arg.toLowerCase()) >= 0;
  }; },
  'containsWholeText': function(arg) { return function($, el) {
    return getWholeText($, el).indexOf(arg) >= 0;
  }; },
  'containsWholeOwnText': function(arg) { return function($, el) {
    return getOwnWholeText($, el).indexOf(arg) >= 0;
  }; },
  'containsData': function(arg) { return function($, el) {
    return getDataText($, el).indexOf(arg) >= 0;
  }; },
  'matches': function(arg) { return function($, el) {
    return new RegExp(arg).test($(el).text());
  }; },
  'matchesOwn': function(arg) { return function($, el) {
    return new RegExp(arg).test(getOwnText($, el));
  }; },
  'matchesWholeText': function(arg) { return function($, el) {
    return new RegExp(arg).test(getWholeText($, el));
  }; },
  'matchesWholeOwnText': function(arg) { return function($, el) {
    return new RegExp(arg).test(getOwnWholeText($, el));
  }; },
};

// Parse a selector that may contain jsoup-specific pseudo-selectors.
// Returns { cssSelector: string, filters: [($, el) => bool] }.
//
// Limitation: jsoup pseudo-selectors mid-chain (e.g. "div:contains(x) > a")
// apply the filter to the FINAL matched elements, not the intermediate segment.
// In practice, Aidoku plugins always use pseudo-selectors at the end of a
// selector chain, so this does not cause issues.
function parseJsoupSelector(selector) {
  var filters = [];
  var remaining = selector;
  var cssSelector = '';

  // Process the selector, extracting jsoup pseudo-selectors.
  while (remaining.length > 0) {
    // Find the next : that might be a pseudo-selector.
    var colonIdx = -1;
    var inBrackets = 0;
    for (var i = 0; i < remaining.length; i++) {
      var ch = remaining[i];
      if (ch === '[') inBrackets++;
      else if (ch === ']') inBrackets--;
      else if (ch === ':' && inBrackets === 0) {
        // Check if this is a jsoup pseudo-selector.
        var after = remaining.substring(i + 1);
        var matchedName = null;
        var names = Object.keys(jsoupFilters);
        for (var n = 0; n < names.length; n++) {
          if (after.indexOf(names[n] + '(') === 0) {
            matchedName = names[n];
            break;
          }
        }
        if (matchedName) {
          colonIdx = i;
          break;
        }
      }
    }

    if (colonIdx < 0) {
      // No more jsoup pseudo-selectors — rest is CSS.
      cssSelector += remaining;
      break;
    }

    // Add the CSS part before this pseudo-selector.
    cssSelector += remaining.substring(0, colonIdx);

    // Extract the pseudo-selector name and argument.
    var afterColon = remaining.substring(colonIdx + 1);
    var name = null;
    var names2 = Object.keys(jsoupFilters);
    for (var n2 = 0; n2 < names2.length; n2++) {
      if (afterColon.indexOf(names2[n2] + '(') === 0) {
        name = names2[n2];
        break;
      }
    }

    // Find the matching closing paren (balanced).
    var argStart = name.length + 1; // after "name("
    var depth = 1;
    var argEnd = argStart;
    for (; argEnd < afterColon.length && depth > 0; argEnd++) {
      if (afterColon[argEnd] === '(') depth++;
      else if (afterColon[argEnd] === ')') depth--;
    }
    var arg = afterColon.substring(argStart, argEnd - 1);

    filters.push(jsoupFilters[name](arg));
    remaining = afterColon.substring(argEnd);
  }

  return { cssSelector: cssSelector.trim(), filters: filters };
}

// Select elements using a selector that may include jsoup pseudo-selectors.
function jsoupSelect($, context, selector) {
  var parsed = parseJsoupSelector(selector);
  var css = parsed.cssSelector || '*';
  var results;
  try {
    results = $(context).find(css).toArray();
  } catch (e) {
    console.warn('[CB] cheerio find("' + css + '") failed:', e);
    return [];
  }
  for (var i = 0; i < parsed.filters.length; i++) {
    var filter = parsed.filters[i];
    results = results.filter(function(el) { return filter($, el); });
  }
  return results;
}

function buildHtmlImports() {
  return {
    parse(ptr, len, baseUriPtr, baseUriLen) {
      try {
        const htmlStr = readString(ptr, len);
        let baseUri = '';
        if (baseUriPtr && baseUriLen && baseUriLen > 0) {
          baseUri = readString(baseUriPtr, baseUriLen);
        }
        const $ = cheerio.load(htmlStr);
        const ctxId = nextCtxId++;
        cheerioContexts.set(ctxId, $);
        return storeAdd({ type: 'html', node: $.root()[0], ctxId: ctxId, baseUri: baseUri });
      } catch (e) {
        console.warn('[aidoku] html::parse failed:', e);
        return -1;
      }
    },
    parse_fragment(ptr, len, baseUriPtr, baseUriLen) {
      try {
        const htmlStr = readString(ptr, len);
        let baseUri = '';
        if (baseUriPtr && baseUriLen && baseUriLen > 0) {
          baseUri = readString(baseUriPtr, baseUriLen);
        }
        const $ = cheerio.load(htmlStr);
        const ctxId = nextCtxId++;
        cheerioContexts.set(ctxId, $);
        // Always return root node (matches native which returns a Document).
        return storeAdd({ type: 'html', node: $.root()[0], ctxId: ctxId, baseUri: baseUri });
      } catch (e) {
        console.warn('[aidoku] html::parse_fragment failed:', e);
        return -1;
      }
    },
    select(rid, selectorPtr, selectorLen) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      const selector = readString(selectorPtr, selectorLen);
      try {
        const elements = jsoupSelect($, r.node, selector);
        return storeAdd({ type: 'htmlList', nodes: elements, ctxId: r.ctxId, baseUri: r.baseUri || '' });
      } catch (e) {
        console.warn('[CB] select("' + selector + '") failed:', e);
        return -1;
      }
    },
    select_first(rid, selectorPtr, selectorLen) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      const selector = readString(selectorPtr, selectorLen);
      try {
        const elements = jsoupSelect($, r.node, selector);
        if (elements.length === 0) return -1;
        return storeAdd({ type: 'html', node: elements[0], ctxId: r.ctxId, baseUri: r.baseUri || '' });
      } catch (e) {
        console.warn('[CB] select_first("' + selector + '") failed:', e);
        return -1;
      }
    },
    attr(rid, kp, kl) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      let key = readString(kp, kl);
      // Handle abs: prefix (Jsoup convention) — resolve relative URLs.
      if (key.indexOf('abs:') === 0) {
        const realKey = key.substring(4);
        const raw = $(r.node).attr(realKey);
        if (raw == null) return -1;
        const resolved = resolveUrl(r.baseUri || '', raw);
        return storeAddBytes(postcardEncodeString(resolved));
      }
      const val = $(r.node).attr(key);
      if (val == null) return -1;
      return storeAddBytes(postcardEncodeString(val));
    },
    has_attr(rid, kp, kl) {
      const r = asHtml(rid);
      if (!r) return 0;
      const $ = getCtx(r.ctxId);
      if (!$) return 0;
      return $(r.node).attr(readString(kp, kl)) !== undefined ? 1 : 0;
    },
    text(rid) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      return storeAddBytes(postcardEncodeString($(r.node).text().trim()));
    },
    own_text(rid) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      return storeAddBytes(postcardEncodeString(getOwnText($, r.node)));
    },
    untrimmed_text(rid) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      return storeAddBytes(postcardEncodeString($(r.node).text()));
    },
    html(rid) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      return storeAddBytes(postcardEncodeString($(r.node).html() || ''));
    },
    outer_html(rid) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      return storeAddBytes(postcardEncodeString($.html(r.node) || ''));
    },
    tag_name(rid) {
      const r = asHtml(rid);
      if (!r) return -1;
      const name = r.node.name || r.node.tagName || '';
      return storeAddBytes(postcardEncodeString(name.toLowerCase()));
    },
    id(rid) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      const val = $(r.node).attr('id');
      if (!val) return -1;
      return storeAddBytes(postcardEncodeString(val));
    },
    class_name(rid) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      return storeAddBytes(postcardEncodeString($(r.node).attr('class') || ''));
    },
    base_uri(rid) {
      const r = storeGet(rid);
      const baseUri = (r && r.baseUri) || '';
      return storeAddBytes(postcardEncodeString(baseUri));
    },
    first(rid) {
      const r = storeGet(rid);
      if (!r || r.type !== 'htmlList' || !r.nodes.length) return -1;
      return storeAdd({ type: 'html', node: r.nodes[0], ctxId: r.ctxId, baseUri: r.baseUri || '' });
    },
    last(rid) {
      const r = storeGet(rid);
      if (!r || r.type !== 'htmlList' || !r.nodes.length) return -1;
      return storeAdd({ type: 'html', node: r.nodes[r.nodes.length - 1], ctxId: r.ctxId, baseUri: r.baseUri || '' });
    },
    get(rid, index) {
      const r = storeGet(rid);
      if (!r || r.type !== 'htmlList' || index < 0 || index >= r.nodes.length) return -1;
      return storeAdd({ type: 'html', node: r.nodes[index], ctxId: r.ctxId, baseUri: r.baseUri || '' });
    },
    html_get(rid, index) {
      const r = storeGet(rid);
      if (!r || r.type !== 'htmlList' || index < 0 || index >= r.nodes.length) return -1;
      return storeAdd({ type: 'html', node: r.nodes[index], ctxId: r.ctxId, baseUri: r.baseUri || '' });
    },
    size(rid) {
      const r = storeGet(rid);
      if (!r || r.type !== 'htmlList') return -1;
      return r.nodes.length;
    },
    parent(rid) {
      const r = asHtml(rid);
      if (!r || !r.node.parent) return -1;
      return storeAdd({ type: 'html', node: r.node.parent, ctxId: r.ctxId, baseUri: r.baseUri || '' });
    },
    children(rid) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      return storeAdd({ type: 'htmlList', nodes: $(r.node).children().toArray(), ctxId: r.ctxId, baseUri: r.baseUri || '' });
    },
    next(rid) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      const nextEl = $(r.node).next();
      if (nextEl.length === 0) return -1;
      return storeAdd({ type: 'html', node: nextEl[0], ctxId: r.ctxId, baseUri: r.baseUri || '' });
    },
    previous(rid) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      const prevEl = $(r.node).prev();
      if (prevEl.length === 0) return -1;
      return storeAdd({ type: 'html', node: prevEl[0], ctxId: r.ctxId, baseUri: r.baseUri || '' });
    },
    siblings(rid) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      return storeAdd({ type: 'htmlList', nodes: $(r.node).siblings().toArray(), ctxId: r.ctxId, baseUri: r.baseUri || '' });
    },
    set_text(rid, ptr, len) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      $(r.node).text(readString(ptr, len));
      return 0;
    },
    set_html(rid, ptr, len) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      $(r.node).html(readString(ptr, len));
      return 0;
    },
    remove(rid) {
      const r = asHtml(rid);
      if (!r) return 0;
      const $ = getCtx(r.ctxId);
      if ($) $(r.node).remove();
      return 0;
    },
    escape(ptr, len) {
      const s = readString(ptr, len);
      const escaped = s
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#x27;');
      return storeAddBytes(postcardEncodeString(escaped));
    },
    unescape(ptr, len) {
      const s = readString(ptr, len);
      const unescaped = s
        .replace(/&amp;/g, '&')
        .replace(/&lt;/g, '<')
        .replace(/&gt;/g, '>')
        .replace(/&quot;/g, '"')
        .replace(/&#x27;/g, "'")
        .replace(/&#39;/g, "'");
      return storeAddBytes(postcardEncodeString(unescaped));
    },
    has_class(rid, classPtr, classLen) {
      const r = asHtml(rid);
      if (!r) return 0;
      const $ = getCtx(r.ctxId);
      if (!$) return 0;
      return $(r.node).hasClass(readString(classPtr, classLen)) ? 1 : 0;
    },
    add_class(rid, classPtr, classLen) {
      const r = asHtml(rid);
      if (!r) return 0;
      const $ = getCtx(r.ctxId);
      if ($) $(r.node).addClass(readString(classPtr, classLen));
      return 0;
    },
    remove_class(rid, classPtr, classLen) {
      const r = asHtml(rid);
      if (!r) return 0;
      const $ = getCtx(r.ctxId);
      if ($) $(r.node).removeClass(readString(classPtr, classLen));
      return 0;
    },
    set_attr(rid, kp, kl, vp, vl) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      $(r.node).attr(readString(kp, kl), readString(vp, vl));
      return 0;
    },
    remove_attr(rid, kp, kl) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      $(r.node).removeAttr(readString(kp, kl));
      return 0;
    },
    prepend(rid, ptr, len) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      $(r.node).prepend(readString(ptr, len));
      return 0;
    },
    append(rid, ptr, len) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      $(r.node).append(readString(ptr, len));
      return 0;
    },
    data(rid) {
      const r = asHtml(rid);
      if (!r) return -1;
      const $ = getCtx(r.ctxId);
      if (!$) return -1;
      return storeAddBytes(postcardEncodeString($(r.node).text() || ''));
    },
  };
}

// ---------------------------------------------------------------------------
// defaults module
// ---------------------------------------------------------------------------

function buildDefaultsImports() {
  return {
    get(keyPtr, keyLen) {
      const key = sourceId + '.' + readString(keyPtr, keyLen);
      const stored = defaults.get(key);
      if (stored === undefined || stored === null) return 0;
      if (typeof stored === 'number') return stored;
      if (stored instanceof Uint8Array) return storeAddBytes(stored);
      return 0;
    },
    set(keyPtr, keyLen, kind, value) {
      const key = sourceId + '.' + readString(keyPtr, keyLen);
      if (kind === 6 || value === 0) {
        defaults.delete(key);
      } else {
        const res = storeGet(value);
        if (res && res.type === 'bytes') {
          defaults.set(key, new Uint8Array(res.data));
        }
      }
      return 0;
    },
  };
}

// ---------------------------------------------------------------------------
// canvas module — stub (image manipulation not supported in worker)
// TODO: implement canvas module using OffscreenCanvas API
// ---------------------------------------------------------------------------

function buildCanvasImports() {
  const warn = () => { console.warn('[aidoku] canvas not supported on web worker'); return -1; };
  return {
    new_context: (w, h) => warn(),
    set_transform: (ctx, tx, ty, sx, sy, angle) => warn(),
    draw_image: (ctx, img, dx, dy, dw, dh) => warn(),
    copy_image: (ctx, img, sx, sy, sw, sh, dx, dy, dw, dh) => warn(),
    fill: (ctx, pathPtr, r, g, b, a) => warn(),
    stroke: (ctx, pathPtr, stylePtr) => warn(),
    draw_text: (ctx, textPtr, textLen, size, x, y, font, r, g, b, a) => warn(),
    get_image: (ctx) => warn(),
    new_font: (namePtr, nameLen) => warn(),
    system_font: (weight) => warn(),
    load_font: (urlPtr, urlLen) => warn(),
    new_image: (dataPtr, dataLen) => warn(),
    get_image_data: (imgRid) => warn(),
    get_image_width: (imgRid) => 0.0,
    get_image_height: (imgRid) => 0.0,
  };
}

// ---------------------------------------------------------------------------
// js module — stub
// TODO: implement JS/webview execution (requires embedding a JS engine)
// ---------------------------------------------------------------------------

function buildJsImports() {
  return {
    context_create: () => { console.warn('[aidoku] js module not implemented'); return -1; },
    context_eval: (ctx, strPtr, len) => -1,
    context_get: (ctx, strPtr, len) => -1,
    webview_create: () => -1,
    webview_load: (webview, request) => -1,
    webview_load_html: (webview, htmlPtr, htmlLen, basePtr, baseLen) => -1,
    webview_wait_for_load: (webview) => -1,
    webview_eval: (webview, strPtr, len) => -1,
  };
}

// ---------------------------------------------------------------------------
// Command handler (onmessage)
// ---------------------------------------------------------------------------

self.onmessage = function(event) {
  const msg = event.data;

  if (msg.type === 'init') {
    // msg: { type:'init', wasmBytes: ArrayBuffer, sourceId: string, defaults: {key: value} }
    sourceId = msg.sourceId;

    // Seed defaults.
    if (msg.defaults) {
      for (const [k, v] of Object.entries(msg.defaults)) {
        if (v instanceof Uint8Array || v instanceof ArrayBuffer) {
          defaults.set(k, new Uint8Array(v));
        } else {
          defaults.set(k, v);
        }
      }
    }

    const imports = {
      std: buildStdImports(),
      env: buildEnvImports(),
      net: buildNetImports(),
      html: buildHtmlImports(),
      defaults: buildDefaultsImports(),
      canvas: buildCanvasImports(),
      js: buildJsImports(),
    };

    try {
      const module = new WebAssembly.Module(new Uint8Array(msg.wasmBytes));
      const instance = new WebAssembly.Instance(module, imports);
      wasmExports = instance.exports;
      wasmMemory = instance.exports.memory;

      // Initialize the source.
      try { wasmExports.start(); } catch (e) {
        console.warn('[aidoku] start() failed:', e);
      }

      self.postMessage({ type: 'init_done' });
    } catch (e) {
      self.postMessage({ type: 'error', id: -1, message: 'WASM init failed: ' + e.message });
    }
    return;
  }

  if (msg.type === 'call') {
    // msg: { type:'call', id: number, export: string, rids: [{data: Uint8Array}], args: [int|null] }
    const callId = msg.id;

    // Add resource bytes to the store, tracking assigned RIDs.
    const assignedRids = [];
    if (msg.rids) {
      for (const r of msg.rids) {
        assignedRids.push(storeAddBytes(r.data));
      }
    }

    // Build args array: substitute null entries with next assigned RID.
    let ridIdx = 0;
    const args = [];
    if (msg.args) {
      for (const a of msg.args) {
        if (a === null) {
          args.push(assignedRids[ridIdx++]);
        } else {
          args.push(a);
        }
      }
    }

    try {
      const fn = wasmExports[msg.export];
      if (!fn) {
        self.postMessage({ type: 'result', id: callId, data: null });
        return;
      }

      const ptr = fn(...args);

      // For void-return exports (handle_notification), ptr may be undefined.
      if (ptr === undefined || ptr === null) {
        self.postMessage({ type: 'result', id: callId, data: null, returnValue: 0 });
        return;
      }

      const ptrInt = ptr | 0;

      // For bool-return exports (handle_basic_login, handle_web_login).
      if (msg.returnType === 'bool') {
        self.postMessage({ type: 'result', id: callId, data: null, returnValue: ptrInt });
        return;
      }

      // For void-return exports.
      if (msg.returnType === 'void') {
        self.postMessage({ type: 'result', id: callId, data: null, returnValue: 0 });
        return;
      }

      if (ptrInt <= 0) {
        self.postMessage({ type: 'result', id: callId, data: null });
        return;
      }

      // Read result buffer.
      const data = readResult(ptrInt);
      if (data) {
        self.postMessage({ type: 'result', id: callId, data: data }, [data.buffer]);
      } else {
        self.postMessage({ type: 'result', id: callId, data: null });
      }
    } catch (e) {
      console.warn('[aidoku] call ' + msg.export + ' failed:', e);
      self.postMessage({ type: 'result', id: callId, data: null });
    } finally {
      // Clean up assigned RIDs.
      for (const rid of assignedRids) {
        storeRemove(rid);
      }
    }
    return;
  }

  if (msg.type === 'shutdown') {
    self.close();
    return;
  }
};
''';
