# SEO Technical Rules

Technical SEO ensures the site is crawlable, indexable, fast, and secure. These are foundational — without them, content quality is irrelevant.

---

## Critical

### TECH-C1: robots.txt exists and returns 200
The site has a robots.txt file that returns HTTP 200. A missing or erroring robots.txt means crawlers cannot determine crawl permissions.

**Check:** `curl -sL -o /dev/null -w "%{http_code}" https://{domain}/robots.txt` returns 200.
**Evidence:** HTTP status code.

### TECH-C2: robots.txt does not block important pages
robots.txt should not Disallow paths that contain important content (/, /blog, /products, etc.). Blocking crawlers from content pages prevents indexing.

**Check:** Parse Disallow rules. Flag any that block content paths (not just /admin, /api, /wp-admin, etc.).
**Evidence:** List blocked paths and whether any are content paths.

### TECH-C3: XML sitemap exists
The site has an XML sitemap at /sitemap.xml or referenced in robots.txt. Sitemaps help crawlers discover all pages.

**Check:** Sitemap URL returns 200 and contains valid XML with `<url>` entries.
**Evidence:** Sitemap URL, HTTP status, and URL count.

### TECH-C4: All internal links return 200
Internal links should not point to 404, 301, or 500 pages. Broken links waste crawl budget and create dead ends.

**Check:** Sample internal links from crawled pages. Flag any non-200 responses.
**Evidence:** List any broken links found with their status codes.

### TECH-C5: HTTPS enabled
The site loads over HTTPS. HTTP-only sites are penalised in rankings and flagged as insecure by browsers.

**Check:** `https://{domain}` loads successfully. HTTP redirects to HTTPS.
**Evidence:** Protocol and redirect behaviour.

### TECH-C6: Mobile viewport configured
The page has `<meta name="viewport" content="width=device-width, initial-scale=1">` or similar. Without this, the page renders at desktop width on mobile.

**Check:** viewport meta tag exists with `width=device-width`.
**Evidence:** The viewport content value.

### TECH-C7: Core Web Vitals pass
Lighthouse Core Web Vitals are in the "good" range: LCP < 2.5s, CLS < 0.1, INP < 200ms.

**Check:** From Lighthouse results. If Lighthouse unavailable, mark UNTESTABLE.
**Evidence:** LCP, CLS, INP values and their status.

---

## Important

### TECH-I1: Canonical tag present
Each page has a `<link rel="canonical">` tag pointing to itself (or the preferred version). This prevents duplicate content issues.

**Check:** Canonical tag exists and its URL matches the page URL (or a valid preferred URL).
**Evidence:** Canonical URL found.

### TECH-I2: Valid sitemap XML
The sitemap is well-formed XML, uses the sitemap protocol namespace, and contains only valid URLs.

**Check:** Parse the sitemap XML. Check for well-formedness and that URLs are absolute.
**Evidence:** Any XML errors or malformed URLs.

### TECH-I3: No duplicate titles or meta descriptions
Each page should have a unique title and meta description. Duplicates signal thin or templated content to search engines.

**Check:** Compare titles and descriptions across crawled pages. Flag exact duplicates.
**Evidence:** List any duplicates found.

### TECH-I4: Page load under 3 seconds
Pages should reach interactive state in under 3 seconds. Slow pages lose rankings and users.

**Check:** From Lighthouse Time to Interactive. If unavailable, mark UNTESTABLE.
**Evidence:** TTI value in milliseconds.

---

## Nice to Have

### TECH-N1: llms.txt present
The site has an `/llms.txt` file providing guidance for AI models about the site's content and policies.

**Check:** `curl -sL -o /dev/null -w "%{http_code}" https://{domain}/llms.txt` returns 200.
**Evidence:** HTTP status and brief content summary if present.

### TECH-N2: Lighthouse performance >= 90
Lighthouse performance score is 90 or above, indicating excellent page speed.

**Check:** From Lighthouse results.
**Evidence:** Performance score.

### TECH-N3: Lighthouse accessibility >= 90
Lighthouse accessibility score is 90 or above.

**Check:** From Lighthouse results.
**Evidence:** Accessibility score.

### TECH-N4: Proper 404 page
The site returns a proper 404 status code for non-existent URLs (not a soft 404 that returns 200).

**Check:** Request a clearly non-existent URL. Verify HTTP 404 status and that the page content indicates "not found".
**Evidence:** Status code and page content summary.
