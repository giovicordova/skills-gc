# SEO On-Page Rules

On-page SEO evaluates how well individual pages are optimised for search engines through content structure, metadata, and link quality.

---

## Critical

### PAGE-C1: One H1 per page
Each page should have exactly one `<h1>` element. Zero H1s means missing primary heading; multiple H1s dilute the page's topic signal.

**Check:** Count H1 elements on each crawled page.
**Evidence:** H1 count and text for each page.

### PAGE-C2: Title tag 50-60 characters
Title tags should be 50-60 characters. Under 50 wastes ranking potential; over 60 gets truncated in search results.

**Check:** Measure title tag length for each page.
**Evidence:** Title text and character count.

### PAGE-C3: Unique title tags
Every page should have a unique title. Duplicate titles indicate duplicate or thin content.

**Check:** Compare titles across all crawled pages.
**Evidence:** List any duplicates.

### PAGE-C4: Meta description 150-160 characters
Meta descriptions should be 150-160 characters. This is the text shown in search results — it needs to be a compelling summary.

**Check:** Measure meta description length for each page.
**Evidence:** Description text and character count.

### PAGE-C5: Unique meta descriptions
Every page should have a unique meta description. Duplicates or missing descriptions mean Google generates its own (often poorly).

**Check:** Compare descriptions across crawled pages. Flag missing or duplicate descriptions.
**Evidence:** List missing or duplicate descriptions.

---

## Important

### PAGE-I1: Correct heading hierarchy
Headings follow a logical hierarchy: H1 > H2 > H3 etc. No skipping levels (e.g., H1 followed directly by H4). This helps both screen readers and search engines understand content structure.

**Check:** Verify heading hierarchy on each page. Flag any level skips.
**Evidence:** Heading structure found.

### PAGE-I2: Descriptive alt text on images
Images have `alt` attributes with descriptive text (not empty, not "image", not the filename). Alt text is used by screen readers and image search.

**Check:** Check all `<img>` elements for alt attributes. Flag missing, empty, or non-descriptive alts.
**Evidence:** Count of images with/without alt, and examples of poor alt text.

### PAGE-I3: All pages reachable within 3 clicks
Important pages should be reachable within 3 clicks from the homepage. Deep pages are crawled less frequently and carry less link equity.

**Check:** Using the link graph from crawled pages, estimate click depth for each URL.
**Evidence:** Maximum click depth found and any deep pages.

### PAGE-I4: Clean, descriptive URLs
URLs are human-readable, use hyphens, and describe the page content. No random IDs, excessive parameters, or meaningless strings.

**Check:** Review URL patterns across crawled pages. Flag URLs with random strings, excessive parameters, or non-descriptive slugs.
**Evidence:** Examples of clean and problematic URLs.

---

## Nice to Have

### PAGE-N1: No orphan pages
Every page in the sitemap is linked from at least one other internal page. Orphan pages (in sitemap but not linked) are a signal of poor site structure.

**Check:** Compare sitemap URLs with the internal link graph. Flag any sitemap URLs not found in internal links.
**Evidence:** List orphan pages.

### PAGE-N2: External links have noopener
All external links include `rel="noopener"` (or `rel="noreferrer noopener"`). This is a security best practice.

**Check:** Check `rel` attribute on external links.
**Evidence:** Count and examples of links missing noopener.

### PAGE-N3: URL length under 75 characters
URLs should be under 75 characters for readability and to avoid truncation in SERPs.

**Check:** Measure URL path length for crawled pages.
**Evidence:** Any URLs exceeding 75 characters.
