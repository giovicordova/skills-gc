# AEO/GEO Quick Comparison: Anthropic vs OpenAI Docs

| Signal | Anthropic | OpenAI | Verdict |
|--------|-----------|--------|---------|
| **llms.txt** | Missing (404) | Full hierarchy + 6 sub-indexes | OpenAI wins decisively |
| **Direct .md access** | No | Yes (every page) | OpenAI wins decisively |
| **llms-full.txt** | Missing | 2.7MB single-file export | OpenAI wins decisively |
| **JSON-LD / Schema.org** | None | None | Both fail |
| **FAQ schema** | None | None | Both fail |
| **Meta descriptions** | Specific, per-page | Generic, short | Anthropic wins |
| **OG type** | "article" (correct) | "website" (imprecise) | Anthropic wins |
| **Server-side rendering** | Yes (Next.js RSC) | Yes (Astro SSG) | Tie |
| **Languages** | 9 | 1 (English only) | Anthropic wins decisively |
| **Sitemap URLs** | 2,085 | 2,925 | OpenAI wins |
| **English content pages** | ~620 | ~2,925 | OpenAI wins |
| **Sitemap lastmod** | Missing | Missing | Both fail |
| **Hreflang tags** | In sitemap only, not HTML | None | Anthropic wins |
| **Internal linking density** | Moderate | Heavy | OpenAI wins |
| **Code example languages** | 2-3 | 6 (JS, Python, C#, Java, Go, cURL) | OpenAI wins |
| **Tables (structured data)** | Yes (model comparisons) | No (card layouts) | Anthropic wins |
| **Page weight** | 370KB | 259KB | OpenAI wins |
| **TTFB** | 52ms | 272ms | Anthropic wins |
| **Breadcrumb markup** | None | None | Both fail |

## Bottom Line

OpenAI is ~17 points ahead on a weighted AEO/GEO score (72 vs 55 out of 100). The gap is almost entirely driven by one factor: **LLM-friendliness infrastructure** (llms.txt, direct Markdown endpoints, full-text exports). Anthropic's docs are well-built for human readers and traditional search, but are not optimised for AI consumption -- which is the entire point of AEO/GEO.

## Anthropic's #1 Priority
Implement llms.txt + direct Markdown endpoints. This closes the largest gap.

## OpenAI's #1 Priority
Add JSON-LD structured data. This is the main thing both sites are missing.
