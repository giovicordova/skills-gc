# SEO Technical & Structured Data Audit: claude.ai

**Audit date:** 4 April 2026
**Auditor:** Claude Opus 4.6 (without skill)
**Scope:** SEO technical + structured data only
**Domains audited:** claude.ai (primary app) and claude.com (marketing site, same product)

---

## Executive Summary

claude.ai operates as a JavaScript single-page application (SPA) behind Cloudflare protection. It shares the Claude product with claude.com, which is a Next.js-based marketing and content site. The two domains serve different purposes but have overlapping SEO concerns. The structured data implementation is minimal but present on both. Several significant technical SEO gaps exist, particularly on claude.ai.

**Critical issues found:** 7
**Warnings:** 9
**Passes:** 10

---

## 1. SEO Technical Audit

### 1.1 Crawlability & Indexability

| Check | claude.ai | claude.com | Verdict |
|-------|-----------|------------|---------|
| robots.txt | Present | Present | PASS |
| Sitemap declared in robots.txt | Yes (`sitemap.xml`) | Yes (`sitemap.xml`) | PASS |
| Sitemap accessible to bots | BLOCKED by Cloudflare challenge (403) | Accessible (200) | CRITICAL (claude.ai) |
| Sitemap format | Sitemap index (7 child sitemaps for artifacts) | Single sitemap with xhtml:link hreflang | PASS |
| Meta robots tag | Not set (defaults to index,follow) | Not set (defaults to index,follow) | PASS |
| Googlebot meta | Not set | Not set | OK |

**CRITICAL -- Cloudflare blocks bot access to claude.ai:** Curl requests (including Googlebot UA) receive a 403 Cloudflare challenge page. The challenge page contains `<meta name="robots" content="noindex,nofollow">`, which means search engine crawlers may index this challenge page's noindex directive instead of the actual content. The sitemap.xml declared in robots.txt is unreachable by bots.

**robots.txt analysis (claude.ai):**
- Explicitly blocks `ia_archiver`, `GPTBot`, `OAI-SearchBot`, `ChatGPT-User` from all paths except `/` and `/login`
- For all other bots (`User-Agent: *`), blocks: `/new`, `/chat/*`, `/share/*`, `/magic-link*`, `/api/*`, `/onboarding*`, `/upgrade*`, `/lti/*`, `/settings*`, `/task*`
- Allows crawling of `/` (homepage) and `/login` and artifact pages

**robots.txt analysis (claude.com):**
- Permissive: `Allow: /` for all user agents
- 937 unique English URLs + 4 locale variants (ja-JP, de-DE, fr-FR, ko-KR) = ~2,324 total URLs in sitemap

### 1.2 URL Architecture & Redirects

| Check | Result | Verdict |
|-------|--------|---------|
| HTTP to HTTPS redirect | `http://claude.ai` --> 301 --> `https://claude.ai/` | PASS |
| www to non-www redirect | `https://www.claude.ai` --> 301 --> `https://claude.ai/` | PASS |
| claude.com relationship | Separate domain (200), not a redirect to claude.ai | WARNING |
| Trailing slash consistency | `/login/` returns 403 (Cloudflare challenge) | INCONCLUSIVE |
| Authenticated redirect | `https://claude.ai/` --> `/new` for logged-in users | OK (expected for app) |
| Protocol | HTTP/3 (h3) via Cloudflare | PASS |

**WARNING -- claude.ai vs claude.com domain split:** The structured data on both domains declares `"url": "https://claude.com"` as the canonical WebSite URL, yet claude.ai is the app domain. claude.com is a Next.js marketing site with blog, solutions pages, and pricing. When a logged-in user visits claude.com, they get redirected back to claude.ai. This creates a confusing two-domain architecture. Google may struggle to understand which domain is authoritative.

### 1.3 Canonical Tags

| Page | Canonical | Verdict |
|------|-----------|---------|
| claude.ai/new (app) | **MISSING** | CRITICAL |
| claude.ai/login | **MISSING** | CRITICAL |
| claude.com (homepage) | `https://claude.com` | PASS |

