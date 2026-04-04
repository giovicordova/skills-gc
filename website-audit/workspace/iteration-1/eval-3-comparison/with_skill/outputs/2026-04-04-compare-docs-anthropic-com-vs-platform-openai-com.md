# Website Comparison: docs.anthropic.com vs platform.openai.com

**Date:** 2026-04-04
**Categories compared:** AEO, GEO
**Pages crawled per site:** 4 (homepage + 3 inner pages)

> **Note:** docs.anthropic.com now redirects to platform.claude.com/docs. platform.openai.com now serves from developers.openai.com. This audit used the canonical destinations.

---

## Overall Comparison

| Category | docs.anthropic.com | platform.openai.com | Winner |
|----------|-------------------|---------------------|--------|
| **Overall** | **55.7/100 (F)** | **50.0/100 (F)** | docs.anthropic.com |
| AEO | 72.4/100 (C) | 74.1/100 (C) | platform.openai.com |
| GEO | 38.9/100 (F) | 25.9/100 (F) | docs.anthropic.com |

---

## AI Crawler Policy

### docs.anthropic.com (platform.claude.com)

| Bot | Type | Status |
|-----|------|--------|
| GPTBot | Training | Not mentioned (allowed by default) |
| ClaudeBot | Training | Not mentioned (allowed by default) |
| Google-Extended | Training | Not mentioned (allowed by default) |
| GoogleOther | Training | Not mentioned (allowed by default) |
| Applebot-Extended | Training | Not mentioned (allowed by default) |
| Meta-ExternalAgent | Training | Not mentioned (allowed by default) |
| Bytespider | Training | Not mentioned (allowed by default) |
| OAI-SearchBot | Retrieval | Not mentioned (allowed by default) |
| ChatGPT-User | Retrieval | Not mentioned (allowed by default) |
| PerplexityBot | Retrieval | Not mentioned (allowed by default) |

**Strategy grade: B — Permissive.** The robots.txt only blocks `/api/` for all user agents. No AI-specific bot rules. All training and retrieval bots are allowed by default. This maximises AI search visibility but allows content to be used for model training.

**Sitemap:** Present at platform.claude.com/sitemap.xml with prioritised URLs.

### platform.openai.com (developers.openai.com)

| Bot | Type | Status |
|-----|------|--------|
| GPTBot | Training | Not mentioned (allowed by default) |
| ClaudeBot | Training | Not mentioned (allowed by default) |
| Google-Extended | Training | Not mentioned (allowed by default) |
| GoogleOther | Training | Not mentioned (allowed by default) |
| Applebot-Extended | Training | Not mentioned (allowed by default) |
| Meta-ExternalAgent | Training | Not mentioned (allowed by default) |
| Bytespider | Training | Not mentioned (allowed by default) |
| OAI-SearchBot | Retrieval | Not mentioned (allowed by default) |
| ChatGPT-User | Retrieval | Not mentioned (allowed by default) |
| PerplexityBot | Retrieval | Not mentioned (allowed by default) |

**Strategy grade: B — Permissive.** The robots.txt blocks dashboard-specific paths (settings, finetune, assistants, threads, etc.) but has no AI-specific bot rules. All bots are allowed on documentation content.

**Sitemap:** Present at platform.openai.com/sitemap.xml but extremely minimal (only 1 URL: the tokenizer page). This is a significant gap.

> AI crawler policy is informational and does not affect the audit score.

---

## Category Analysis

### AEO (Answer Engine Optimization)

**docs.anthropic.com: 72.4/100 (C) | platform.openai.com: 74.1/100 (C)**

Both sites score in the C range for AEO, with OpenAI holding a slight 1.7-point edge. The core strength shared by both platforms is strong first-paragraph answers and front-loaded key information — developers land on a page and immediately get the core concept. Both also use extensive lists and tables, which answer engines strongly prefer for extraction.

The key differentiator is content depth. Anthropic's docs are significantly more detailed: the Prompting Best Practices page runs 3,200+ words and the Extended Thinking page hits 4,767 words. OpenAI's pages tend to be thinner — the Models page is only 535 words and the Agents page 629 words. While this hurts OpenAI on the content depth check (AEO-N3), it actually helps with section sizing (AEO-I4), where OpenAI's sections land closer to the optimal 100-150 word window. Anthropic's sections often balloon past 300 words.

Neither site uses question-based headings effectively. Anthropic manages a few ("How extended thinking works") but falls below the 20% threshold. OpenAI's headings are almost entirely declarative. Both completely lack FAQ sections — a major missed opportunity given that developer documentation is prime territory for "People Also Ask" and AI answer extraction.

**AEO Results: docs.anthropic.com**

