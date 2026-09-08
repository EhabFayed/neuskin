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
    ['link', 'blockquote'],
    [{ direction: 'rtl' }],
    ['clean']
  ];

  function initEditor(wrap) {
    if (wrap.dataset.rteReady || typeof Quill === 'undefined') return;
    wrap.dataset.rteReady = '1';

    var hidden = wrap.querySelector('input[type=hidden]');
    var editorEl = wrap.querySelector('.rte-editor');
    if (!hidden || !editorEl) return;

    var quill = new Quill(editorEl, {
      theme: 'snow',
      modules: { toolbar: TOOLBAR },
      placeholder: wrap.dataset.placeholder || ''
    });

    if (wrap.dataset.dir === 'rtl') {
      quill.root.setAttribute('dir', 'rtl');
      quill.format('direction', 'rtl');
      quill.format('align', 'right');
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