**CRITICAL -- No canonical tag on claude.ai pages.** Without canonical tags, search engines must guess the preferred URL. The `/new` redirect from `/` compounds this: Google may index both `/` and `/new` as separate pages.

### 1.4 Title Tags

| Page | Title | Length | Verdict |
|------|-------|--------|---------|
| claude.ai (all pages) | "Claude" | 6 chars | WARNING |
| claude.com (homepage) | "Claude" | 6 chars | WARNING |

**WARNING -- Title tag is too generic.** "Claude" alone provides no keyword context. Competitors like ChatGPT use titles such as "ChatGPT - AI Assistant" or similar descriptive titles. The title should include at minimum a descriptor (e.g., "Claude - AI Assistant by Anthropic").

### 1.5 Meta Description

| Page | Description | Length | Verdict |
|------|-------------|--------|---------|
| Both domains | "Claude is Anthropic's AI, built for problem solvers. Tackle complex challenges, analyze data, write code, and think through your hardest work." | 143 chars | PASS |

The meta description is well-written and within the recommended 150-160 character range. Present on both domains.

### 1.6 Heading Structure

| Check | claude.ai/new | Verdict |
|-------|---------------|---------|
| H1 count | 0 | CRITICAL |
| H2 tags | "Starred", "RecentsHide" (UI labels, not content) | WARNING |
| H3 tags | 0 | -- |

**CRITICAL -- No H1 tag on the page.** The primary heading is entirely absent. Even for an app page, the homepage (which is allowed for crawling in robots.txt) should have a semantic H1.

### 1.7 Open Graph Tags

| Property | claude.ai | claude.com | Verdict |
|----------|-----------|------------|---------|
| og:title | **MISSING** | "Claude" | CRITICAL (claude.ai) |
| og:description | **MISSING** | Present | CRITICAL (claude.ai) |
| og:url | **MISSING** | Not found in HTML | WARNING |
| og:image | `https://claude.ai/images/claude_ogimage.png` | Same | PASS |
| og:image:width | 1200 | 1200 | PASS |
| og:image:height | 630 | 630 | PASS |
| og:type | "website" | "website" | PASS |
| og:site_name | "Claude" | "Claude" | PASS |

**CRITICAL -- claude.ai is missing og:title, og:description, and og:url.** When someone shares a claude.ai link on social media or messaging platforms, the preview will be incomplete. claude.com has these filled in properly.

### 1.8 Twitter Card Tags

| Property | claude.ai | claude.com | Verdict |
|----------|-----------|------------|---------|
| twitter:card | "summary_large_image" | "summary_large_image" | PASS |
| twitter:title | **MISSING** | "Claude" | CRITICAL (claude.ai) |
| twitter:description | **MISSING** | Present | CRITICAL (claude.ai) |
| twitter:image | **MISSING** | `https://claude.ai/images/claude_ogimage.png` | WARNING (claude.ai) |
| twitter:site | **MISSING** | **MISSING** | WARNING |

**CRITICAL -- Twitter Card tags incomplete on claude.ai.** Same gap as OG tags. Additionally, neither domain declares `twitter:site` (should be `@AnthropicAI`).

### 1.9 Internationalisation (hreflang)

| Check | claude.ai | claude.com | Verdict |
|-------|-----------|------------|---------|
| hreflang link tags | None | Not in HTML head (in sitemap only) | WARNING |
| Sitemap hreflang | Not applicable (artifact-only sitemap) | Present for 5 locales (en-US, ja-JP, de-DE, fr-FR, ko-KR) with x-default | PASS (claude.com) |
| html lang attribute | `en-US` | `en-US` | PASS |

**WARNING -- claude.ai has no hreflang implementation.** If claude.ai serves users in multiple languages or regions, there is no hreflang signal to search engines.

### 1.10 Rendering & JavaScript Dependency

