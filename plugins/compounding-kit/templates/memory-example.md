---
name: feedback_stage_before_live
description: Before any website go-live, deploy a preview first, send the link, then go live
metadata:
  type: feedback
---

Every website change goes to a preview deploy first. The user gets the preview link and says go; only then does it go live.

**Why:** On 14.08.2026 a direct deploy shipped a broken hero on mobile. The user saw it from a client's phone.
**How to apply:** `./deploy.sh --preview`, link in the reply, wait for the go. Related: [[reference_hub_website]].
