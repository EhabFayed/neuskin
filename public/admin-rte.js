// NeuSkin Studio — rich text editors for journal body paragraphs.
// Ported from the Balhareth admin: each [data-rte] wrapper holds a hidden
// input (the real form field, HTML) and an editor div seeded with the current
// HTML. On submit the editor's semantic HTML is copied back into the hidden
// input, so the server and the public pages keep working with plain HTML.
(function () {
  'use strict';

  var TOOLBAR = [
    [{ header: [2, 3, false] }],
    ['bold', 'italic', 'underline'],
    [{ list: 'ordered' }, { list: 'bullet' }],
    ['link', 'blockquote', 'image'],
    [{ direction: 'rtl' }],
    ['clean']
  ];

  // Quill's stock image button embeds the picked file as a base64 data: URI,
  // which the public sanitizer strips (so "test images" never reached the
  // article). Upload to /admin/uploads instead and embed the returned
  // permanent ActiveStorage URL.
  var UPLOAD_URL = '/admin/uploads';
  var MAX_BYTES = 10 * 1024 * 1024;

  function csrfToken() {
    var meta = document.querySelector('meta[name="csrf-token"]');
    return meta ? meta.getAttribute('content') : '';
  }

  function uploadImage(file) {
    var body = new FormData();
    body.append('file', file);
    return fetch(UPLOAD_URL, {
      method: 'POST',
      body: body,
      credentials: 'same-origin',
      headers: { 'X-CSRF-Token': csrfToken(), 'Accept': 'application/json' }
    }).then(function (res) {
      return res.json().catch(function () { return {}; }).then(function (json) {
        if (!res.ok || !json.url) throw new Error(json.error || ('Upload failed (' + res.status + ')'));
        return json.url;
      });
    });
  }

  function imageHandler() {
    var quill = this.quill;
    var input = document.createElement('input');
    input.type = 'file';
    input.accept = 'image/*';
    input.addEventListener('change', function () {
      var file = input.files && input.files[0];
      if (!file) return;
      if (!/^image\//.test(file.type)) { window.alert('Please choose an image file.'); return; }
      if (file.size > MAX_BYTES) { window.alert('Image is larger than 10 MB.'); return; }
      var range = quill.getSelection(true) || { index: quill.getLength() };
      uploadImage(file).then(function (url) {
        quill.insertEmbed(range.index, 'image', url, 'user');
        quill.setSelection(range.index + 1, 0, 'silent');
      }).catch(function (err) {
        window.alert('Could not upload the image: ' + (err && err.message ? err.message : 'unknown error'));
      });
    });
    input.click();
  }

  function initEditor(wrap) {
    if (wrap.dataset.rteReady || typeof Quill === 'undefined') return;
    wrap.dataset.rteReady = '1';

    var hidden = wrap.querySelector('input[type=hidden]');
    var editorEl = wrap.querySelector('.rte-editor');
    if (!hidden || !editorEl) return;

    var quill = new Quill(editorEl, {
      theme: 'snow',
      modules: { toolbar: { container: TOOLBAR, handlers: { image: imageHandler } } },
      placeholder: wrap.dataset.placeholder || ''
    });

    if (wrap.dataset.dir === 'rtl') {
      quill.root.setAttribute('dir', 'rtl');
      // Saved HTML comes back without Quill's per-line classes (the server
      // sanitizer drops class=), so mark EVERY line RTL / right-aligned — not
      // just the caret's line — or list numbers render over the Arabic text.
      quill.formatLine(0, quill.getLength(), { direction: 'rtl', align: 'right' }, 'api');
    }

    var sync = function () { hidden.value = quill.getSemanticHTML(); };
    quill.on('text-change', sync);

    var form = wrap.closest('form');
    if (form) form.addEventListener('submit', sync);
  }

  function initAll(root) {
    (root || document).querySelectorAll('[data-rte]').forEach(initEditor);
  }

  // Turbo Drive swaps the <body> without firing DOMContentLoaded, so init on
  // turbo:load as well (fires on full loads AND every Turbo visit). The admin
  // layout sets turbo-cache-control: no-cache, so restore visits refetch fresh
  // HTML instead of showing a cached snapshot with dead editors.
  document.addEventListener('DOMContentLoaded', function () { initAll(); });
  document.addEventListener('turbo:load', function () { initAll(); });

  // "+ Add paragraph" inserts rows from a <template> after load — catch any
  // [data-rte] that appears later and initialize it. Observing the root (not
  // <body>) keeps the observer alive across Turbo body swaps.
  new MutationObserver(function (muts) {
    muts.forEach(function (m) {
      m.addedNodes.forEach(function (n) {
        if (n.nodeType !== 1) return;
        if (n.matches && n.matches('[data-rte]')) initEditor(n);
        else if (n.querySelectorAll) initAll(n);
      });
    });
  }).observe(document.documentElement, { childList: true, subtree: true });
})();