| ID | Check | Severity | Result | Evidence |
|----|-------|----------|--------|----------|
| AEO-C1 | First paragraph answers the question | Critical | PASS | Homepage opens with direct definition of Claude |
| AEO-C2 | Answer blocks 40-60 words | Critical | WARNING | Intro paragraphs tend to be too short (~25 words) or too long (80-150) |
| AEO-C3 | Key answers front-loaded | Critical | PASS | First 100 words contain primary keywords and clear answer |
| AEO-C4 | Question-based headings >= 20% | Critical | WARNING | ~10% question headings; below 20% threshold |
| AEO-C5 | Concise definitions present | Critical | PASS | Clear definitions for Claude, extended thinking, etc. |
| AEO-C6 | FAQ sections | Critical | FAIL | No FAQ sections on any page |
| AEO-I1 | Lists and tables | Important | PASS | Extensive: 75 lists on Extended Thinking page alone |
| AEO-I2 | Clear, plain language | Important | PASS | Well-written developer documentation |
| AEO-I3 | Single primary question per page | Important | PASS | Clear topic focus on every page |
| AEO-I4 | Section length 100-150 words | Important | WARNING | Sections often exceed 300 words |
| AEO-N1 | Step-by-step instructions | Nice to have | PASS | Numbered steps on homepage and guides |
| AEO-N2 | Summary or TL;DR | Nice to have | FAIL | No summaries on long-form content |
| AEO-N3 | Content depth 2000+ words | Nice to have | PASS | Extended Thinking: 4,767 words |

**AEO Results: platform.openai.com**

| ID | Check | Severity | Result | Evidence |
|----|-------|----------|--------|----------|
| AEO-C1 | First paragraph answers the question | Critical | PASS | Text generation opens with clear definition |
| AEO-C2 | Answer blocks 40-60 words | Critical | PASS | First paragraphs consistently in 35-50 word range |
| AEO-C3 | Key answers front-loaded | Critical | PASS | Model names, API references in first 100 words |
| AEO-C4 | Question-based headings >= 20% | Critical | FAIL | ~5% question headings across sampled pages |
| AEO-C5 | Concise definitions present | Critical | PASS | Clear definitions inline |
| AEO-C6 | FAQ sections | Critical | FAIL | No FAQ sections on any page |
| AEO-I1 | Lists and tables | Important | PASS | Heavy list usage (100+ per page including navigation) |
| AEO-I2 | Clear, plain language | Important | PASS | Clear technical writing |
| AEO-I3 | Single primary question per page | Important | PASS | Good topic isolation |
| AEO-I4 | Section length 100-150 words | Important | PASS | Sections mostly in 80-150 word range |
| AEO-N1 | Step-by-step instructions | Nice to have | PASS | Numbered code examples and quickstart steps |
| AEO-N2 | Summary or TL;DR | Nice to have | WARNING | Next steps sections but no upfront summaries |
| AEO-N3 | Content depth 2000+ words | Nice to have | FAIL | Most pages under 700 words |

### GEO (Generative Engine Optimization)

**docs.anthropic.com: 38.9/100 (F) | platform.openai.com: 25.9/100 (F)**

Both platforms fail catastrophically at GEO. Anthropic scores 13 points higher, but both are in the F range. The fundamental problem is identical on both sites: neither treats their documentation as "content" in the publishing sense. There are no authors, no dates, no structured data, and minimal external citations.

Anthropic's edge comes from two areas: better quotable prose and stronger external reference linking. The Prompting Best Practices page contains genuinely memorable, attributable statements and links out to blog posts, cookbooks, and model announcements. OpenAI's docs are more code-heavy with less explanatory prose, making them harder for AI models to quote and attribute.

The complete absence of JSON-LD structured data on both platforms is the single biggest missed opportunity. Neither site uses Article, TechArticle, Organization, or any schema type. For AI models trying to understand what a page is, who wrote it, and when it was last updated, these sites are essentially opaque. Both sites also lack visible publication and modification dates, which directly impacts how AI models assess freshness.

Where both sites pass is on content originality and fact density — unsurprisingly, since they are the authoritative source for their own API documentation. Named entity density is also strong on both platforms, with numerous model names, API endpoints, and technical terms.

**GEO Results: docs.anthropic.com**

| ID | Check | Severity | Result | Evidence |
|----|-------|----------|--------|----------|
| GEO-C1 | Author name visible | Critical | FAIL | No author attribution on any page |
| GEO-C2 | Author credentials stated | Critical | FAIL | No credentials or bios |
| GEO-C3 | Published date present | Critical | FAIL | No publication dates anywhere |
| GEO-C4 | Sources and references linked | Critical | WARNING | Some links to blog posts but few external citations |
| GEO-C5 | Structured data (JSON-LD) | Critical | FAIL | Zero JSON-LD on any page |
| GEO-I1 | Last-updated date | Important | FAIL | No modification dates |
| GEO-I2 | Fact density | Important | PASS | High: model names, token counts, API params |
| GEO-I3 | Original data or perspective | Important | PASS | First-party documentation |
| GEO-I4 | Quotable passages | Important | PASS | Strong: e.g. "Think of Claude as a brilliant but new employee" |
| GEO-I5 | Entity density 15+ | Important | PASS | 20+ named entities per content page |
| GEO-N1 | Expert quotes | Nice to have | FAIL | No attributed quotes |
| GEO-N2 | Methodology disclosed | Nice to have | N/A | Not applicable to documentation |
| GEO-N3 | Content depth 800+ words | Nice to have | PASS | Multiple pages exceed 3,000 words |

