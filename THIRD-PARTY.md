# Third-party material

## Included in this plugin

| Skill | Source | Licence | Note |
|---|---|---|---|
| debugging-and-error-recovery | github.com/addyosmani/agent-skills, commit 301b02b | MIT | copied 2026-11-04, see SOURCE.md in the skill |
| doubt-driven-development | github.com/addyosmani/agent-skills, commit 301b02b | MIT | same |
| source-driven-development | github.com/addyosmani/agent-skills, commit 301b02b | MIT | same |

MIT notice for the three skills above: Copyright (c) Addy Osmani. Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files, to deal in the Software without restriction, subject to the condition that the above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.

`software-factory` originally shipped with two vendored design rule sets (Emil Kowalski's design engineering, Jakub Krehel's better-ui). They are not included here; install them from their origins if your reviewer-ui role should use them.

## Used alongside, not included

Install from the origin; then add them to your SKILLS.md chains.

| What | Where | Why we use it |
|---|---|---|
| superpowers | official plugin marketplace (obra/superpowers, MIT) | brainstorming, writing-plans, TDD, verification-before-completion as the universal gate |
| context-engineering | context-engineering-marketplace (Muratcan Koylan) | rubric for the weekly context audit |
| seo skill suite | AgriciDaniel (MIT), v2.2.5 | site audits, page checks, GEO |
| design-taste-frontend (tasteskill v2) | its GitHub repo | art direction for public pages |
| last30days | github.com/mvanhorn/last30days-skill | what people say about a topic right now |
| context-profile | github.com/byODCUS/context-profile | interview a person into a portable context profile |

Agents `code-reviewer`, `security-auditor` and `deep-research-specialist` in our setup come from public agent catalogs whose exact origin we did not record; they are not included.