| Check | Result | Verdict |
|-------|--------|---------|
| Rendering method | Client-side SPA (`<div id="root">`) | WARNING |
| Framework | React (Vite bundled, not Next.js) | -- |
| SSR/Prerendering | **None detected** | WARNING |
| __NEXT_DATA__ | Not present | -- |
| claude.com rendering | Next.js with SSR (RSC payload visible) | PASS |
| Noscript fallback | None on claude.ai | WARNING |

**WARNING -- claude.ai is fully client-side rendered.** The HTML served to crawlers contains only an empty `<div id="root"></div>` plus meta tags in the `<head>`. All page content depends on JavaScript execution. While Googlebot can render JavaScript, there are risks:
- Rendering delays affect crawl budget
- Other search engines (Bing, DuckDuckGo) may not render JS as effectively
- Social media crawlers (Facebook, Twitter, LinkedIn) do NOT execute JavaScript

The `<head>` meta tags (description, OG) are server-rendered in the initial HTML, which mitigates the social sharing issue somewhat for claude.com (which has complete OG tags). But claude.ai's missing OG tags mean even the head-rendered fallback is incomplete.

### 1.11 Performance & Technical Signals

| Metric | Value | Verdict |
|--------|-------|---------|
| TTFB | ~30ms | PASS |
| DOM Content Loaded | ~406ms | PASS |
| Full page load | ~1,452ms | PASS |
| Total transfer size | ~115 KB (resources) | PASS |
| Total DOM nodes | 496 | PASS (well under 1,500 guideline) |
| HTTP protocol | HTTP/3 (h3) via Cloudflare | PASS |
| Render-blocking resources | 1 CSS file | PASS |
| Total resources loaded | 51 | OK |

### 1.12 Security Headers (SEO-Adjacent)

| Header | Value | Verdict |
|--------|-------|---------|
| HTTPS | Yes (enforced via 301 redirect) | PASS |
| HSTS | **Not detected** | WARNING |
| X-Frame-Options | SAMEORIGIN | PASS |
| X-Content-Type-Options | nosniff | PASS |
| Referrer-Policy | same-origin | PASS |
| Permissions-Policy | Restrictive (good) | PASS |
| Cross-Origin-Embedder-Policy | require-corp | PASS |
| Cross-Origin-Opener-Policy | same-origin | PASS |

**WARNING -- No HSTS header detected.** While HTTPS is enforced via redirect, HSTS (Strict-Transport-Security) adds a layer of protection and is a minor positive signal.

### 1.13 Images & Accessibility

| Check | Result | Verdict |
|-------|--------|---------|
| Total images on /new | 0 (app uses SVG icons inline) | N/A |
| Images without alt text | N/A | N/A |
| OG image accessible | `https://claude.ai/images/claude_ogimage.png` (1200x630) | PASS |
| Favicon | SVG + PNG 32x32 + PNG 16x16 | PASS |
| Apple touch icon | Present | PASS |
| Web app manifest | Present and valid | PASS |

### 1.14 Web App Manifest

| Property | Value | Verdict |
|----------|-------|---------|
| name | "Claude" | PASS |
| short_name | "Claude" | PASS |
| display | "standalone" | PASS |
| start_url | "/" | PASS |
| icons | 512x512 PNG | WARNING -- only 1 size |
| theme_color | Not set | WARNING |
| description | Not set | WARNING |

**WARNING -- Manifest is minimal.** Missing `theme_color`, `description`, and only one icon size (512x512). Should include at least 192x192 and 512x512, plus a maskable icon.

### 1.15 ARIA & Accessibility (SEO-Adjacent)

| Landmark | Count | Verdict |
|----------|-------|---------|
| main | 1 | PASS |
| nav | 1 | PASS |
| banner/header | 0 | WARNING |
| contentinfo/footer | 0 | WARNING |
| search role | 0 | WARNING |

---

## 2. Structured Data Audit

### 2.1 Current Implementation

Both claude.ai and claude.com serve identical JSON-LD structured data:

