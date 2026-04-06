# GEO (Generative Engine Optimization) Rules

Generative Engine Optimization ensures content is structured for AI models to cite, attribute, and trust. GEO goes beyond AEO by focusing on authoritativeness, provenance, and off-site presence.

---

## Critical

### GEO-C1: Author name visible
The content author's name is visible on the page — not just in metadata or structured data, but in the rendered content.

**Check:** Author name appears in visible text (not just `<meta>` tags). Look for bylines, author boxes, "Written by" text.
**Evidence:** Quote the author attribution found, or note its absence.

### GEO-C2: Author credentials stated
The author's expertise or credentials are mentioned on the page. AI models use this to assess source quality for E-E-A-T.

**Check:** Author has a bio, title, or credentials visible (e.g., "John Smith, Senior Data Scientist" or an author bio section).
**Evidence:** Quote credentials found.

### GEO-C3: Published date present
Content has a visible publication date. AI models use date signals to assess freshness and relevance.

**Check:** A date is visible on the page AND present in metadata (`article:published_time` or `datePublished` schema).
**Evidence:** The date found and where it appears.

### GEO-C4: Sources and references linked
Claims and data points link to external sources. AI models track citation chains — cited content is more likely to be cited.

**Check:** The page contains outbound links to sources (not just social media or navigation). At least 2 external source links for content pages.
**Evidence:** Count of source links and examples.

### GEO-C5: Structured data present
JSON-LD structured data is present and correctly typed for the content (Article for blog posts, Product for products, etc.).

**Check:** At least one `<script type="application/ld+json">` block exists and parses as valid JSON.
**Evidence:** Schema types found.

---

## Important

### GEO-I1: Last-updated date
Content shows when it was last updated, not just when it was published. AI models favour fresh content.

**Check:** A "last updated", "modified", or `article:modified_time` date exists and differs from the publish date.
**Evidence:** Modified date found or absence noted.

### GEO-I2: Fact density
Content contains specific, verifiable facts rather than vague generalisations. AI models prefer factual content for citation.

**Check:** Content includes specific numbers, dates, percentages, names, or data points. At least 5 verifiable facts per 500 words.
**Evidence:** Examples of facts found and density estimate.

### GEO-I3: Original data or perspective
Content offers something not available on the first page of Google — original research, data, analysis, or a unique perspective.

**Check:** Look for original charts, data tables, survey results, case studies, or clearly original analysis.
**Evidence:** Note any original content found.

### GEO-I4: Quotable passages
Content contains self-contained, quotable sentences that AI could extract and attribute. Good quotable passages state a conclusion or insight in one sentence.

**Check:** Content has sentences that work standalone as attributable quotes (clear subject, specific claim).
**Evidence:** Quote 1-2 examples of quotable passages.

### GEO-I5: Entity density 15+
Content mentions 15+ distinct named entities (people, organisations, products, places). High entity density signals information richness.

**Check:** Count distinct named entities in the main content.
**Evidence:** Entity count and examples.

---

## Nice to Have

### GEO-N1: Expert quotes
Content includes direct quotes from named experts (not just the author). This adds credibility and citability.

**Check:** Look for blockquotes or inline quotes attributed to named individuals.
**Evidence:** Note quotes found and their attribution.

### GEO-N2: Methodology disclosed
If the content presents data or research, the methodology is explained.

**Check:** For data-driven content, a methodology or "How we measured" section exists.
**Evidence:** Note presence.

### GEO-N3: Content depth 800+ words
For content pages (not landing/product pages), 800+ words signals enough depth for AI citation.

**Check:** Word count of main content.
**Evidence:** Word count.

---

## Off-Site Signals (Informational)

These cannot be fully verified from a crawl but are noted when evidence is found:

### GEO-OFF1: YouTube presence
Does the brand/author have YouTube content related to this topic?

### GEO-OFF2: Reddit presence
Is the brand discussed on Reddit in relevant subreddits?

### GEO-OFF3: Review platform presence
Does the business have reviews on Google, Trustpilot, G2, etc.?

### GEO-OFF4: Brand mentions
Is the brand mentioned on third-party sites (not owned properties)?

### GEO-OFF5: Wikipedia presence
Does the brand/person have a Wikipedia page or Wikidata entry?

### GEO-OFF6: Multi-platform consistency
Is information consistent across the brand's web presence?

> Off-site signals are marked N/A by default. If the Perplexity citation check reveals relevant data, update accordingly. These do not affect the score.
