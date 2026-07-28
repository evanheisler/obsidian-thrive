---
name: feedback-touching-it-makes-it-yours
description: "An issue bounds where you look, never what you're responsible for once you edit a file — fix what you can see, never answer 'it wasn't in the ticket'"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: cc4f3cba-ef5c-4388-8eea-b653a84beaba
  modified: 2026-07-28T20:59:36.490Z
---

Evan, after a wrong hangup glyph shipped in PR #943: "You seem to constantly fall back to 'not my problem' as if the issue spec is some holy scripture. Any user or logical thinker would understand the implications of 'I need to update this component — here is an identical problem but I wasn't told to touch it so I am going to ignore it.'"

Worse in that instance: the defect was not adjacent work someone declined — #943 *introduced* it by swapping `Phone` for `PhoneOff`. I answered with slicing ("nobody owned that screen"), a systems explanation for a defect with a clear author.

**Why:** an issue defines where to go looking. It does not bound correctness of what you touched. Shipping a visible defect in code you just edited is the failure; "no one told me to change that" is a refusal to own the work, and it reads as evasion because it is one.

**How to apply:** when editing a file, fix every defect I can see in it — especially one identical to the defect I was sent to fix. If the extra fix is genuinely large or risky, do the small correct thing and say what I found and left, in the PR body; never leave it silent and never justify it with ticket boundaries. Never explain a defect I authored by pointing at how work was sliced. Related: [[feedback-found-bug-gets-fixed-not-filed]], [[feedback-verify-the-rationale-holds-at-each-site]], [[feedback-no-dead-code-for-test-churn]].

**The inverse failure — "the correct fix is out of scope" is a park trigger, not permission to ship.** In PR #942 the EHR video route stopped being unconditionally dark, because replacing hardcoded dark hexes with `brand.css` tokens made it follow `next-themes`. Pinning it dark was impossible route-locally (Radix portals to `document.body`; next-themes 0.4.6 makes a nested provider a passthrough), and the app-wide root provider was out of BH-3582's scope. The executor wrote that reasoning in a review reply and let the behaviour change ride. Evan: "If you had presented me with that fork I would've deferred it and left the EHR stylesheet unchanged, but since you already burned several cycles on it now we have to ship it." A user-visible behaviour change I did not choose and cannot properly fix within scope goes TO him as a fork, before the work continues — not into a review thread after.

**Correction to my first fix here — do not carry the vendor artifact across.** I replaced `PhoneOff` by vendoring Stream's `PhoneDown` SVG path into `apps/patient/components/video/icons.tsx`. Evan: "You DO NOT COPY IN A FOREIGN ICON that is off our designs. YOU USE A SUITABLE REPLACEMENT." When an import of a vendor asset is removed, the replacement comes from *our* design system — the app's icon library, here `lucide-react-native` — never a copied path from the vendor's source. The existing `GridIcon`/`SpotlightIcon` in that file are not a precedent to extend. See [[feedback-house-rule-doesnt-override-vendor-match]] for the inverse case: take a vendor's *behavior*, never its paint.
