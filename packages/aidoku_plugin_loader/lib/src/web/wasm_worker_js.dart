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
  store.delete(rid);
  if (store.size === 0) nextRid = 1;
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
      const doc = new DOMParser().parseFromString(htmlStr, 'text/html');
      return storeAdd({ type: 'html', node: doc.documentElement, baseUri: '' });
    },
    get_image(rid) {
      const r = storeGet(rid);
      if (!r || r.type !== 'http' || !r.responseBody) return -1;
      return storeAddBytes(r.responseBody);
    },
    net_set_rate_limit(permits, period, unit) { /* no-op */ },
    set_rate_limit(permits, period, unit) { /* no-op */ },
  };
}

// ---------------------------------------------------------------------------
// html module — using native browser DOM APIs (DOMParser in Worker)
// ---------------------------------------------------------------------------

function asElement(rid) {
  const r = storeGet(rid);
  if (!r || r.type !== 'html') return null;
  return r.node;
}

function buildHtmlImports() {
  return {
    parse(ptr, len, baseUriPtr, baseUriLen) {
      try {
        const htmlStr = readString(ptr, len);
        const doc = new DOMParser().parseFromString(htmlStr, 'text/html');
        let baseUri = '';
        if (baseUriPtr && baseUriLen && baseUriLen > 0) {
          baseUri = readString(baseUriPtr, baseUriLen);
        }
        return storeAdd({ type: 'html', node: doc.documentElement, baseUri: baseUri });
      } catch (e) {
        console.warn('[aidoku] html::parse failed:', e);
        return -1;
      }
    },
    parse_fragment(ptr, len, baseUriPtr, baseUriLen) {
      try {
        const htmlStr = readString(ptr, len);
        const doc = new DOMParser().parseFromString('<body>' + htmlStr + '</body>', 'text/html');
        const elements = Array.from(doc.body.children);
        return storeAdd({ type: 'htmlList', nodes: elements });
      } catch (e) {
        console.warn('[aidoku] html::parse_fragment failed:', e);
        return -1;
      }
    },
    select(rid, selectorPtr, selectorLen) {
      const el = asElement(rid);
      if (!el) return -1;
      const selector = readString(selectorPtr, selectorLen);
      try {
        const elements = Array.from(el.querySelectorAll(selector));
        return storeAdd({ type: 'htmlList', nodes: elements });
      } catch (e) {
        console.warn('[aidoku] querySelectorAll("' + selector + '") failed:', e);
        return -1;
      }
    },
    select_first(rid, selectorPtr, selectorLen) {
      const el = asElement(rid);
      if (!el) return -1;
      const selector = readString(selectorPtr, selectorLen);
      try {
        const found = el.querySelector(selector);
        if (!found) return -1;
        return storeAdd({ type: 'html', node: found, baseUri: '' });
      } catch (e) {
        console.warn('[aidoku] querySelector("' + selector + '") failed:', e);
        return -1;
      }
    },
    attr(rid, kp, kl) {
      const el = asElement(rid);
      if (!el) return -1;
      const key = readString(kp, kl);
      const val = el.getAttribute(key);
      if (val == null) return -1;
      return storeAddBytes(postcardEncodeString(val));
    },
    has_attr(rid, kp, kl) {
      const el = asElement(rid);
      if (!el) return 0;
      return el.hasAttribute(readString(kp, kl)) ? 1 : 0;
    },
    text(rid) {
      const el = asElement(rid);
      if (!el) return -1;
      return storeAddBytes(postcardEncodeString((el.textContent || '').trim()));
    },
    own_text(rid) {
      const el = asElement(rid);
      if (!el) return -1;
      let ownText = '';
      for (const child of el.childNodes) {
        if (child.nodeType === 3) ownText += child.textContent;
      }
      return storeAddBytes(postcardEncodeString(ownText.trim()));
    },
    untrimmed_text(rid) {
      const el = asElement(rid);
      if (!el) return -1;
      return storeAddBytes(postcardEncodeString(el.textContent || ''));
    },
    html(rid) {
      const el = asElement(rid);
      if (!el) return -1;
      return storeAddBytes(postcardEncodeString(el.innerHTML || ''));
    },
    outer_html(rid) {
      const el = asElement(rid);
      if (!el) return -1;
      return storeAddBytes(postcardEncodeString(el.outerHTML || ''));
    },
    tag_name(rid) {
      const el = asElement(rid);
      if (!el) return -1;
      return storeAddBytes(postcardEncodeString((el.localName || el.tagName || '').toLowerCase()));
    },
    id(rid) {
      const el = asElement(rid);
      if (!el || !el.id) return -1;
      return storeAddBytes(postcardEncodeString(el.id));
    },
    class_name(rid) {
      const el = asElement(rid);
      if (!el) return -1;
      return storeAddBytes(postcardEncodeString(el.className || ''));
    },
    base_uri(rid) {
      const r = storeGet(rid);
      const baseUri = (r && r.baseUri) || '';
      return storeAddBytes(postcardEncodeString(baseUri));
    },
    first(rid) {
      const r = storeGet(rid);
      if (!r || r.type !== 'htmlList' || !r.nodes.length) return -1;
      return storeAdd({ type: 'html', node: r.nodes[0], baseUri: '' });
    },
    last(rid) {
      const r = storeGet(rid);
      if (!r || r.type !== 'htmlList' || !r.nodes.length) return -1;
      return storeAdd({ type: 'html', node: r.nodes[r.nodes.length - 1], baseUri: '' });
    },
    get(rid, index) {
      const r = storeGet(rid);
      if (!r || r.type !== 'htmlList' || index < 0 || index >= r.nodes.length) return -1;
      return storeAdd({ type: 'html', node: r.nodes[index], baseUri: '' });
    },
    html_get(rid, index) {
      const r = storeGet(rid);
      if (!r || r.type !== 'htmlList' || index < 0 || index >= r.nodes.length) return -1;
      return storeAdd({ type: 'html', node: r.nodes[index], baseUri: '' });
    },
    size(rid) {
      const r = storeGet(rid);
      if (!r || r.type !== 'htmlList') return -1;
      return r.nodes.length;
    },
    parent(rid) {
      const el = asElement(rid);
      if (!el || !el.parentElement) return -1;
      return storeAdd({ type: 'html', node: el.parentElement, baseUri: '' });
    },
    children(rid) {
      const el = asElement(rid);
      if (!el) return -1;
      return storeAdd({ type: 'htmlList', nodes: Array.from(el.children) });
    },
    next(rid) {
      const el = asElement(rid);
      if (!el) return -1;
      const parent = el.parentElement;
      if (!parent) return -1;
      const siblings = Array.from(parent.children);
      const idx = siblings.indexOf(el);
      if (idx < 0 || idx + 1 >= siblings.length) return -1;
      return storeAdd({ type: 'html', node: siblings[idx + 1], baseUri: '' });
    },
    previous(rid) {
      const el = asElement(rid);
      if (!el) return -1;
      const parent = el.parentElement;
      if (!parent) return -1;
      const siblings = Array.from(parent.children);
      const idx = siblings.indexOf(el);
      if (idx <= 0) return -1;
      return storeAdd({ type: 'html', node: siblings[idx - 1], baseUri: '' });
    },
    siblings(rid) {
      const el = asElement(rid);
      if (!el || !el.parentElement) return -1;
      const sibs = Array.from(el.parentElement.children).filter(c => c !== el);
      return storeAdd({ type: 'htmlList', nodes: sibs });
    },
    set_text(rid, ptr, len) {
      const el = asElement(rid);
      if (!el) return -1;
      el.textContent = readString(ptr, len);
      return 0;
    },
    set_html(rid, ptr, len) {
      const el = asElement(rid);
      if (!el) return -1;
      el.innerHTML = readString(ptr, len);
      return 0;
    },
    remove(rid) {
      const el = asElement(rid);
      if (el && el.parentElement) el.parentElement.removeChild(el);
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
      const el = asElement(rid);
      if (!el) return 0;
      return el.classList.contains(readString(classPtr, classLen)) ? 1 : 0;
    },
    add_class(rid, classPtr, classLen) {
      const el = asElement(rid);
      if (el) el.classList.add(readString(classPtr, classLen));
      return 0;
    },
    remove_class(rid, classPtr, classLen) {
      const el = asElement(rid);
      if (el) el.classList.remove(readString(classPtr, classLen));
      return 0;
    },
    set_attr(rid, kp, kl, vp, vl) {
      const el = asElement(rid);
      if (!el) return -1;
      el.setAttribute(readString(kp, kl), readString(vp, vl));
      return 0;
    },
    remove_attr(rid, kp, kl) {
      const el = asElement(rid);
      if (!el) return -1;
      el.removeAttribute(readString(kp, kl));
      return 0;
    },
    prepend(rid, ptr, len) {
      const el = asElement(rid);
      if (!el) return -1;
      el.innerHTML = readString(ptr, len) + el.innerHTML;
      return 0;
    },
    append(rid, ptr, len) {
      const el = asElement(rid);
      if (!el) return -1;
      el.innerHTML = el.innerHTML + readString(ptr, len);
      return 0;
    },
    data(rid) {
      const el = asElement(rid);
      if (!el) return -1;
      return storeAddBytes(postcardEncodeString(el.textContent || ''));
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
