# Website Audit: anthropic.com

**Date:** 2026-04-04
**Categories audited:** AEO, GEO, SEO Technical, SEO On-Page, Structured Data
**Pages crawled:** 10

---

## Overall Score: 51.5/100 (F)

| Category | Score | Grade |
|----------|-------|-------|
| AEO | 77.6/100 | C+ |
| GEO | 46.4/100 | F |
| SEO Technical | 66.7/100 | D |
| SEO On-Page | 47.9/100 | F |
| Structured Data | 0.0/100 | F |

---

## Site Profile

| Property | Value |
|----------|-------|
| Domain | anthropic.com (www.anthropic.com) |
| HTTPS | Yes (HTTP/2, HSTS max-age=3600) |
| CMS | Next.js (detected via /_next/ paths, Webflow for content) |
| Pages in sitemap | 386 |
| Pages crawled | 10 |
| Language | en |
| Charset | UTF-8 |
| CDN | Cloudflare |

---

## AI Crawler Policy

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
| Claude-SearchBot | Retrieval | Not mentioned (allowed by default) |
| Claude-User | Retrieval | Not mentioned (allowed by default) |
| PerplexityBot | Retrieval | Not mentioned (allowed by default) |
| Perplexity-User | Retrieval | Not mentioned (allowed by default) |
| Amazonbot | Retrieval | Not mentioned (allowed by default) |

**Strategy grade:** B — Permissive

The robots.txt contains only `User-Agent: * / Allow: /` with no bot-specific rules. All AI crawlers (training and retrieval) are allowed by default. This is a deliberate permissive stance appropriate for a company that wants maximum AI search visibility. However, as an AI safety company, Anthropic may want to consider a more nuanced policy that blocks training bots while keeping retrieval bots allowed (Grade A strategy) to protect proprietary content from model training while remaining visible in AI search results.

> This section is informational. AI crawler policy does not affect the audit score.

---

## AEO (Answer Engine Optimization)

### Summary

Anthropic's content is generally well-structured for answer engines, particularly in engineering blog posts and research articles. Product pages benefit from FAQ sections. The main weaknesses are homepage and landing pages that lead with branding rather than direct answers, and question-based headings falling slightly below the 20% threshold.

### Results

| ID | Check | Severity | Result | Evidence |
|----|-------|----------|--------|----------|
| AEO-C1 | First paragraph answers the question | Critical | WARNING | Homepage first paragraph is promotional; news articles have very short openings (5 words) |
| AEO-C2 | Answer blocks 40-60 words | Critical | PASS | Engineering posts contain well-structured 40-60 word paragraphs |
| AEO-C3 | Key answers front-loaded | Critical | WARNING | Homepage is branding-heavy in first 100 words; product pages perform better |
| AEO-C4 | Question-based headings >= 20% | Critical | WARNING | ~15% of H2-H4 headings are question-based, below 20% threshold |
| AEO-C5 | Concise definitions present | Critical | WARNING | Some definitions exist in engineering posts; missing on homepage and product pages |
| AEO-C6 | FAQ sections on relevant pages | Critical | PASS | FAQ sections on /claude/opus, /claude/sonnet, /product/claude-code, /careers |
| AEO-I1 | Lists and tables for structured answers | Important | PASS | Lists on most pages; tables on product pages for benchmarks |
| AEO-I2 | Clear, plain language | Important | PASS | Content is accessible and well-written |
| AEO-I3 | Single primary question per page | Important | PASS | Each page has clear single topic focus |
| AEO-I4 | Section length 100-150 words | Important | PASS | Sections generally in 80-200 word range |
| AEO-N1 | Step-by-step instructions | Nice to have | PASS | Engineering posts use numbered steps appropriately |
| AEO-N2 | Summary or TL;DR | Nice to have | WARNING | Most long-form articles lack summary sections |
| AEO-N3 | Content depth 2000+ words | Nice to have | PASS | Engineering: 7124 words; Research: 3385 words; Product: 2485 words |

### Fixes

- **AEO-C1: First paragraph answers the question**
  Current: Homepage and news articles open with very short or promotional text
  Fix: Rewrite first paragraphs as declarative 40-60 word statements that directly answer the page's primary question
  Impact: Critical

- **AEO-C3: Key answers front-loaded**
  Current: Homepage first 100 words are branding-heavy
  Fix: Put the most important information (what Anthropic does, what Claude is) in the first 100 words
  Impact: Critical

- **AEO-C4: Question-based headings**
  Current: ~15% of H2-H4 headings are question-based
  Fix: Rephrase descriptive headings as questions where natural, targeting 20%+
  Impact: Critical