```json
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "WebSite",
      "name": "Claude",
      "alternateName": ["Claude.ai", "Claude by Anthropic"],
      "url": "https://claude.com"
    },
    {
      "@type": "Organization",
      "name": "Anthropic",
      "url": "https://www.anthropic.com",
      "logo": "https://claude.ai/images/claude_ogimage.png",
      "sameAs": [
        "https://x.com/AnthropicAI",
        "https://www.linkedin.com/company/anthropic",
        "https://www.youtube.com/@anthropic-ai"
      ]
    }
  ]
}
```

### 2.2 Structured Data Assessment

| Check | Status | Verdict |
|-------|--------|---------|
| Valid JSON-LD syntax | Yes | PASS |
| @context present | Yes (schema.org) | PASS |
| Uses @graph (multi-entity) | Yes | PASS |
| WebSite type | Present | PASS |
| WebSite.url points to claude.com | Intentional but questionable from claude.ai | WARNING |
| Organization type | Present | PASS |
| Organization.logo format | Uses OG image URL, not a dedicated logo | WARNING |
| sameAs links | 3 social profiles | PASS |
| SearchAction (sitelinks search) | **MISSING** | WARNING |
| SoftwareApplication type | **MISSING** | WARNING |
| BreadcrumbList | **MISSING** | N/A for SPA |
| FAQPage | **MISSING** | N/A |
| Article (blog posts on claude.com) | **Not checked** (requires per-page audit) | -- |

### 2.3 Structured Data Issues

**WARNING -- WebSite.url mismatch on claude.ai:** The structured data declares `"url": "https://claude.com"` on both domains. While this is presumably intentional (claude.com is the canonical marketing site), having claude.ai serve structured data pointing to a different domain is unusual and may confuse search engines about domain authority.

**WARNING -- Organization.logo uses OG image, not actual logo:** The `logo` property uses `claude_ogimage.png` which is a 1200x630 social sharing image. Schema.org recommends the logo be a recognisable brand mark, ideally 112x112px minimum, rectangular, and not a promotional image. Should use the actual Anthropic or Claude logo.

**WARNING -- No SearchAction schema:** For a major web app, implementing `SearchAction` within the WebSite schema can enable sitelinks search box in Google results. This is a missed opportunity.

**WARNING -- No SoftwareApplication schema:** Claude is a software product. Adding `SoftwareApplication` or `WebApplication` schema would provide Google with richer signals about the product (pricing tiers, operating system, category, rating).

### 2.4 Missing Structured Data Opportunities