**GEO Results: platform.openai.com**

| ID | Check | Severity | Result | Evidence |
|----|-------|----------|--------|----------|
| GEO-C1 | Author name visible | Critical | FAIL | No author attribution on any page |
| GEO-C2 | Author credentials stated | Critical | FAIL | No credentials or bios |
| GEO-C3 | Published date present | Critical | FAIL | No publication dates on docs |
| GEO-C4 | Sources and references linked | Critical | FAIL | Very few external links; no research citations |
| GEO-C5 | Structured data (JSON-LD) | Critical | FAIL | Zero JSON-LD on any page |
| GEO-I1 | Last-updated date | Important | FAIL | No modification dates |
| GEO-I2 | Fact density | Important | PASS | Model names, API endpoints, specific params |
| GEO-I3 | Original data or perspective | Important | PASS | First-party API documentation |
| GEO-I4 | Quotable passages | Important | WARNING | Code-heavy pages with less quotable prose |
| GEO-I5 | Entity density 15+ | Important | PASS | 15+ named entities per content page |
| GEO-N1 | Expert quotes | Nice to have | FAIL | No attributed quotes |
| GEO-N2 | Methodology disclosed | Nice to have | N/A | Not applicable |
| GEO-N3 | Content depth 800+ words | Nice to have | FAIL | Most pages under 700 words |

---

## Indexability (Applied to Both)

| Check | docs.anthropic.com | platform.openai.com |
|-------|-------------------|---------------------|
| IDX-C1: No noindex meta tag | PASS (no noindex) | PASS (no noindex) |
| IDX-C3: No soft 404s | PASS (pages have substantial content) | PASS (pages have substantial content) |
| IDX-I1: Canonical self-referencing | PASS (canonical tags present and self-referencing) | PASS (canonical tags present, trailing slash difference noted) |

> Note: IDX-C2 (X-Robots-Tag) and IDX-I2/I3 (canonical targets, sitemap URL verification) are UNTESTABLE from a browser-only crawl.

---

## Lighthouse Results

Lighthouse audit was not available for this run (no headless Lighthouse configured).

---

## Perplexity Citation Check

Perplexity citation check requires PERPLEXITY_API_KEY (not set).

---

## Top 3 Fixes: docs.anthropic.com

1. **[GEO-C5] Add JSON-LD structured data** — Implement TechArticle schema on all documentation pages with @type, headline, description, datePublished, dateModified, author, and publisher fields. Add Organization schema and WebSite schema with SearchAction to the docs homepage. This single fix addresses both GEO discoverability and supports multiple other checks.

2. **[GEO-C3 + GEO-I1] Add publication and modification dates** — Display visible dates on every documentation page (e.g. "Last updated: 2026-04-01"). Include article:published_time and article:modified_time meta tags. This directly impacts how AI models assess content freshness.

3. **[AEO-C6] Add FAQ sections with FAQPage schema** — Create FAQ sections on key documentation pages (Models Overview, Getting Started, Prompting Best Practices). Use FAQPage structured data. Target common developer questions that would surface in "People Also Ask" and AI answer features.

## Top 3 Fixes: platform.openai.com

1. **[GEO-C5] Add JSON-LD structured data** — Same recommendation as Anthropic: implement TechArticle, Organization, and WebSite schemas across all documentation pages. Neither platform has any structured data, so the first mover gets a significant advantage in AI discoverability.

2. **[AEO-N3 + GEO-N3] Expand content depth on key pages** — The Models page (535 words) and Agents page (629 words) are too thin for comprehensive topic coverage. Expand key guide pages to 2,000+ words with detailed explanations, comparison tables, decision frameworks, and worked examples. Anthropic's equivalent pages are 3-8x longer.

3. **[GEO-C3 + GEO-C4] Add dates and external citations** — Add visible publication/modification dates to all docs. Critically, add citations to external benchmarks, research papers, and independent evaluations. The documentation makes claims about model capabilities without linking to supporting evidence, which weakens its position with AI citation engines.

---

## Summary

Both platforms score poorly overall, driven almost entirely by GEO failures. This is the blind spot of developer documentation: the content is high-quality and authoritative, but it lacks the metadata and attribution signals that generative AI models use to decide what to cite.

**docs.anthropic.com wins overall (55.7 vs 50.0)** primarily because its content is significantly deeper and more quotable. The Prompting Best Practices page alone contains more extractable, attributable content than most of OpenAI's documentation combined. Anthropic also edges ahead on external linking, with cross-references to blog posts and model announcements.

**platform.openai.com wins AEO by a narrow margin (74.1 vs 72.4)** thanks to better-sized answer blocks and tighter sections. OpenAI's documentation is more concise and better-structured for answer extraction, even if it lacks depth.

The strategic takeaway: whichever platform implements JSON-LD structured data, visible dates, and FAQ sections first will gain a substantial advantage in AI search citations. These are low-effort, high-impact changes that neither site has made.
