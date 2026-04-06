# Website Audit Report Template

Use this template structure when generating audit reports. Replace placeholders with actual data.

---

## Single-Site Report Structure

```markdown
# Website Audit: {domain}

**Date:** {YYYY-MM-DD}
**Categories audited:** {list}
**Pages crawled:** {count}

---

## Overall Score: {score}/100 ({grade})

| Category | Score | Grade |
|----------|-------|-------|
| AEO | {score}/100 | {grade} |
| GEO | {score}/100 | {grade} |
| SEO Technical | {score}/100 | {grade} |
| SEO On-Page | {score}/100 | {grade} |
| Structured Data | {score}/100 | {grade} |

---

## Site Profile

| Property | Value |
|----------|-------|
| Domain | {domain} |
| HTTPS | {yes/no} |
| CMS | {detected or unknown} |
| Pages in sitemap | {count} |
| Pages crawled | {count} |
| Language | {lang} |

---

## AI Crawler Policy

| Bot | Type | Status |
|-----|------|--------|
| GPTBot | Training | {allowed/blocked} |
| ClaudeBot | Training | {allowed/blocked} |
| Google-Extended | Training | {allowed/blocked} |
| ... | ... | ... |

**Strategy grade:** {A-F} — {explanation}

> This section is informational. AI crawler policy does not affect the audit score.

---

## {Category Name}

### Summary

{Brief category overview — 2-3 sentences on how the site performs in this area.}

### Results

| ID | Check | Severity | Result | Evidence |
|----|-------|----------|--------|----------|
| {ID} | {description} | {severity} | {PASS/WARNING/FAIL/N/A/UNTESTABLE} | {evidence} |

### Fixes

{Only include for checks that returned FAIL or WARNING. List each fix with:}

- **{ID}: {check description}**
  Current: {what was found}
  Fix: {specific action to take}
  Impact: {severity}

---

## Lighthouse Results

| Metric | Score |
|--------|-------|
| Performance | {score} |
| Accessibility | {score} |
| Best Practices | {score} |
| SEO | {score} |

### Core Web Vitals

| Metric | Value | Status |
|--------|-------|--------|
| LCP | {value}ms | {good/needs improvement/poor} |
| CLS | {value} | {good/needs improvement/poor} |
| INP | {value}ms | {good/needs improvement/poor} |

> If Lighthouse was unavailable, note: "Lighthouse audit was not available for this run."

---

## Perplexity Citation Check

**Queries tested:** {count}
**Citations found:** {count} ({percentage}%)

| Query | Cited? | URLs |
|-------|--------|------|
| {query} | {yes/no} | {urls} |

> If Perplexity check was unavailable, note: "Perplexity citation check requires PERPLEXITY_API_KEY."

---

## Priority Fix List

Ordered by impact (Critical FAILs first, then Critical WARNINGs, then Important FAILs, etc.)

### Critical

1. **[{ID}] {description}** — {specific fix action}
2. ...

### Important

1. **[{ID}] {description}** — {specific fix action}
2. ...

### Nice to Have

1. **[{ID}] {description}** — {specific fix action}
2. ...
```

---

## Comparison Report Structure

```markdown
# Website Comparison: {domain1} vs {domain2}

**Date:** {YYYY-MM-DD}
**Categories compared:** {list}

---

## Overall Comparison

| Category | {domain1} | {domain2} | Winner |
|----------|-----------|-----------|--------|
| Overall | {score} ({grade}) | {score} ({grade}) | {domain} |
| AEO | {score} ({grade}) | {score} ({grade}) | {domain} |
| GEO | {score} ({grade}) | {score} ({grade}) | {domain} |
| SEO Technical | {score} ({grade}) | {score} ({grade}) | {domain} |
| SEO On-Page | {score} ({grade}) | {score} ({grade}) | {domain} |
| Structured Data | {score} ({grade}) | {score} ({grade}) | {domain} |

---

## Category Analysis

### {Category Name}

{2-3 paragraphs comparing how each site performs, with specific examples.}

---

## Top 3 Fixes: {domain1}

1. **[{ID}] {description}** — {fix}
2. **[{ID}] {description}** — {fix}
3. **[{ID}] {description}** — {fix}

## Top 3 Fixes: {domain2}

1. **[{ID}] {description}** — {fix}
2. **[{ID}] {description}** — {fix}
3. **[{ID}] {description}** — {fix}
```

---

## File Naming

- Single site: `{YYYY-MM-DD}-audit-{domain}.md` (e.g. `2025-04-04-audit-example-com.md`)
- Comparison: `{YYYY-MM-DD}-compare-{domain1}-vs-{domain2}.md`
- Replace dots in domain with hyphens for the filename.
