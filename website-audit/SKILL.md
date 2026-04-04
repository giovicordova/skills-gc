---
name: website-audit
description: "Audits any website for SEO, AEO (Answer Engine Optimization), GEO (Generative Engine Optimization), and Structured Data. Crawls with Playwright, runs Lighthouse, checks Perplexity citations, applies research-backed rules, scores deterministically, and produces a prioritised fix list. Use this skill when the user wants to audit a website, check SEO, evaluate a site's AI-readiness, compare two sites, review structured data, check schema markup, assess content for answer engines, or anything related to website quality analysis. Trigger: /website-audit [domain] [categories...]"
disable-model-invocation: true
context: fork
allowed-tools:
  - Read
  - Bash
  - Write
  - Glob
  - Grep
  - Agent(lighthouse-runner)
  - Agent(perplexity-checker)
  - mcp__plugin_playwright_playwright__browser_navigate
  - mcp__plugin_playwright_playwright__browser_evaluate
  - mcp__plugin_playwright_playwright__browser_run_code
---

# Website Audit

Audit any website across 5 categories: **AEO**, **GEO**, **SEO Technical**, **SEO On-Page**, and **Structured Data**. Produces a scored, prioritised report with actionable fixes.

## Arguments

```
/website-audit <domain> [categories...] [+refresh] [comparison-domain]
```

- **domain** (required): The site to audit (e.g. `example.com`)
- **categories** (optional): Subset of `aeo`, `geo`, `seo-technical`, `seo-on-page`, `structured-data`. Omit to audit all 5.
- **+refresh**: Force-refresh reference files even if <30 days old.
- **comparison-domain**: If a second domain is provided, run comparison mode.

## Dependencies

Before starting, verify these are available. If any are missing, tell the user what to install and stop.

- Node.js 22+ (`node --version`)
- Playwright CLI (`npx playwright --version`) — if missing: `npx playwright install chromium`
- Python 3 (`python3 --version`)
- Lighthouse (`lighthouse --version`) — if missing: `npm install -g lighthouse`
- jq (`jq --version`)
- Optional: `PERPLEXITY_API_KEY` env var for citation checking

---

## Audit Flow

Work through these phases in order. Each phase builds on the previous one's data.

### Phase 0: Setup

1. **Parse arguments.** Extract domain(s) and requested categories. Default to all 5 categories.
2. **Check dependencies.** Run the version commands above. Stop on failure.
3. **Comparison mode?** If two domains provided, set `COMPARISON_MODE=true`. You will run the full audit on each domain, then produce a comparison report instead of two separate ones.
4. **Reference freshness.** Check if any file in `references/` is >30 days old (use file modification time). If so, or if `+refresh` was requested, read `references/refresh-guide.md` and follow its instructions to update stale files. If all files are fresh and no `+refresh`, skip this.

### Phase A: Crawl Technical Files + Homepage

Run these four tasks in parallel:

1. **robots.txt + sitemap.xml** — Fetch via curl:
   ```bash
   curl -sL "https://{domain}/robots.txt" -o /tmp/audit-robots.txt
   curl -sL "https://{domain}/sitemap.xml" -o /tmp/audit-sitemap.xml
   ```
   Parse robots.txt for Disallow rules and AI bot directives. Parse sitemap for URL list.

2. **Lighthouse** — Spawn a background subagent:
   ```
   Agent(lighthouse-runner):
     model: haiku
     prompt: |
       Run Lighthouse audit on https://{domain} using the script at
       {skill_path}/scripts/lighthouse.sh
       Save the JSON output to /tmp/audit-lighthouse-{domain}.json
       Extract and return: performance score, accessibility score,
       best-practices score, SEO score, and Core Web Vitals (LCP, FID, CLS).
   ```

3. **Perplexity citation check** — Spawn a background subagent (skip if no `PERPLEXITY_API_KEY`):
   ```
   Agent(perplexity-checker):
     model: haiku
     prompt: |
       Check if {domain} is cited by Perplexity AI using the script at
       {skill_path}/scripts/perplexity-check.sh
       Domain: {domain}
       Generate 5 queries likely to surface this domain based on its content.
       Save results to /tmp/audit-perplexity-{domain}.json
       Return: number of queries tested, number with citations, citation details.
   ```

4. **Homepage crawl** — Use Playwright to navigate to `https://{domain}` and run the extraction function from `modules/extraction.js`. This captures 20+ signals per page (headings, meta tags, structured data, links, content metrics, etc.).

### Phase B: Page Discovery and Classification

Using the sitemap URLs and internal links found on the homepage:

1. **Build page list.** Merge sitemap URLs with discovered internal links. Deduplicate. Cap at 20 pages for audit (prioritise: homepage, key landing pages, blog posts, product pages).
2. **Classify pages.** Assign each URL a type: `homepage`, `blog`, `product`, `about`, `contact`, `landing`, `legal`, `other`. Use URL patterns and page titles to classify.