- **AEO-C5: Concise definitions present**
  Current: Missing concise "X is..." definitions on homepage and product pages
  Fix: Add 1-2 sentence definitions for Claude, Anthropic, and each product near the top of relevant pages
  Impact: Critical

- **AEO-N2: Summary or TL;DR**
  Current: Most long-form articles lack summary sections
  Fix: Add key takeaways or summary section at top or end of articles over 2000 words
  Impact: Nice to have

---

## GEO (Generative Engine Optimization)

### Summary

GEO is Anthropic's weakest content-quality area. The site produces high-quality, original research and analysis that AI models would want to cite, but it critically fails on authorship attribution — no visible author names or credentials on any page. Combined with the complete absence of structured data, this severely limits how AI models can attribute and trust the content.

### Results

| ID | Check | Severity | Result | Evidence |
|----|-------|----------|--------|----------|
| GEO-C1 | Author name visible | Critical | FAIL | No visible author attribution on any crawled page |
| GEO-C2 | Author credentials stated | Critical | FAIL | No author credentials found on any page |
| GEO-C3 | Published date present | Critical | WARNING | Some article:published_time meta tags exist; dates not consistently visible |
| GEO-C4 | Sources and references linked | Critical | WARNING | Engineering posts link sources well; news/announcements have few external links |
| GEO-C5 | Structured data present | Critical | FAIL | Zero JSON-LD blocks on any page |
| GEO-I1 | Last-updated date | Important | FAIL | No modified dates found on any page |
| GEO-I2 | Fact density | Important | PASS | High fact density in engineering and research content |
| GEO-I3 | Original data or perspective | Important | PASS | Significant original research, unique frameworks, original benchmark data |
| GEO-I4 | Quotable passages | Important | PASS | Many self-contained, quotable insight statements |
| GEO-I5 | Entity density 15+ | Important | PASS | Rich entity density across content pages |
| GEO-N1 | Expert quotes | Nice to have | FAIL | No attributed expert quotes found in crawled pages |
| GEO-N2 | Methodology disclosed | Nice to have | PASS | Research articles include methodology sections |
| GEO-N3 | Content depth 800+ | Nice to have | PASS | All content pages exceed 800 words |

### Fixes

- **GEO-C1: Author name visible**
  Current: Zero visible author names on any page
  Fix: Add visible bylines to all blog posts, engineering articles, and research publications
  Impact: Critical

- **GEO-C2: Author credentials stated**
  Current: No author credentials anywhere
  Fix: Add author bios with titles and expertise. Consider author profile pages linked from bylines
  Impact: Critical

- **GEO-C5: Structured data present**
  Current: Zero JSON-LD on entire site
  Fix: Implement JSON-LD across all pages (see Structured Data section)
  Impact: Critical

- **GEO-C3: Published date present**
  Current: Dates exist in metadata but not consistently visible
  Fix: Display publication dates prominently on all content pages
  Impact: Critical

- **GEO-C4: Sources and references linked**
  Current: News posts often have 0-2 external source links
  Fix: Add external source links to news and announcement posts where claims or data are cited
  Impact: Critical

- **GEO-I1: Last-updated date**
  Current: No modified dates on any page
  Fix: Add visible last-updated dates and article:modified_time meta tags to content pages
  Impact: Important

- **GEO-N1: Expert quotes**
  Current: No attributed expert quotes found
  Fix: Include direct quotes from named researchers or engineers in blog posts
  Impact: Nice to have

---

## SEO Technical

### Summary

Technical foundations are solid — HTTPS, robots.txt, sitemap, and proper 404 handling are all in place. The critical weakness is a very poor LCP (8.3 seconds) that drags down the performance score to 59/100. Missing canonical tags on most pages and widespread duplicate meta descriptions are significant issues.

### Results

