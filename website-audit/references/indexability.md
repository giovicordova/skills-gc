# Indexability Rules

These checks detect common reasons Google Search Console reports "not indexed". Only 4 of the 16 GSC exclusion reasons are observable from a crawl — the rest require server-side access.

---

## Critical

### IDX-C1: No noindex meta tag
Pages should not have `<meta name="robots" content="noindex">` unless intentionally excluded from search. A noindex tag prevents the page from appearing in any search results.

**Check:** Inspect the `robots` meta tag on each crawled page. Flag any content-containing page with `noindex`.
**Evidence:** Pages with noindex and whether they appear to be content pages.

### IDX-C2: No X-Robots-Tag noindex
The HTTP response should not include an `X-Robots-Tag: noindex` header. This has the same effect as the meta tag but is invisible in the HTML.

**Check:** Check HTTP response headers for X-Robots-Tag. This requires inspecting the fetch response, not just the page content.
**Evidence:** X-Robots-Tag header values found.

### IDX-C3: No soft 404s
Pages should return proper HTTP status codes. A "soft 404" returns HTTP 200 but displays error/empty content. Google detects these and excludes them.

**Check:** For each crawled page, verify the page has substantial content (>100 words). Flag pages that return 200 but have very little content or display "not found" / "page doesn't exist" type messages.
**Evidence:** Pages with low content or error-like text despite 200 status.

---

## Important

### IDX-I1: Canonical self-referencing
Each page's canonical tag should point to itself (unless it's intentionally a duplicate pointing to a canonical version). Non-self-referencing canonicals tell Google "don't index this, index that instead".

**Check:** Compare canonical URL with the page URL on each page.
**Evidence:** Pages where canonical differs from the actual URL.

### IDX-I2: Canonical target returns 200
If a page has a canonical tag pointing to another URL, that target URL should return HTTP 200. Broken canonicals create indexing limbo.

**Check:** For non-self-referencing canonicals, verify the target URL returns 200.
**Evidence:** Canonical targets and their status codes.

### IDX-I3: Sitemap URLs return 200
Every URL listed in the sitemap should return HTTP 200. Sitemaps with broken URLs waste crawl budget and signal poor site maintenance.

**Check:** Sample sitemap URLs and verify their HTTP status.
**Evidence:** Any non-200 sitemap URLs.