### Phase C: Parallel Page Crawling

For each page in the audit list (beyond the homepage already crawled):

1. Navigate with Playwright and run `modules/extraction.js` on each page.
2. Process pages in batches of 3-5 to avoid overwhelming the browser.
3. Store extraction results per URL.

### Phase D: Blog/Article Analysis

For pages classified as `blog` or `article`:

1. Run additional AEO checks: Does the first paragraph answer a question? Are there answer blocks of 40-60 words? Question-based headings?
2. Run additional GEO checks: Author visible? Credentials stated? Published date? Sources linked? Fact density?
3. These signals feed into the category scoring.

### Phase E: Apply Rules and Score

This is where the audit happens. For each requested category:

1. **Read the reference file.** Load the relevant file from `references/` (e.g., `references/aeo.md` for AEO).
2. **Apply each rule** against the crawled data. For every check, record:
   - Check ID (e.g. `AEO-C1`)
   - Description
   - Severity: `Critical`, `Important`, or `Nice to have`
   - Result: `PASS`, `WARNING`, `FAIL`, `N/A`, or `UNTESTABLE`
   - Evidence (what you observed)
   - Fix (if FAIL or WARNING — what specifically to change)

3. **Also apply** `references/indexability.md` rules (always) and `references/ai-bots.md` analysis (always, but informational — does not affect score).

4. **Run schema deprecation check** if structured-data category is included:
   ```bash
   bash {skill_path}/scripts/check-schema-deprecations.sh '<json-ld-content>'
   ```

5. **Score deterministically.** Write the check results as JSON to a temp file, then run:
   ```bash
   python3 {skill_path}/scripts/score.py /tmp/audit-checks-{domain}.json
   ```
   The scoring engine handles severity weighting, category weighting, and grade calculation. Read its output for the final scores.

### Phase F: Generate Report

1. **Read the report template** from `modules/report-template.md`.
2. **Populate the template** with all collected data: site profile, AI crawler policy analysis, per-category results with check details, Lighthouse results (when ready), Perplexity citation results (when ready), and the prioritised fix list.
3. **Write the report** with the naming convention:
   - Single site: `{YYYY-MM-DD}-audit-{domain}.md`
   - Comparison: `{YYYY-MM-DD}-compare-{domain1}-vs-{domain2}.md`
4. Place the report in the current working directory.

---

## Scoring System

The scoring is fully deterministic and handled by `scripts/score.py`. Here is how it works so you can explain it to the user:

**Severity weights:** Critical = 3, Important = 2, Nice to have = 1

**Result multipliers:** PASS = 1.0, WARNING = 0.5, FAIL = 0.0

**N/A and UNTESTABLE** are excluded from both numerator and denominator — they do not affect the score.

**Category score** = sum(weight x multiplier) / sum(weights) x 100

**Category weights for overall score:**
| Category | Weight |
|----------|--------|
| AEO | 25% |
| GEO | 25% |
| SEO Technical | 20% |
| SEO On-Page | 15% |
| Structured Data | 15% |

If only some categories are audited, weights redistribute proportionally among audited categories.

**Letter grades:** A+ (95+), A (90-94), B+ (85-89), B (80-84), C+ (75-79), C (70-74), D (60-69), F (<60)

---

## Check Result JSON Format

When writing check results for the scoring engine, use this structure:

```json
{
  "domain": "example.com",
  "categories": {
    "aeo": {
      "checks": [
        {
          "id": "AEO-C1",
          "description": "First paragraph answers the page's primary question",
          "severity": "Critical",
          "result": "PASS",
          "evidence": "First paragraph provides a direct answer in 45 words",
          "fix": null
        }
      ]
    }
  }
}
```

---

## Comparison Mode

When two domains are provided:

1. Run the full audit (Phases A-E) on both domains.
2. Instead of two separate reports, produce a single comparison report:
   - Side-by-side score table (overall + per category)
   - Category-by-category analysis of differences
   - Top 3 priority fixes for each site
   - Winner per category with reasoning
3. Use the comparison naming convention for the output file.

---

## Important Guidance

- **Be thorough but honest.** Mark checks as `UNTESTABLE` when you genuinely cannot verify something from a crawl (e.g., server-side configuration). Do not guess.
- **Evidence matters.** Every FAIL and WARNING must include specific evidence (the actual meta description length, the actual heading text, the actual schema type found). This makes the report actionable.
- **Prioritise fixes.** The fix list at the end of the report should be ordered by impact: Critical FAILs first, then Critical WARNINGs, then Important FAILs, and so on.
- **Do not fabricate data.** If Lighthouse or Perplexity subagents fail or are unavailable, note this in the report and mark those checks as UNTESTABLE. Do not invent scores.
- **Respect rate limits.** Add 1-2 second delays between Playwright page navigations to avoid being blocked.