| ID | Check | Severity | Result | Evidence |
|----|-------|----------|--------|----------|
| TECH-C1 | robots.txt exists (200) | Critical | PASS | Returns 200 with Allow: / |
| TECH-C2 | robots.txt not blocking content | Critical | PASS | No Disallow rules present |
| TECH-C3 | XML sitemap exists | Critical | PASS | 386 URLs with lastmod dates |
| TECH-C4 | Internal links return 200 | Critical | PASS | All 5 sampled links returned 200 |
| TECH-C5 | HTTPS enabled | Critical | PASS | HTTP/2 200, HTTP redirects to HTTPS, HSTS present |
| TECH-C6 | Mobile viewport configured | Critical | PASS | width=device-width, initial-scale=1 |
| TECH-C7 | Core Web Vitals pass | Critical | FAIL | LCP: 8283ms (POOR), CLS: 0 (GOOD), FID: 39.5ms (GOOD) |
| TECH-I1 | Canonical tag present | Important | WARNING | Only 2 of 10 pages have canonical tags |
| TECH-I2 | Valid sitemap XML | Important | WARNING | Well-formed but contains duplicate /careers entry |
| TECH-I3 | No duplicate meta descriptions | Important | FAIL | 6 of 10 pages share identical boilerplate meta description |
| TECH-I4 | Page load under 3 seconds | Important | FAIL | TTI: 8283ms |
| TECH-N1 | llms.txt present | Nice to have | FAIL | Returns 404 |
| TECH-N2 | Lighthouse performance >= 90 | Nice to have | FAIL | Score: 59/100 |
| TECH-N3 | Lighthouse accessibility >= 90 | Nice to have | PASS | Score: 92/100 |
| TECH-N4 | Proper 404 page | Nice to have | PASS | Returns HTTP 404 with "Not Found" page |

### Fixes

- **TECH-C7: Core Web Vitals — LCP**
  Current: LCP = 8283ms (threshold: 2500ms)
  Fix: Optimise hero image loading (preload LCP element), reduce render-blocking resources, reduce JavaScript payload. Investigate heavy Next.js/Webflow bundle size.
  Impact: Critical

- **TECH-I3: Duplicate meta descriptions**
  Current: 6 pages share identical boilerplate description
  Fix: Write unique meta descriptions for /company, /research, /news, /careers, /legal/privacy
  Impact: Important

- **TECH-I4: Page load time**
  Current: TTI = 8283ms
  Fix: Defer non-critical scripts, reduce main-thread blocking, optimise JavaScript execution
  Impact: Important

- **TECH-I1: Missing canonical tags**
  Current: 8 of 10 crawled pages lack canonical tags
  Fix: Add self-referencing canonical tags to every page
  Impact: Important

- **TECH-I2: Duplicate sitemap entry**
  Current: /careers appears twice in sitemap
  Fix: Remove duplicate entry
  Impact: Important

- **TECH-N1: llms.txt not present**
  Current: /llms.txt returns 404
  Fix: Create /llms.txt with guidance for AI models. Particularly appropriate for an AI company.
  Impact: Nice to have

- **TECH-N2: Lighthouse performance**
  Current: 59/100
  Fix: Address LCP, optimise asset loading, reduce JavaScript payload
  Impact: Nice to have

---

## SEO On-Page

### Summary

URL structure is excellent — clean, descriptive paths throughout. Pages are reachable within 2-3 clicks. However, multiple pages violate the single-H1 rule (careers page has 4 H1s), most titles are far too short to maximise ranking potential, and more than half the crawled pages share identical boilerplate meta descriptions.

### Results

| ID | Check | Severity | Result | Evidence |
|----|-------|----------|--------|----------|
| PAGE-C1 | One H1 per page | Critical | FAIL | /claude/opus: 2 H1s, /claude/sonnet: 2 H1s, /careers: 4 H1s, /product/claude-code: 2 H1s |
| PAGE-C2 | Title tag 50-60 characters | Critical | WARNING | Most titles too short: 'Home \\ Anthropic' (16), 'Careers \\ Anthropic' (19) |
| PAGE-C3 | Unique title tags | Critical | PASS | All 10 pages have unique titles |
| PAGE-C4 | Meta description 150-160 chars | Critical | FAIL | Descriptions range from 91 to 196 chars; most outside optimal range |
| PAGE-C5 | Unique meta descriptions | Critical | FAIL | 6 of 10 pages share identical boilerplate description |
| PAGE-I1 | Correct heading hierarchy | Important | WARNING | Multiple H1s break hierarchy; some H2-to-H4 skips |
| PAGE-I2 | Descriptive alt text on images | Important | WARNING | Most pages handle alt text; product pages with many images need verification |
| PAGE-I3 | Pages reachable within 3 clicks | Important | PASS | All key pages within 2-3 clicks from homepage |
| PAGE-I4 | Clean, descriptive URLs | Important | PASS | Excellent URL structure throughout |
| PAGE-N1 | No orphan pages | Nice to have | UNTESTABLE | Would require crawling all 386 URLs |
| PAGE-N2 | External links have noopener | Nice to have | UNTESTABLE | Not consistently captured during extraction |
| PAGE-N3 | URL length under 75 characters | Nice to have | PASS | All URLs under 75 chars |

### Fixes