| Schema Type | Applicability | Priority |
|-------------|---------------|----------|
| `WebApplication` / `SoftwareApplication` | Describe Claude as a product with pricing, features, platform support | HIGH |
| `SearchAction` | Enable sitelinks search box in Google SERPs | MEDIUM |
| `Article` / `BlogPosting` | For claude.com/blog/* pages | HIGH |
| `HowTo` | For tutorial/guide content on claude.com | MEDIUM |
| `BreadcrumbList` | For claude.com hierarchical pages (solutions, blog categories) | MEDIUM |
| `VideoObject` | If video content exists on pages | LOW |
| `Product` (with offers) | For pricing pages | MEDIUM |
| `FAQPage` | If FAQ content exists | LOW |

---

## 3. Summary of Findings

### Critical Issues (7)

| # | Issue | Domain | Impact |
|---|-------|--------|--------|
| 1 | Cloudflare blocks bot access -- crawlers get 403 challenge page with noindex | claude.ai | Crawlers cannot access the site at all |
| 2 | No canonical tags on any page | claude.ai | Duplicate content / URL confusion risk |
| 3 | No H1 heading tag | claude.ai | Missing primary content signal |
| 4 | og:title missing | claude.ai | Broken social sharing previews |
| 5 | og:description missing | claude.ai | Broken social sharing previews |
| 6 | twitter:title missing | claude.ai | Broken Twitter/X card previews |
| 7 | twitter:description missing | claude.ai | Broken Twitter/X card previews |

### Warnings (9)

| # | Issue | Domain | Impact |
|---|-------|--------|--------|
| 1 | Title tag too generic ("Claude" only -- 6 chars) | Both | Missed keyword opportunity |
| 2 | No HSTS header | claude.ai | Minor security/SEO signal gap |
| 3 | No hreflang on claude.ai | claude.ai | Internationalisation gap |
| 4 | Client-side rendering only (SPA with no SSR) | claude.ai | JS rendering risk for non-Google crawlers |
| 5 | Two-domain architecture (claude.ai + claude.com) with unclear authority signal | Both | Domain authority dilution |
| 6 | WebSite structured data URL mismatch (claude.com URL on claude.ai domain) | claude.ai | Confusing domain signals |
| 7 | Organization.logo uses OG image instead of actual logo | Both | Incorrect schema markup |
| 8 | No SearchAction or SoftwareApplication schema | Both | Missed SERP feature opportunities |
| 9 | Minimal web app manifest (missing theme_color, description, multiple icon sizes) | claude.ai | PWA/app discovery gap |

### Passes (10)

| # | Check | Notes |
|---|-------|-------|
| 1 | robots.txt present and correctly configured | Both domains |
| 2 | HTTP to HTTPS redirect (301) | Correct |
| 3 | www to non-www redirect (301) | Correct |
| 4 | Meta description present and well-written | 143 chars, good quality |
| 5 | OG image present with correct dimensions | 1200x630 |
| 6 | HTTP/3 protocol | Via Cloudflare |
| 7 | Fast TTFB (~30ms) and page load (~1.4s) | Good performance |
| 8 | Low DOM node count (496) | Well under guidelines |
| 9 | Valid JSON-LD structured data with @graph | Correct syntax |
| 10 | claude.com sitemap with full hreflang for 5 locales | Proper implementation |

---

## 4. Priority Recommendations

### P0 -- Immediate (Critical)

1. **Fix Cloudflare bot access on claude.ai.** Ensure Googlebot, Bingbot, and other legitimate crawlers can access at minimum the homepage, `/login`, and sitemap.xml without being challenged. Cloudflare can be configured to allow verified bot traffic.

2. **Add canonical tags to all claude.ai pages.** At minimum, the homepage (`/` or `/new`) and `/login` need `<link rel="canonical">`. Decide whether the canonical should point to claude.ai or claude.com.

3. **Add complete OG and Twitter Card tags to claude.ai.** Add `og:title`, `og:description`, `og:url`, `twitter:title`, `twitter:description`, `twitter:image`, and `twitter:site` to the `<head>` of claude.ai. These are already present on claude.com -- mirror them.

### P1 -- High Priority

4. **Add an H1 tag to the claude.ai homepage.** Even if visually hidden, include a semantic `<h1>` for accessibility and SEO.

5. **Improve the title tag.** Change from "Claude" to something like "Claude | AI Assistant by Anthropic" on both domains (adapting per page where relevant).

6. **Add SoftwareApplication / WebApplication structured data.** Describe Claude as a web application with pricing, platform, and category information.

7. **Resolve the dual-domain strategy.** Decide explicitly whether claude.ai or claude.com is the primary SEO target. Use canonical tags and redirects to enforce this consistently. Currently the structured data points to claude.com, but claude.ai is the app.

### P2 -- Medium Priority

8. **Add SearchAction to WebSite structured data** to enable sitelinks search box.

9. **Fix Organization.logo** to use the actual Anthropic/Claude logomark rather than the OG sharing image.

10. **Add HSTS header** to claude.ai responses.

11. **Consider SSR or prerendering for claude.ai** public pages (homepage, login) to ensure all crawlers and social media bots see content.

12. **Enhance the web app manifest** with theme_color, description, and multiple icon sizes.

---

*Audit performed using browser automation (Playwright MCP via Chrome), curl HTTP requests, and direct HTML source analysis. claude.ai was audited in an authenticated session due to Cloudflare blocking unauthenticated access. claude.com was audited via both curl and authenticated browser.*
