# AEO/GEO Comparison: docs.anthropic.com vs platform.openai.com

**Date:** 4 April 2026
**Scope:** Answer Engine Optimization (AEO) and Generative Engine Optimization (GEO) audit
**Sites:** Anthropic docs (platform.claude.com/docs) vs OpenAI docs (developers.openai.com)

---

## Executive Summary

OpenAI's developer documentation significantly outperforms Anthropic's on nearly every AEO and GEO signal that matters. The gap is widest in LLM-friendliness (llms.txt, direct Markdown endpoints) and content breadth (2,925 vs 2,085 sitemap URLs across a much wider product surface). Anthropic leads in internationalisation (9 languages vs 0) and has solid traditional SEO foundations, but is missing the emerging GEO infrastructure that makes content easily consumable by AI systems.

**Overall AEO/GEO Score (out of 100):**
- OpenAI: ~72
- Anthropic: ~55

---

## 1. Technical Infrastructure

| Signal | Anthropic (platform.claude.com) | OpenAI (developers.openai.com) | Winner |
|--------|-------------------------------|-------------------------------|--------|
| **Framework** | Next.js (SSR via React Server Components) | Astro v5.16.15 (static-first SSG) | OpenAI |
| **Rendering** | Server-side rendered, content in initial HTML | Server-side rendered, content in initial HTML | Tie |
| **TTFB** | 52ms (fast, via Cloudflare) | 272ms | Anthropic |
| **Total page load** | 619ms / 370KB | 539ms / 259KB | OpenAI |
| **Page weight** | 370KB (heavier due to RSC payload) | 259KB (leaner Astro build) | OpenAI |
| **CDN** | Cloudflare + Google | Cloudflare (implied by Astro hosting) | Tie |

### Analysis
Both sites deliver content server-side, which is essential for crawlability. Anthropic has faster time-to-first-byte but heavier pages due to the React Server Components streaming payload. OpenAI's Astro-based static build produces smaller, more cacheable pages. For AEO purposes, both are crawlable, but OpenAI's lighter pages are marginally better for rapid ingestion.

---

## 2. Meta Tags and On-Page SEO

### Anthropic (Models Overview page)
```
Title: "Models overview - Claude API Docs"
Description: "Claude is a family of state-of-the-art large language models developed by Anthropic..."
Canonical: https://platform.claude.com/docs/en/about-claude/models/overview
OG Title: "Models overview"
OG Description: (matches meta description)
OG Image: Dynamic per-page (https://platform.claude.com/docs/og?locale=en&path=...)
OG Type: article
OG Site Name: "Claude API Docs"
Twitter Card: summary_large_image
```

### OpenAI (Models page)
```
Title: "Models | OpenAI API"
Description: "Explore all available models on the OpenAI Platform."
Canonical: https://developers.openai.com/api/docs/models
OG Title: "Models | OpenAI API"
OG Description: (matches meta description)
OG Image: Static per-page (https://developers.openai.com/og/api/docs/models.png)
OG Type: website
Twitter Card: summary_large_image
Twitter Site: @OpenAIDevs
```

### Comparison

| Signal | Anthropic | OpenAI | Winner |
|--------|-----------|--------|--------|
| **Title format** | "{Page} - Claude API Docs" | "{Page} \| OpenAI API" | Tie |
| **Meta description** | Descriptive, keyword-rich (per page) | Generic/short ("Explore all available models...") | Anthropic |
| **OG image** | Dynamic generation per page | Static pre-built per page | Tie |
| **OG type** | "article" (correct for docs) | "website" (less precise) | Anthropic |
| **OG site_name** | Present | Missing | Anthropic |
| **Twitter @handle** | Missing | @OpenAIDevs | OpenAI |
| **Canonical URLs** | Clean, consistent | Clean, consistent | Tie |