- **PAGE-C1: Multiple H1s per page**
  Current: 4 of 10 crawled pages have multiple H1s (/careers has 4)
  Fix: Reduce each page to exactly one H1. Convert FAQ section H1s to H2. Restructure careers page.
  Impact: Critical

- **PAGE-C4: Meta description length**
  Current: Descriptions range 91-196 chars; most outside 150-160 optimal range
  Fix: Rewrite all meta descriptions to target 150-160 characters
  Impact: Critical

- **PAGE-C5: Duplicate meta descriptions**
  Current: 6 of 10 pages share identical boilerplate
  Fix: Write unique descriptions for every page reflecting specific content
  Impact: Critical

- **PAGE-C2: Title tag length**
  Current: Most titles under 30 characters
  Fix: Expand titles to 50-60 characters with primary keywords (e.g., 'Careers at Anthropic | AI Safety & Research Jobs')
  Impact: Critical

- **PAGE-I1: Heading hierarchy**
  Current: Multiple H1s and some level skips
  Fix: Single H1 per page, proper H2 > H3 > H4 nesting
  Impact: Important

- **PAGE-I2: Image alt text**
  Current: Product pages have many images needing alt text verification
  Fix: Audit all images on /claude/opus (37 images) and similar pages for descriptive alt text
  Impact: Important

---

## Structured Data

### Summary

This is the most critical failure area. Anthropic has ZERO JSON-LD structured data on any page across the entire site. No Organization schema, no Article schema on blog posts, no SoftwareApplication schema on product pages, no BreadcrumbList, no FAQPage schema despite having FAQ sections. This means the site is invisible to the knowledge graph and misses all rich result opportunities.

### Results

| ID | Check | Severity | Result | Evidence |
|----|-------|----------|--------|----------|
| SD-C1 | JSON-LD on every page | Critical | FAIL | 0 of 10 pages have any JSON-LD |
| SD-C2 | Valid JSON | Critical | N/A | No JSON-LD to validate |
| SD-C3 | @type matches content | Critical | N/A | No JSON-LD present |
| SD-C4 | Author uses Person/Organization | Critical | N/A | No structured data present |
| SD-C5 | Required fields present | Critical | N/A | No structured data present |
| SD-I1 | Organization schema on homepage | Important | FAIL | Missing entirely |
| SD-I2 | BreadcrumbList on inner pages | Important | FAIL | Missing on all pages |
| SD-I3 | Article schema on blog pages | Important | FAIL | Missing on all content pages |
| SD-I4 | FAQPage schema where FAQ exists | Important | FAIL | FAQ sections exist on 4 pages with no schema |
| SD-I5 | Recommended fields present | Important | N/A | No structured data present |
| SD-N1 | Product schema on product pages | Nice to have | FAIL | Missing on all product pages |
| SD-N2 | Combined schema types | Nice to have | FAIL | No schemas at all |
| SD-N3 | sameAs social links | Nice to have | FAIL | No Organization schema exists |

### Schema Deprecation Check

No JSON-LD found on site. No deprecated types to flag.

### Fixes

- **SD-C1: Implement JSON-LD site-wide**
  Current: Zero structured data on entire site
  Fix: Implement JSON-LD on every page. This is the single highest-impact improvement for the site.
  Impact: Critical

- **SD-I1: Add Organization schema to homepage**
  Current: Missing
  Fix: Add Organization schema with name, url, logo, description, sameAs, contactPoint
  Impact: Important

- **SD-I3: Add Article schema to content pages**
  Current: Missing on all news, engineering, and research pages
  Fix: Add Article/BlogPosting with headline, author (as Person type), datePublished, publisher, image
  Impact: Important

- **SD-I2: Add BreadcrumbList to inner pages**
  Current: Missing
  Fix: Add BreadcrumbList with itemListElement array reflecting navigation path
  Impact: Important

- **SD-I4: Add FAQPage schema**
  Current: FAQ sections on 4 pages lack schema
  Fix: Add FAQPage schema with mainEntity array of Question/acceptedAnswer pairs
  Impact: Important

- **SD-N1: Add SoftwareApplication schema**
  Current: Missing on product pages
  Fix: Add SoftwareApplication schema to Claude model pages and Claude Code
  Impact: Nice to have

- **SD-N3: Add sameAs social links**
  Current: No Organization schema
  Fix: Include sameAs array in Organization schema with social profile URLs
  Impact: Nice to have

---

## Indexability

