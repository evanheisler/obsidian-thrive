---
name: rn-web-modal-portals-escape-css-var-scope
description: "react-native-web Modal portals to document.body, so vendor DOM inside it loses CSS custom properties scoped to a wrapper class"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 84e6ad89-d822-4d81-a068-99438e58f43b
  modified: 2026-07-30T20:03:53.279Z
---

`react-native-web`'s `Modal` does `document.body.appendChild(el)` + `createPortal` into it
(`ModalPortal.js:26,40`). Anything rendered inside — including our `AnchoredPopup` — lands as a
direct child of `<body>`, **outside** any wrapper class the page established.

That silently breaks vendor CSS whose rules are global but whose *values* come from custom
properties declared on a root class. Stream's `.str-video__device-settings__*` rules match fine
outside the root (plain class selectors), but every value is `var(--str-video__*)`, declared on
`.str-video` and delivered by **inheritance**. Portalled out, each `var()` resolves to nothing and
the whole declaration is dropped — `gap`, `padding`, `background-color`, `border-radius` all
vanish, so the vendor DOM renders as raw unstyled markup.

**Symptom:** vendor content inside an RN-web `Modal`/popup looks completely unstyled and wraps
badly, while the same component renders correctly elsewhere on the page.

**Fix:** re-establish the vendor's scope *inside* the portal using the vendor's own wrapper
component (for Stream: `<StreamTheme className="patient-video-theme">`). Zero new CSS, no rules
targeting vendor internals. Check first that the wrapper's base rule declares only custom
properties and no layout, so nesting it is inert.

**Diagnostic order:** when portalled vendor DOM looks unstyled, check variable *scope* before
suspecting deleted rules — a rule can match perfectly and still produce nothing. See
[[feedback-build-for-the-base-case]] for when wrapping vendor DOM is warranted at all.
