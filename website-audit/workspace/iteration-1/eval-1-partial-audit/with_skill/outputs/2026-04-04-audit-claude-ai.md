# Website Audit: claude.ai

**Date:** 2026-04-04
**Categories audited:** SEO Technical, Structured Data
**Pages crawled:** 1 (homepage only — SPA architecture limits crawlable pages)

---

## Overall Score: 65.5/100 (D)

| Category | Score | Grade |
|----------|-------|-------|
| SEO Technical | 50.0/100 | F |
| Structured Data | 86.1/100 | B+ |

> Note: Only 2 of 5 categories were audited. Weights redistributed proportionally: SEO Technical 57.1%, Structured Data 42.9%.

---

## Site Profile

| Property | Value |
|----------|-------|
| Domain | claude.ai |
| HTTPS | Yes (HTTP 301 redirects to HTTPS) |
| CMS | Custom SPA (React-based, served via Cloudflare) |
| Pages in sitemap | Unknown (sitemap blocked by Cloudflare challenge) |
| Pages crawled | 1 |
| Language | en-US |
| Character set | UTF-8 |
| Lighthouse Performance | 29/100 |
| Lighthouse Accessibility | 97/100 |
| Lighthouse Best Practices | 79/100 |
| Lighthouse SEO | 92/100 |

---

## AI Crawler Policy

| Bot | Type | Status |
|-----|------|--------|
| GPTBot | Training | Blocked |
| OAI-SearchBot | Retrieval | Blocked |
| ChatGPT-User | Retrieval | Blocked |
| ClaudeBot | Training | Not mentioned (falls back to wildcard: allowed on most paths) |
| Claude-SearchBot | Retrieval | Not mentioned (allowed) |
| Google-Extended | Training | Not mentioned (allowed) |
| GoogleOther | Training | Not mentioned (allowed) |
| Applebot-Extended | Training | Not mentioned (allowed) |
| Meta-ExternalAgent | Training | Not mentioned (allowed) |
| Bytespider | Training | Not mentioned (allowed) |
| PerplexityBot | Retrieval | Not mentioned (allowed) |
| ia_archiver | Training | Partially allowed (only / and /login, all else blocked) |
| Amazonbot | Retrieval | Not mentioned (allowed) |

**Strategy grade:** C -- Partial

The site explicitly blocks all three OpenAI bots (GPTBot, OAI-SearchBot, ChatGPT-User) but allows all other AI crawlers by default, including competing training bots like Google-Extended, Bytespider, and Meta-ExternalAgent. Notably, Anthropic's own ClaudeBot is not mentioned. The Internet Archive bot (ia_archiver) has a unique partial-allow rule. This is an inconsistent policy — it blocks one operator's bots entirely while leaving all others unrestricted.

**Recommendation:** If the intent is to block AI training while allowing retrieval for AI search visibility, extend the block to all training bots (Google-Extended, Bytespider, Meta-ExternalAgent, ClaudeBot) and explicitly allow retrieval bots (PerplexityBot, Claude-SearchBot, Amazonbot). Currently only OpenAI is blocked, which appears targeted rather than strategic.

> This section is informational. AI crawler policy does not affect the audit score.

---

## SEO Technical

### Summary

claude.ai scores poorly on technical SEO primarily because it is a Single Page Application (SPA) built as a web app, not a content website. The site has serious performance issues (Lighthouse performance: 29/100, LCP: 21.7s, TTI: 25.9s), a broken sitemap, no canonical tags, and no proper 404 handling. The foundations that work well — HTTPS, robots.txt, viewport, and accessibility — are standard. The core problem is that the entire site loads as a heavy JavaScript application even for the landing page.

### Results