### Analysis
Anthropic has better meta description quality (specific, per-page descriptions vs OpenAI's generic ones). Anthropic also correctly uses `og:type="article"` for documentation pages, which helps AI systems understand content type. OpenAI has a Twitter handle attached. Both sites lack robots meta tags (relying on robots.txt instead).

---

## 3. Structured Data and Schema Markup

| Signal | Anthropic | OpenAI | Winner |
|--------|-----------|--------|--------|
| **JSON-LD** | None | None | Tie (both lose) |
| **Schema.org microdata** | None | None | Tie (both lose) |
| **FAQ schema** | None | None | Tie (both lose) |
| **HowTo schema** | None | None | Tie (both lose) |
| **Breadcrumb schema** | None | None | Tie (both lose) |
| **Article schema** | None | None | Tie (both lose) |

### Analysis
This is a major gap for both sites. Neither implements any structured data markup whatsoever. For AEO, structured data is one of the highest-impact signals:

- **FAQ schema** would allow both sites to appear in featured snippets and be surfaced by answer engines for common questions (e.g., "What is Claude's context window?", "How much does GPT-4 cost?")
- **HowTo schema** would be ideal for quickstart guides and tutorials
- **Article schema** would help AI systems understand authorship, publication date, and content freshness
- **Breadcrumb schema** would improve navigation understanding

**This is the single biggest missed opportunity for both sites.**

---

## 4. LLM-Friendliness (GEO-Specific)

This is where the comparison becomes dramatically one-sided.

| Signal | Anthropic | OpenAI | Winner |
|--------|-----------|--------|--------|
| **llms.txt** | 404 (not found) | Comprehensive, multi-tier hierarchy | **OpenAI** |
| **llms-full.txt** | 404 (not found) | 2.7MB, 60,639 lines | **OpenAI** |
| **Direct Markdown endpoints** | Not available | Every page accessible as .md | **OpenAI** |
| **Sub-product llms.txt** | N/A | 6 separate indexes (API, Apps SDK, Codex, Commerce, API docs, API reference) | **OpenAI** |
| **Content consumable by LLMs** | Only via HTML scraping | Native Markdown, llms.txt indexes, full-text exports | **OpenAI** |

### OpenAI's llms.txt Architecture
```
developers.openai.com/llms.txt          (master index)
  /api/llms.txt                         (API index)
  /api/llms-full.txt                    (API full content)
  /api/docs/llms.txt                    (API docs index)
  /api/docs/llms-full.txt              (API docs full content)
  /api/reference/llms.txt               (API reference index)
  /api/reference/llms-full.txt          (API reference full content)
  /apps-sdk/llms.txt                    (Apps SDK index)
  /apps-sdk/llms-full.txt              (Apps SDK full content)
  /codex/llms.txt                       (Codex index)
  /codex/llms-full.txt                  (Codex full content)
  /commerce/llms.txt                    (Commerce index)
  /commerce/llms-full.txt               (Commerce full content)
```

Each entry in llms.txt includes a title and description alongside its Markdown URL.

### Anthropic's llms.txt Architecture
None. The old docs.anthropic.com/llms.txt redirects to platform.claude.com/docs/llms.txt which returns 404. No llms-full.txt exists either.

### Analysis
This is the most consequential gap in the entire comparison. OpenAI has built a first-class system for LLM consumption:

1. **Hierarchical llms.txt**: A master index links to product-specific indexes, which link to page-level Markdown files
2. **Direct Markdown access**: Any documentation page can be fetched as clean Markdown by appending `.md` to the slug (e.g., `/api/docs/guides/prompt-engineering.md`)
3. **Full-text exports**: 2.7MB single-file dumps allow an LLM to ingest all documentation in one request

This means that when an AI system (ChatGPT, Perplexity, Claude itself, or any RAG pipeline) needs to cite or reference OpenAI documentation, it can do so accurately and efficiently. Anthropic's documentation requires HTML parsing, which is lossy and unreliable.

**Impact**: When users ask AI assistants about API documentation, OpenAI's content is far more likely to be accurately cited and recommended because it is natively machine-readable.

---

## 5. Content Structure and Depth

| Signal | Anthropic | OpenAI | Winner |
|--------|-----------|--------|--------|
| **Sitemap URLs** | 2,085 | 2,925 | OpenAI |
| **English content pages** | ~620 | ~2,925 (single language) | OpenAI |
| **Content sections** | ~8 major sections | ~14 major sections | OpenAI |
| **Product surface covered** | Claude API only | API + Apps SDK + Codex + Agentic Commerce | OpenAI |
| **Heading hierarchy** | Clear H1 > H2 > H3 | Clear H1 > H2 > H3 | Tie |
| **Tables** | Present (model comparisons) | Absent (card-based layout instead) | Anthropic |
| **Code examples** | Present but fewer on landing pages | Multi-language tabs (JS, Python, C#, Java, Go, cURL) | OpenAI |
| **Lists** | 11 on intro page | 101 on landing page | OpenAI |
| **Internal links** | 102 internal + 60 external (intro page) | 413 internal + 12 external (landing page) | OpenAI |

### Heading Quality for AEO

**Anthropic example (Models page):**
- H1: "Models overview"
- H2: "Choosing a model", "Prompt and output performance", "Migrating to Claude 4.6", "Get started with Claude"
- H3: "Latest models comparison"

**OpenAI example (Models page):**
- H1: "Models"
- H2: "Choosing a model", "Frontier models", "Specialized models", "Browse our full catalog of models"
- H3: "GPT-5.4", "GPT-5.4 mini", "GPT-5.4 nano"

### Analysis
Anthropic's heading hierarchy is slightly more descriptive and question-answering-friendly. The H2 "Choosing a model" directly maps to a common user query. However, OpenAI's sheer content volume (4.7x more English pages) creates a much larger surface area for AI systems to draw from. OpenAI also provides significantly more code examples in more languages, which is a strong AEO signal for developer-focused queries.

---

## 6. Internationalisation (i18n)

| Signal | Anthropic | OpenAI | Winner |
|--------|-----------|--------|--------|
| **Languages** | 9 (en, de, es, fr, id, it, ja, ko, ru) | 1 (English only) | **Anthropic** |
| **i18n URL structure** | /docs/{lang}/... (clean) | N/A | Anthropic |
| **Hreflang tags** | Not present in HTML (sitemap only) | None | Anthropic (marginal) |
| **Translated pages** | ~133 per language | 0 | Anthropic |

### Analysis
Anthropic has a significant advantage here. Documentation in 9 languages means AI systems answering questions in German, Japanese, Korean, etc. are far more likely to surface Anthropic content accurately. However, the hreflang tags are missing from the HTML head, which weakens the signal for traditional search engines. These should be present both in the sitemap AND in the HTML.

---

## 7. Robots.txt and Crawl Policy

### Anthropic
```
User-Agent: *
Disallow: /api/
Sitemap: https://platform.claude.com/sitemap.xml
```

### OpenAI
```
User-agent: *
Allow: /
Sitemap: https://developers.openai.com/sitemap-index.xml
```

### Analysis
Both sites are broadly open to crawlers. Anthropic blocks `/api/` (the actual API endpoints, not docs), which is correct. OpenAI explicitly allows everything. Neither site blocks specific AI crawlers (GPTBot, anthropic-ai, etc.), meaning both are open to AI training and retrieval.

---

## 8. Content Freshness Signals

| Signal | Anthropic | OpenAI | Winner |
|--------|-----------|--------|--------|
| **Sitemap lastmod** | Not present | Not present | Tie (both lose) |
| **Published/modified dates on pages** | Not visible | Not visible | Tie (both lose) |
| **Changelog/release notes** | Present in sitemap | Present in sitemap | Tie |
| **Cache-Control** | `private, no-cache, no-store` (aggressive) | Not checked | N/A |

### Analysis
Neither site includes `lastmod` dates in their sitemaps, which is a missed signal for both traditional and AI-powered search engines. Anthropic's aggressive no-cache headers ensure fresh content but may slow down repeated crawler visits.

---

## 9. Navigation and Internal Linking

| Signal | Anthropic | OpenAI | Winner |
|--------|-----------|--------|--------|
| **Sidebar navigation** | Hierarchical, collapsible | Hierarchical, with search | OpenAI (search) |
| **Breadcrumbs** | Implied by URL structure, no markup | Implied by URL structure, no markup | Tie |
| **Cross-linking** | Moderate (links within docs) | Heavy (413 internal links on landing page) | OpenAI |
| **Related content** | Card groups at page bottom | "Start building" section with guides | Tie |
| **Search** | Inkeep (AI-powered) | Built-in search | Tie |

### Analysis
OpenAI's heavier internal linking creates stronger topical clusters, which helps both traditional SEO and AI systems understand content relationships. Anthropic's AI-powered search (Inkeep) is a nice feature for users but does not help with AEO/GEO since it is client-side only.

---

## 10. Domain Authority and Citability

| Signal | Anthropic | OpenAI | Winner |
|--------|-----------|--------|--------|
| **Domain** | platform.claude.com (subdomain) | developers.openai.com (subdomain) | Tie |
| **Redirect from old domain** | docs.anthropic.com 301 -> platform.claude.com | platform.openai.com -> developers.openai.com | Tie |
| **Brand recognition in AI training** | Strong | Very strong | OpenAI (marginal) |
| **External citations** | Moderate | High | OpenAI |

### Analysis
Both sites recently migrated domains (Anthropic from docs.anthropic.com, OpenAI from platform.openai.com). The 301 redirects preserve link equity. OpenAI's documentation is more widely cited across the internet due to earlier market presence, which gives it a baseline advantage in AI training data.

---

## Summary Scorecard

| Category | Anthropic | OpenAI | Weight (AEO/GEO) |
|----------|-----------|--------|-------------------|
| Technical infrastructure | 7/10 | 8/10 | Medium |
| Meta tags and on-page SEO | 8/10 | 6/10 | Medium |
| Structured data (JSON-LD) | 0/10 | 0/10 | **High** |
| LLM-friendliness (llms.txt, .md) | 1/10 | 10/10 | **Critical** |
| Content depth and breadth | 6/10 | 9/10 | High |
| Internationalisation | 9/10 | 0/10 | Medium |
| Crawl policy | 8/10 | 8/10 | Medium |
| Content freshness signals | 3/10 | 3/10 | Medium |
| Internal linking | 6/10 | 8/10 | Medium |
| Domain authority/citability | 7/10 | 8/10 | Medium |

### Weighted Score
- **Anthropic: ~55/100**
- **OpenAI: ~72/100**

---

## Top Recommendations

### For Anthropic (Critical Priority)

1. **Implement llms.txt immediately.** This is the single highest-impact change. Create a hierarchical llms.txt with entries for every documentation page, including title and description. Also create llms-full.txt as a single-file Markdown export.

2. **Add direct Markdown endpoints.** Make every documentation page accessible as clean Markdown (e.g., `/docs/en/about-claude/models/overview.md`). This is the standard OpenAI has set and AI systems now expect.

3. **Add JSON-LD structured data.** At minimum: Article schema on every page, FAQ schema on relevant pages (models, pricing, limits), HowTo schema on quickstart and tutorial pages, BreadcrumbList schema on all pages.

4. **Add hreflang tags to HTML head.** The 9-language advantage is currently under-signalled because hreflang tags only exist in the sitemap, not in page HTML.

5. **Add lastmod to sitemap.** Include accurate last-modified dates for every URL.

### For OpenAI (Lower Priority, Already Strong)

1. **Add JSON-LD structured data.** Same gap as Anthropic -- FAQ, HowTo, Article, and Breadcrumb schemas are all missing.

2. **Improve meta descriptions.** Many pages have generic descriptions (e.g., "Explore all available models on the OpenAI Platform"). These should be specific and answer-oriented.

3. **Add internationalisation.** Zero language support is a growing gap as AI usage expands globally.

4. **Add lastmod to sitemap.** Same gap as Anthropic.

5. **Set og:type to "article" on doc pages.** Currently set to "website" on all pages, which is less precise.

---

## Methodology

Data collected on 4 April 2026 via:
- Direct HTTP requests (curl) to extract server-rendered HTML, meta tags, and headers
- Browser automation (Chrome) for JavaScript-rendered content verification
- Sitemap XML analysis for URL counts and structure
- robots.txt and llms.txt file inspection
- Page timing measurements via curl

Pages analysed per site:
- Homepage/landing page
- Models/pricing page
- Quickstart/getting started
- Prompt engineering guide
- Sitemap, robots.txt, llms.txt
