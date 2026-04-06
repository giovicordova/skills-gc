# Anthropic.com Full Website Audit

**Date:** 4 April 2026
**URL:** https://www.anthropic.com
**Auditor:** Claude (automated)
**Method:** HTTP header inspection, raw HTML analysis, browser DOM analysis, multi-page crawl

---

## Executive Summary

Anthropic.com is a dual-platform site: the homepage and a few core pages (e.g. /company) run on **Webflow**, while most content pages (/research, /news/*, /careers, /learn, /product/*, /transparency, /claude/*) run on **Next.js with Sanity CMS**. This split creates inconsistent SEO implementation. The site has strong fundamentals (fast TTFB, HTTP/3, Cloudflare CDN, solid CSP) but suffers from **missing canonical tags on most pages, zero structured data, duplicate meta tags, missing security headers, and generic meta descriptions reused across unrelated pages**. These are fixable issues that are likely suppressing search visibility and rich-result eligibility.

**Overall grade: B-**
- Technical infrastructure: A
- On-page SEO: C+
- Structured data: F
- Content quality: A-
- Security headers: C+
- Accessibility basics: B
- Social sharing: B-

---

## 1. Technical Infrastructure

### Hosting and Delivery
| Signal | Value | Status |
|--------|-------|--------|
| Hosting | Cloudflare (us-east-1) | OK |
| Protocol | HTTP/2 + HTTP/3 (h3) | Excellent |
| TTFB | ~60ms (cached) | Excellent |
| DOM Content Loaded | ~284ms | Excellent |
| Full Page Load | ~418ms | Excellent |
| CDN | Cloudflare + Webflow CDN + Sanity CDN | OK |
| HTML size (homepage) | 296 KB (decoded) / 45 KB (compressed) | OK |
| Compression | Enabled (gzip/brotli via `vary: accept-encoding`) | OK |

### Platform Split
| Pages | Platform | CMS |
|-------|----------|-----|
| `/`, `/company`, `/events` | Webflow | Webflow CMS |
| `/research`, `/news/*`, `/careers`, `/learn`, `/product/*`, `/claude/*`, `/transparency`, `/responsible-scaling-policy` | Next.js (SSR) | Sanity |

**Issue:** The dual-platform architecture creates inconsistencies in meta tag implementation, canonical handling, and structured data. Webflow pages include canonical tags; Next.js pages do not.

### Redirects
| Test | Result | Status |
|------|--------|--------|
| HTTP to HTTPS | 301 redirect | OK |
| Non-www to www | 302 redirect | Warning -- should be 301 |
| Trailing slash | Both `/company` and `/company/` return 200 with same content | Issue |
| 404 handling | Returns proper 404 status code | OK |

**Issues found:**
1. **Non-www redirect uses 302 (temporary) instead of 301 (permanent).** This leaks link equity and signals to search engines the redirect is temporary. Should be a 301.
2. **Trailing slash inconsistency.** Both `/company` and `/company/` serve identical content (same MD5 hash) without redirecting one to the other. This creates duplicate URLs in search indexes.

### Resource Loading
| Resource Type | Count | Notes |
|---------------|-------|-------|
| External stylesheets | 1 (render-blocking) | Acceptable |
| Scripts | 12 | Several third-party |
| Inline styles | Multiple | Standard for Webflow |
| Total resources | 26 | Lean |
| Preconnect hints | 3 (intellimize, logging) | OK but missing key origins |

### Third-Party Scripts Detected
- Intellimize (A/B testing / personalisation)
- Google Tag Manager
- HubSpot (forms, analytics)
- Facebook pixel
- Vimeo player
- Finsweet (Webflow utilities)

---

## 2. SEO: On-Page Signals

### 2.1 Title Tags

| Page | Title | Length | Assessment |
|------|-------|--------|------------|
| `/` | Home \ Anthropic | 16 chars | Too short, uninformative. "Home" wastes title real estate. |
| `/company` | Company \ Anthropic | 19 chars | Too short, generic. |
| `/research` | Research \ Anthropic | 20 chars | Too short, generic. |
| `/careers` | Careers \ Anthropic | 19 chars | Too short, generic. |
| `/news` | Newsroom \ Anthropic | 20 chars | Too short, generic. |
| `/learn` | AI Learning Resources & Guides from Anthropic \ Anthropic | ~57 chars | Good length, but "Anthropic" appears twice. |
| `/claude/sonnet` | Claude Sonnet 4.6 \ Anthropic | ~29 chars | Adequate. |
| `/product/claude-code` | Claude Code \| Anthropic's agentic coding system | ~49 chars | Good -- descriptive, unique. |
| `/news/claude-opus-4-6` | Claude Opus 4.6 \ Anthropic | ~27 chars | OK. |

**Issues:**
- Most titles are under 30 characters. Best practice is 50-60 characters.
- The `\` separator is unconventional (most sites use `|` or `-`). Not a ranking factor, but looks odd in SERPs.
- Homepage title "Home \ Anthropic" is a missed opportunity. Should describe what Anthropic does.
- Pattern: `{PageName} \ Anthropic` is too generic for most pages.

### 2.2 Meta Descriptions

| Page | Description | Length | Assessment |
|------|-------------|--------|------------|
| `/` | "Anthropic is an AI safety and research company that's working to build reliable, interpretable, and steerable AI systems." | 121 chars | Generic. Same as 4+ other pages. |
| `/company` | Same as homepage | 121 chars | Duplicate -- not unique to page |
| `/research` | Same as homepage | 121 chars | Duplicate |
| `/careers` | Same as homepage | 121 chars | Duplicate |
| `/news` | Same as homepage | 121 chars | Duplicate |
| `/learn` | "Access comprehensive guides, tutorials, and best practices for working with Claude..." | ~140 chars | Good -- unique and descriptive |
| `/product/claude-code` | "Claude Code is Anthropic's agentic coding system..." | ~162 chars | Good |
| `/claude/sonnet` | "Hybrid reasoning model with superior intelligence for agents..." | ~80 chars | Good |
| `/responsible-scaling-policy` | "Stay informed about the latest Claude RSP..." | ~140 chars | Good |
| `/news/claude-opus-4-6` | "We're upgrading our smartest model..." | ~140 chars | Good |

**Critical issue:** At least 5 major pages share the identical meta description. Search engines may ignore duplicated descriptions entirely and auto-generate snippets instead. Every page needs a unique, descriptive meta description.

### 2.3 Heading Structure

**Homepage:**
| Level | Content | Assessment |
|-------|---------|------------|
| H1 | "AI research and products that put safety at the frontier" (duplicated text in source) | 1 H1 -- correct. But text is duplicated in markup. |
| H2 | "What 81,000 people want from AI", "Latest releases", "Claude Opus 4.6", "Claude is a space to think", "Claude on Mars", mission statement, empty H2 (`‍`), "Footer" | Mixed quality. Empty H2 and "Footer" H2 are issues. |

**Issues:**
- **Empty H2 tag** (`‍` -- zero-width joiner) -- meaningless heading.
- **"Footer" as H2** -- footer should use semantic `<footer>` element, not a heading.
- H1 text appears duplicated in the DOM (likely a visual/animation artefact but bad for crawlers).

**Other pages:**
- `/company`: H1 "Making AI systems you can rely on" -- good
- `/research`: H1 "Research" -- acceptable but generic
- `/claude/sonnet`: H1 "Claude Sonnet 4.6" -- good
- `/product/claude-code`: Multiple H1 tags (9 H1s detected) -- **bad practice; should be exactly 1 H1 per page**

### 2.4 Canonical Tags

| Page | Canonical | Status |
|------|-----------|--------|
| `/` (Webflow) | `https://www.anthropic.com` | Present but missing trailing slash (inconsistent with actual URL) |
| `/company` (Webflow) | `https://www.anthropic.com/company` | OK |
| `/research` (Next.js) | NOT SET | Missing |
| `/careers` (Next.js) | NOT SET | Missing |
| `/news` (Next.js) | NOT SET | Missing |
| `/learn` (Next.js) | NOT SET | Missing |
| `/claude/sonnet` (Next.js) | NOT SET | Missing |
| `/product/claude-code` (Next.js) | NOT SET | Missing |
| `/transparency` (Next.js) | NOT SET | Missing |
| `/news/claude-opus-4-6` (Next.js) | NOT SET | Missing |

**Critical issue:** All Next.js pages are missing canonical tags. This is a systemic problem in their Next.js configuration. Combined with the trailing-slash duplicate content issue, this leaves search engines guessing which URL version to index.

### 2.5 Robots and Indexing

| Signal | Value | Status |
|--------|-------|--------|
| robots.txt | `User-Agent: * / Allow: /` | OK -- permissive |
| Sitemap reference | `https://www.anthropic.com/sitemap.xml` | OK |
| Sitemap entries | 583 URLs | Comprehensive |
| meta robots tag | Not set | OK (defaults to index,follow) |
| X-Robots-Tag header | Not set | OK |

No issues here. The robots.txt is clean and the sitemap is well-maintained.

---

## 3. Structured Data

**Score: F**

| Page | JSON-LD | Microdata | RDFa |
|------|---------|-----------|------|
| `/` | None | None | None |
| `/company` | None | None | None |
| `/research` | None | None | None |
| `/news/*` | None | None | None |
| `/careers` | None | None | None |
| `/product/*` | None | None | None |

**Zero structured data across the entire site.** This is the single biggest missed SEO opportunity.

### Recommended structured data to implement:
1. **Organization schema** (homepage) -- name, logo, URL, social profiles, founding date
2. **WebSite schema** (homepage) -- with SearchAction for sitelinks search box
3. **Article / NewsArticle schema** (all /news/* pages) -- headline, author, datePublished, dateModified, image
4. **Product schema** (/claude/*, /product/*) -- name, description, offers
5. **JobPosting schema** (/careers/jobs) -- would enable rich job listings in search
6. **BreadcrumbList schema** (all pages) -- visual breadcrumbs exist on news articles but are not marked up
7. **FAQPage schema** (/careers, /claude/sonnet have FAQ sections) -- would enable rich FAQ results

---

## 4. Open Graph and Social Sharing

### Homepage OG Tags
| Tag | Value | Status |
|-----|-------|--------|
| og:title | "Home \ Anthropic" | Present but weak title |
| og:description | Company boilerplate | Present but generic |
| og:image | Webflow CDN image | Present |
| og:type | "website" (duplicated) | Present -- but tag appears twice |
| og:url | NOT SET | Missing |
| og:site_name | NOT SET | Missing |
| og:locale | NOT SET | Missing |

### Twitter Card Tags
| Tag | Value | Status |
|-----|-------|--------|
| twitter:card | summary_large_image (duplicated) | Present -- but tag appears twice |
| twitter:site | @AnthropicAI | OK |
| twitter:creator | @AnthropicAI | OK |
| twitter:title | Same as og:title | OK |
| twitter:description | Same as og:description | OK |
| twitter:image | NOT SET on homepage | Missing |

### Duplicate Meta Tags (Homepage)
The homepage has **3 sets of duplicate meta tags**:
- `og:type` appears twice
- `twitter:card` appears twice
- `google-site-verification` appears twice

This is likely caused by the Webflow CMS injecting tags and a custom code block also injecting them. While browsers typically use the first occurrence, this is sloppy and can confuse validators.

### News Articles OG Tags
| Tag | Status |
|-----|--------|
| og:type | Set to "website" instead of "article" | 
| article:published_time | Missing |
| article:author | Missing |
| article:section | Missing |

**Issue:** News articles use `og:type="website"` instead of `og:type="article"`. This prevents social platforms from displaying the content with article-specific formatting (publication date, author, etc.).

---

## 5. Content Quality

### Homepage
- **Word count:** ~850 words (excluding navigation/footer)
- **H1 is clear and descriptive** of the company mission
- **Content hierarchy:** Follows a logical flow -- hero, latest releases, featured content, mission, footer
- **Internal links from homepage:** 32 unique internal paths -- good for crawl distribution

### Key Pages Word Count
| Page | Approximate Words | Assessment |
|------|-------------------|------------|
| `/` | ~850 | Adequate for homepage |
| `/company` | ~2,800-3,200 | Comprehensive |
| `/research` | Moderate + 45+ paper listings | Good |
| `/transparency` | ~18,000-22,000 | Very thorough |
| `/product/claude-code` | ~1,800-2,000 | Good |
| `/claude/sonnet` | ~8,500-9,000 | Very detailed |
| `/responsible-scaling-policy` | ~8,500-9,000 | Very detailed |

Content depth is strong across the site. The transparency hub and model pages are particularly thorough.

### Internal Linking
- Homepage links to 32 unique internal URLs
- Navigation structure covers Products, Models, Solutions, Resources, Company sections
- Footer contains comprehensive link taxonomy
- Cross-linking between related pages (e.g. model pages referencing each other) -- good

### Content Freshness
- Homepage was last modified 3 April 2026 -- very fresh
- Sitemap shows most core pages updated within the last month
- News section actively maintained with multiple April 2026 entries

---

## 6. Security Headers

| Header | Value | Status |
|--------|-------|--------|
| Strict-Transport-Security | `max-age=3600` | Weak -- should be `max-age=31536000; includeSubDomains; preload` |
| Content-Security-Policy | Comprehensive policy | Good |
| X-Frame-Options | Missing | Issue |
| X-Content-Type-Options | Missing | Issue |
| Referrer-Policy | Missing | Issue |
| Permissions-Policy | Missing | Issue |

### Issues:
1. **HSTS max-age is only 3600 seconds (1 hour).** Industry best practice is 1 year (31536000). This means if a user visits over HTTP, they're only protected for 1 hour. The site also lacks `includeSubDomains` and `preload` directives.
2. **Four important security headers are missing:**
   - `X-Frame-Options` (clickjacking protection) -- partially mitigated by CSP `frame-ancestors 'self'`
   - `X-Content-Type-Options: nosniff` (MIME sniffing protection)
   - `Referrer-Policy` (controls referrer leakage)
   - `Permissions-Policy` (restricts browser feature access)
3. **CSP includes `'unsafe-inline'` for both scripts and styles.** This weakens XSS protection. While common for Webflow sites, it's a security trade-off.

---

## 7. Accessibility (Basic Checks)

| Check | Result | Status |
|-------|--------|--------|
| `lang` attribute on `<html>` | `en` | OK |
| Semantic landmarks (main) | 1 `<main>` element | OK |
| Navigation elements | Multiple `<nav>` elements | OK |
| Header element | Present | OK |
| Footer element | Present | OK |
| Skip navigation link | Not found | Issue |
| Images without alt text | 0 on homepage (images loaded via CSS/background) | OK |
| Buttons without accessible names | 0 | OK |
| Form inputs without labels | Some detected | Minor issue |
| Empty links (no text or aria-label) | Multiple detected | Issue |
| Heading hierarchy | Broken (empty H2, "Footer" as H2) | Issue |

### Key Accessibility Issues:
1. **No skip-navigation link.** Keyboard users must tab through the entire navigation on every page.
2. **Empty anchor tags** without text content or `aria-label` -- screen readers will announce these as unlabelled links.
3. **Broken heading hierarchy** -- empty H2 and "Footer" used as H2 disrupt document outline for assistive technology.

---

## 8. Mobile and Viewport

| Signal | Value | Status |
|--------|-------|--------|
| Viewport meta tag | `width=device-width, initial-scale=1` | OK |
| Theme colour | `#141413` (set on some pages) | OK on Next.js pages, missing on Webflow pages |
| Apple touch icon | Set (Webflow pages) | OK |
| Web app manifest | Not found | Minor -- only matters for PWA |
| Images without explicit dimensions | 0 on homepage | OK (helps CLS) |
| Responsive CSS | Webflow responsive framework | OK |

---

## 9. Internationalisation

| Signal | Value | Status |
|--------|-------|--------|
| hreflang tags | None | N/A (single-language site) |
| lang attribute | `en` | OK |
| Content language | English only | N/A |

No internationalisation issues -- the site serves English content only, which is appropriate given it's a US-based company.

---

## 10. Performance (Lab Data)

From Navigation Timing API (homepage, warm cache):

| Metric | Value | Status |
|--------|-------|--------|
| DNS lookup | 0ms (cached) | Excellent |
| TCP connection | 24ms | Excellent |
| TTFB | 60ms | Excellent |
| DOM Content Loaded | 284ms | Excellent |
| DOM Complete | 413ms | Excellent |
| Full page load | 418ms | Excellent |
| Protocol | HTTP/3 | Excellent |
| Transfer size (document) | 300 bytes (service worker) | N/A |
| Decoded body size | 296 KB | Acceptable |

**Note:** PageSpeed Insights API was unavailable (rate-limited), so Lighthouse scores could not be retrieved. Based on the lab data above, performance is strong. The site benefits from Cloudflare's edge caching and HTTP/3.

### Page Sizes
| Page | Size (raw HTML) | Assessment |
|------|-----------------|------------|
| `/` | 296 KB | Acceptable |
| `/company` | 227 KB | OK |
| `/research` | 223 KB | OK |
| `/careers` | 171 KB | Good |
| `/news` | 350 KB | Large -- likely includes article previews |
| `/learn` | 106 KB | Good |

The `/news` page at 350 KB is the heaviest. Consider pagination or lazy loading for article listings.

---

## 11. Sitemap and Crawlability

| Signal | Value | Status |
|--------|-------|--------|
| Sitemap | Single XML sitemap at /sitemap.xml | OK |
| Total URLs | 583 | Comprehensive |
| Sitemap referenced in robots.txt | Yes | OK |
| Last modification dates | Present on all entries | OK |
| Sitemap index | No (single flat file) | OK for this site size |

The sitemap is well-maintained and comprehensive. No issues detected.

---

## Priority Fixes (Ranked by Impact)

### Critical (High SEO Impact)

1. **Add canonical tags to all Next.js pages.** This affects the majority of the site (~500+ pages). Configure Next.js `<Head>` component or `next/head` to output `<link rel="canonical" href="...">` on every page.

2. **Implement structured data site-wide.** At minimum:
   - Organization schema on homepage
   - Article schema on all /news/* pages (with headline, datePublished, author, image)
   - BreadcrumbList on all interior pages
   - FAQPage on pages with FAQ sections

3. **Write unique meta descriptions for all major pages.** At least 5 pages share the same boilerplate description. Each page needs a unique 120-160 character description.

4. **Fix og:type on news articles.** Change from "website" to "article" and add `article:published_time`, `article:author` tags.

### High (Moderate SEO / Security Impact)

5. **Fix the non-www to www redirect.** Change from 302 to 301.

6. **Increase HSTS max-age** from 3600 to 31536000, add `includeSubDomains` and `preload`.

7. **Add missing security headers:** X-Content-Type-Options, Referrer-Policy, Permissions-Policy.

8. **Enforce trailing-slash consistency.** Pick one format and 301-redirect the other.

9. **Remove duplicate meta tags on homepage** (og:type, twitter:card, google-site-verification appear twice each).

10. **Improve homepage title.** Change "Home \ Anthropic" to something like "Anthropic | AI Safety and Research" or similar.

### Medium (UX / Accessibility)

11. **Add skip-navigation link** for keyboard accessibility.

12. **Fix broken heading hierarchy** -- remove empty H2, stop using headings for non-heading content like "Footer".

13. **Fix empty anchor tags** -- add aria-label or visible text to all links.

14. **Add og:url to all pages.**

15. **Fix multiple H1 tags on /product/claude-code** (9 H1s detected -- reduce to 1).

### Low (Nice to Have)

16. **Add og:site_name and og:locale** meta tags.
17. **Add twitter:image to homepage** (currently missing, though og:image may be used as fallback).
18. **Consider adding a web app manifest** for PWA support.
19. **Add theme-color meta tag to Webflow pages** (currently only on Next.js pages).
20. **Add article:section tags** to news articles for better social categorisation.

---

## Methodology

This audit was conducted using:
- Raw HTTP header inspection via `curl`
- HTML source analysis via `curl` + Python parsing
- Browser DOM analysis via Chrome DevTools Protocol (JavaScript execution)
- Navigation Timing API for performance metrics
- WebFetch for multi-page content extraction
- Manual review of robots.txt and sitemap.xml
- Cross-page comparison for duplicate content detection
- Security header analysis
- CMS/platform detection (Webflow vs Next.js markers)

Pages audited in detail: `/`, `/company`, `/research`, `/careers`, `/news`, `/learn`, `/claude/sonnet`, `/product/claude-code`, `/transparency`, `/responsible-scaling-policy`, `/news/claude-opus-4-6`, `/news/claude-sonnet-4-6`, `/news/claude-is-a-space-to-think`, `/news/core-views-on-ai-safety`.

**Limitation:** Google PageSpeed Insights API was rate-limited during this audit, so Lighthouse scores and Core Web Vitals field data from CrUX could not be retrieved. A follow-up check is recommended.