| ID | Check | Severity | Result | Evidence |
|----|-------|----------|--------|----------|
| TECH-C1 | robots.txt exists and returns 200 | Critical | PASS | HTTP 200 with valid directives |
| TECH-C2 | robots.txt does not block important pages | Critical | PASS | Only app routes blocked (chat, share, settings, etc.) |
| TECH-C3 | XML sitemap exists | Critical | WARNING | Referenced in robots.txt but returns Cloudflare challenge (403) |
| TECH-C4 | All internal links return 200 | Critical | UNTESTABLE | Cloudflare bot protection blocks automated link checking |
| TECH-C5 | HTTPS enabled | Critical | PASS | HTTP 301 redirect to HTTPS confirmed |
| TECH-C6 | Mobile viewport configured | Critical | PASS | width=device-width,initial-scale=1,viewport-fit=cover |
| TECH-C7 | Core Web Vitals pass | Critical | FAIL | LCP: 21,745ms (poor), CLS: 0 (good), FID: 669ms (poor) |
| TECH-I1 | Canonical tag present | Important | FAIL | No canonical tag found on homepage |
| TECH-I2 | Valid sitemap XML | Important | FAIL | Sitemap returns Cloudflare challenge HTML, not valid XML |
| TECH-I3 | No duplicate titles or meta descriptions | Important | WARNING | Title is just "Claude" (6 chars). SPA likely shares same title across all routes |
| TECH-I4 | Page load under 3 seconds | Important | FAIL | TTI: 25,880ms (25.9 seconds) |
| TECH-N1 | llms.txt present | Nice to have | FAIL | URL returns SPA shell HTML, not a dedicated llms.txt file |
| TECH-N2 | Lighthouse performance >= 90 | Nice to have | FAIL | Performance score: 29/100 |
| TECH-N3 | Lighthouse accessibility >= 90 | Nice to have | PASS | Accessibility score: 97/100 |
| TECH-N4 | Proper 404 page | Nice to have | FAIL | Non-existent URLs return 403 (Cloudflare) or redirect to app |
| IDX-C1 | No noindex meta tag | Critical | PASS | No noindex directive found |
| IDX-C2 | No X-Robots-Tag noindex | Critical | UNTESTABLE | Cannot inspect response headers through Cloudflare challenge |
| IDX-C3 | No soft 404s | Critical | WARNING | Homepage has minimal content (app UI only). Search engines may treat thin SPA shell as soft 404 |
| IDX-I1 | Canonical self-referencing | Important | FAIL | No canonical tag present |
| IDX-I2 | Canonical target returns 200 | Important | N/A | No canonical tag to check |
| IDX-I3 | Sitemap URLs return 200 | Important | FAIL | Sitemap not accessible; cannot verify URLs |

### Fixes

- **TECH-C7: Core Web Vitals pass**
  Current: LCP 21,745ms, FID 669ms
  Fix: Implement server-side rendering for the landing page. Code-split the app so the full chat application does not load on the initial page view. Defer non-critical JavaScript. Target LCP < 2,500ms and FID < 100ms.
  Impact: Critical

- **TECH-I1: Canonical tag present**
  Current: No canonical tag on any page
  Fix: Add `<link rel="canonical" href="https://claude.ai/">` to the homepage. Implement dynamic canonical tags for each public-facing route.
  Impact: Important

- **TECH-I2: Valid sitemap XML**
  Current: Returns Cloudflare challenge page
  Fix: Serve sitemap.xml as a static file that bypasses Cloudflare challenge. List all publicly accessible pages with proper `<lastmod>` dates.
  Impact: Important

- **TECH-I4: Page load under 3 seconds**
  Current: TTI 25,880ms
  Fix: The same JavaScript optimisation that fixes LCP will fix TTI. Consider a lightweight landing page that loads in under 3 seconds, with the full app loading on user interaction.
  Impact: Important

- **TECH-C3: XML sitemap exists (accessible)**
  Current: Sitemap referenced in robots.txt but blocked by Cloudflare
  Fix: Whitelist /sitemap.xml from Cloudflare's bot challenge, or serve it from a CDN edge as a static file.
  Impact: Critical

- **TECH-I3: No duplicate titles or meta descriptions**
  Current: Title is "Claude" (6 characters)
  Fix: Use a descriptive title like "Claude - AI Assistant by Anthropic" (35 chars). Implement dynamic titles per route.
  Impact: Important

- **IDX-C3: No soft 404s**
  Current: Homepage serves minimal HTML shell with no meaningful text content for crawlers
  Fix: Add server-side rendered content to the landing page HTML that describes Claude, its features, and use cases. This gives search engines substantive content to index.
  Impact: Critical

- **IDX-I1: Canonical self-referencing**
  Current: No canonical tag
  Fix: Same as TECH-I1 — add canonical tags.
  Impact: Important

- **IDX-I3: Sitemap URLs return 200**
  Current: Sitemap inaccessible
  Fix: Same as TECH-I2/TECH-C3 — fix sitemap accessibility first.
  Impact: Important

- **TECH-N1: llms.txt present**
  Current: SPA catches all routes; /llms.txt serves app HTML
  Fix: Create a static /llms.txt file served at the CDN/server level, bypassing the SPA router. Include site description, usage policies, and content guidance for AI models.
  Impact: Nice to have

- **TECH-N2: Lighthouse performance >= 90**
  Current: 29/100
  Fix: Addressed by Core Web Vitals fixes above.
  Impact: Nice to have

- **TECH-N4: Proper 404 page**
  Current: Returns 403 (Cloudflare) or redirects to app
  Fix: Configure server to return HTTP 404 with a custom error page for unknown routes. This helps search engines identify dead pages.
  Impact: Nice to have

---

## Structured Data

### Summary

claude.ai has solid structured data foundations. The homepage includes a well-formed JSON-LD block using an @graph pattern with both WebSite and Organization schemas. Social profiles are linked via sameAs. The main gaps are missing recommended fields (description, contactPoint) and a potential inconsistency where the WebSite url points to claude.com rather than claude.ai. No deprecated schema types were found.

### Results