| ID | Check | Severity | Result | Evidence |
|----|-------|----------|--------|----------|
| IDX-C1 | No noindex meta tag | Critical | PASS | No noindex tags found on any content page (404 page correctly has noindex) |
| IDX-C2 | No X-Robots-Tag noindex | Critical | PASS | No X-Robots-Tag header found in HTTP response |
| IDX-C3 | No soft 404s | Critical | PASS | All crawled pages have substantial content (>100 words) |
| IDX-I1 | Canonical self-referencing | Important | WARNING | Only 2 of 10 pages have canonical tags; those that do are self-referencing correctly |
| IDX-I2 | Canonical target returns 200 | Important | PASS | Canonical targets (where present) return 200 |
| IDX-I3 | Sitemap URLs return 200 | Important | PASS | Sampled sitemap URLs all return 200 |

---

## Lighthouse Results

| Metric | Score |
|--------|-------|
| Performance | 59 |
| Accessibility | 92 |
| Best Practices | 100 |
| SEO | 92 |

### Core Web Vitals

| Metric | Value | Status |
|--------|-------|--------|
| LCP | 8283ms | Poor (threshold: 2500ms) |
| CLS | 0 | Good (threshold: 0.1) |
| FID | 39.5ms | Good (threshold: 100ms) |
| TTFB | 50ms | Good |

---

## Perplexity Citation Check

> Perplexity citation check requires PERPLEXITY_API_KEY. This check was marked UNTESTABLE.

---

## Priority Fix List

Ordered by impact (Critical FAILs first, then Critical WARNINGs, then Important FAILs, etc.)

### Critical

1. **[SD-C1] JSON-LD structured data missing site-wide** — Implement JSON-LD on every page. Start with Organization on homepage, Article/BlogPosting on content pages, SoftwareApplication on product pages, BreadcrumbList on all inner pages. This is the single highest-impact change.
2. **[GEO-C1] No visible author names** — Add author bylines to all blog posts, engineering articles, and research publications.
3. **[GEO-C2] No author credentials** — Add author bios with titles, expertise, and relevant background to content pages.
4. **[GEO-C5] No structured data (GEO perspective)** — Same fix as SD-C1; structured data is critical for AI model trust signals.
5. **[TECH-C7] LCP at 8.3 seconds** — Optimise hero image loading, preload LCP element, reduce render-blocking resources, investigate heavy JS bundle.
6. **[PAGE-C1] Multiple H1 tags** — Reduce /claude/opus, /claude/sonnet, /product/claude-code to 1 H1 each. /careers needs 4 H1s reduced to 1.
7. **[PAGE-C4] Meta descriptions wrong length** — Rewrite all meta descriptions to target 150-160 characters with unique, compelling copy.
8. **[PAGE-C5] Duplicate meta descriptions** — Replace boilerplate description on 6+ pages with unique descriptions per page.

### Important

9. **[TECH-I3] Duplicate meta descriptions (technical)** — Same root cause as PAGE-C5; write unique descriptions site-wide.
10. **[TECH-I4] Page load 8.3 seconds** — Defer non-critical scripts, reduce main-thread blocking, optimise JS execution.
11. **[TECH-I1] Missing canonical tags** — Add self-referencing canonical tags to all pages (8 of 10 crawled pages lack them).
12. **[GEO-I1] No last-updated dates** — Add article:modified_time meta tags and visible "last updated" dates on content pages.
13. **[SD-I1] Missing Organization schema on homepage** — Add Organization JSON-LD with name, url, logo, description, sameAs, contactPoint.
14. **[SD-I3] Missing Article schema on content pages** — Add Article/BlogPosting schema with headline, author, datePublished, publisher, image.
15. **[SD-I2] Missing BreadcrumbList** — Add BreadcrumbList schema to all inner pages.
16. **[SD-I4] Missing FAQPage schema** — Add FAQPage schema to /claude/opus, /claude/sonnet, /product/claude-code, /careers.
17. **[PAGE-I1] Heading hierarchy issues** — Fix multiple H1s and level skips across the site.
18. **[PAGE-C2] Titles too short** — Expand titles to 50-60 characters with keywords.

### Nice to Have

19. **[TECH-N1] No llms.txt** — Create /llms.txt. Particularly appropriate for an AI company.
20. **[TECH-N2] Performance score 59** — Address LCP and JS optimisation to reach 90+.
21. **[SD-N1] Missing Product/SoftwareApplication schema** — Add to Claude model and product pages.
22. **[SD-N3] Missing sameAs social links** — Add to Organization schema.
23. **[GEO-N1] No expert quotes** — Include attributed quotes from researchers in blog posts.
24. **[AEO-N2] No summaries on long-form content** — Add TL;DR or key takeaways sections.