| ID | Check | Severity | Result | Evidence |
|----|-------|----------|--------|----------|
| SD-C1 | JSON-LD present on every page | Critical | PASS | 1 JSON-LD block with @graph containing 2 types |
| SD-C2 | Valid JSON | Critical | PASS | Parses successfully, no errors |
| SD-C3 | @type matches page content | Critical | PASS | WebSite + Organization appropriate for app homepage |
| SD-C4 | Author fields use Person or Organization | Critical | N/A | No author fields needed for these schema types |
| SD-C5 | Required fields present per schema type | Critical | WARNING | All required fields present but WebSite url points to claude.com, not claude.ai |
| SD-I1 | Organization or LocalBusiness on homepage | Important | PASS | Organization with name, url, logo, sameAs |
| SD-I2 | BreadcrumbList on non-homepage pages | Important | N/A | No crawlable non-homepage pages (SPA) |
| SD-I3 | Article schema on blog/article pages | Important | N/A | No blog/article pages on claude.ai |
| SD-I4 | FAQPage schema where FAQ exists | Important | N/A | No FAQ content on claude.ai |
| SD-I5 | Recommended fields present | Important | WARNING | ~50% coverage. Missing: WebSite description, publisher. Missing: Organization description, contactPoint |
| SD-N1 | Product schema on product pages | Nice to have | N/A | No product pages |
| SD-N2 | Combined schema types | Nice to have | PASS | 2 schema types via @graph pattern |
| SD-N3 | sameAs social links | Nice to have | PASS | 3 social profiles: X, LinkedIn, YouTube |

**Schema deprecation check:** No deprecated or restricted types found. Types present: WebSite, Organization.

### Fixes

- **SD-C5: Required fields present per schema type**
  Current: WebSite url is "https://claude.com" (not "https://claude.ai")
  Fix: If claude.com is the canonical domain and redirects to claude.ai, this is acceptable. Otherwise, update the url to "https://claude.ai" for consistency with the actual domain being served.
  Impact: Critical

- **SD-I5: Recommended fields present**
  Current: Missing description on both WebSite and Organization schemas. Missing contactPoint and publisher.
  Fix: Add `"description": "Claude is an AI assistant built by Anthropic..."` to WebSite. Add `"description"` and `"contactPoint"` to Organization. Add `"publisher"` referencing the Organization to WebSite.
  Impact: Important

---

## Lighthouse Results

| Metric | Score |
|--------|-------|
| Performance | 29 |
| Accessibility | 97 |
| Best Practices | 79 |
| SEO | 92 |

### Core Web Vitals

| Metric | Value | Status |
|--------|-------|--------|
| LCP | 21,745ms | Poor (threshold: <2,500ms) |
| CLS | 0 | Good (threshold: <0.1) |
| FID (Max Potential) | 669ms | Poor (threshold: <100ms) |
| TTFB | 32ms | Good |
| TTI | 25,880ms | Poor (threshold: <3,000ms) |

---

## Perplexity Citation Check

Perplexity citation check requires PERPLEXITY_API_KEY. Marked as UNTESTABLE.

---

## Priority Fix List

Ordered by impact (Critical FAILs first, then Critical WARNINGs, then Important FAILs, etc.)

### Critical

1. **[TECH-C7] Core Web Vitals fail** -- LCP is 21.7s and FID is 669ms. Implement server-side rendering for the landing page, code-split the JavaScript bundle, and defer non-critical scripts. This single change would also fix TECH-I4, TECH-N2.
2. **[TECH-C3] Sitemap blocked by Cloudflare** -- Whitelist /sitemap.xml from Cloudflare's bot challenge or serve it as a static edge file. This also fixes TECH-I2 and IDX-I3.
3. **[IDX-C3] Thin content / potential soft 404** -- Add server-rendered content to the landing page HTML describing Claude, its capabilities, and use cases. Search engines need indexable text, not just a JavaScript app shell.

### Important

4. **[TECH-I1 / IDX-I1] No canonical tag** -- Add `<link rel="canonical">` to all public-facing pages. Start with the homepage.
5. **[TECH-I3] Generic title** -- Change the page title from "Claude" to something descriptive like "Claude - AI Assistant by Anthropic". Implement per-route dynamic titles.
6. **[SD-I5] Missing recommended schema fields** -- Add description to WebSite and Organization schemas. Add contactPoint to Organization. Add publisher to WebSite.
7. **[TECH-I4] TTI exceeds 3 seconds** -- Addressed by the same optimisations as TECH-C7.

### Nice to Have

8. **[TECH-N1] No llms.txt** -- Create a static /llms.txt file served outside the SPA. Especially relevant given this is an AI product site.
9. **[TECH-N4] No proper 404 page** -- Return HTTP 404 for unknown routes instead of 403 or app redirect.
10. **[TECH-N2] Low Lighthouse performance** -- Addressed by TECH-C7 fixes.
11. **[SD-C5] WebSite url mismatch** -- Verify claude.com redirects to claude.ai. If not the canonical domain, update the structured data url field.
