# Structured Data Rules

Structured data (JSON-LD) tells search engines and AI models exactly what the page content represents. Correct schema markup unlocks rich results and improves AI understanding.

---

## Critical

### SD-C1: JSON-LD present on every page
Every crawled page should have at least one `<script type="application/ld+json">` block. Pages without structured data are invisible to the knowledge graph.

**Check:** Count JSON-LD blocks per page. Flag pages with zero.
**Evidence:** JSON-LD count per page.

### SD-C2: Valid JSON
All JSON-LD blocks parse as valid JSON. Invalid JSON is silently ignored by search engines.

**Check:** Parse each JSON-LD block. Flag any parse errors.
**Evidence:** Parse errors found.

### SD-C3: @type matches page content
The `@type` in structured data matches what the page actually is. An Article page should have Article schema, not Product schema.

**Check:** Compare @type with the page classification from Phase B.
**Evidence:** @type found and page classification.

### SD-C4: Author fields use Person or Organization
Author fields in Article schema use `{"@type": "Person", "name": "..."}` or `{"@type": "Organization", ...}`, not plain strings. Typed authors link to the knowledge graph.

**Check:** If author field exists, verify it's an object with @type, not a string.
**Evidence:** Author field format found.

### SD-C5: Required fields present per schema type
Each schema type has mandatory fields. Missing required fields makes the schema invalid for rich results.

**Check:** Validate required fields per @type (see field reference below).
**Evidence:** Missing required fields per schema instance.

---

## Important

### SD-I1: Organization or LocalBusiness on homepage
The homepage should have Organization (or LocalBusiness for local businesses) schema with name, url, logo, and contactPoint.

**Check:** Homepage has Organization or LocalBusiness schema with required fields.
**Evidence:** Schema found and fields present/missing.

### SD-I2: BreadcrumbList on non-homepage pages
Non-homepage pages should have BreadcrumbList schema showing the navigation path. This displays breadcrumbs in search results.

**Check:** Non-homepage pages have BreadcrumbList with itemListElement array.
**Evidence:** Presence per page.

### SD-I3: Article schema on blog/article pages
Blog posts and articles should have Article (or NewsArticle, BlogPosting) schema.

**Check:** Pages classified as blog/article have Article-type schema.
**Evidence:** Schema type found per blog page.

### SD-I4: FAQPage schema where FAQ exists
If a page has FAQ content, it should have FAQPage schema (note: Google restricted this in Aug 2023 to authoritative health/government sites, but other engines still use it).

**Check:** If FAQ content exists on page, check for FAQPage schema.
**Evidence:** FAQ content presence and schema match.

### SD-I5: Recommended fields present
Beyond required fields, recommended fields add value for rich results (see field reference below).

**Check:** Count recommended fields present vs. total recommended for the @type.
**Evidence:** Recommended field coverage percentage.

---

## Nice to Have

### SD-N1: Product schema on product pages
Product pages have Product schema with name, description, offers (price, currency, availability).

**Check:** Pages classified as product have Product schema.
**Evidence:** Schema and fields found.

### SD-N2: Combined schema types
Pages use multiple relevant schema types (e.g., Article + BreadcrumbList + Organization). Multiple schemas provide richer signals.

**Check:** Count distinct @types per page.
**Evidence:** Schema types per page.

### SD-N3: sameAs social links
Organization schema includes sameAs array linking to social profiles (LinkedIn, Twitter, etc.).

**Check:** Organization schema has sameAs with social URLs.
**Evidence:** sameAs links found.

---

## Deprecated/Restricted Types

Run `scripts/check-schema-deprecations.sh` against the JSON-LD content and report any issues found.

| Type | Status | Since | Note |
|------|--------|-------|------|
| HowTo | Removed | Sep 2024 | Google no longer shows HowTo rich results |
| FAQPage | Restricted | Aug 2023 | Only for well-known government and health sites |
| SearchAction (WebSite) | Deprecated | 2024 | Sitelinks searchbox being phased out |
| Speakable | Limited | 2024 | Only EN, Google Assistant news only |
| VideoObject (Clip/Seek) | Changed | 2024 | Auto-detected now, manual markup optional |
| LearningResource | Removed | 2024 | Education Q&A removed from search features |

---

## Required and Recommended Fields by Schema Type

### Article / NewsArticle / BlogPosting
**Required:** headline, author, datePublished, publisher, image
**Recommended:** dateModified, description, mainEntityOfPage, articleBody, wordCount

### Organization
**Required:** name, url
**Recommended:** logo, description, contactPoint, sameAs, address, foundingDate

### LocalBusiness
**Required:** name, address, telephone
**Recommended:** openingHours, geo, priceRange, image, url, sameAs

### Product
**Required:** name
**Recommended:** description, image, brand, offers (price, priceCurrency, availability), review, aggregateRating, sku, gtin

### BreadcrumbList
**Required:** itemListElement (array of ListItem with position, name, item)
**Recommended:** (none beyond required)

### FAQPage
**Required:** mainEntity (array of Question with name, acceptedAnswer.text)
**Recommended:** (none beyond required)

### Person
**Required:** name
**Recommended:** jobTitle, url, image, sameAs, worksFor, alumniOf

### WebPage
**Required:** name
**Recommended:** description, url, breadcrumb, mainEntity, datePublished, dateModified

### WebSite
**Required:** name, url
**Recommended:** description, publisher, potentialAction (SearchAction — see deprecation note)

### Event
**Required:** name, startDate, location
**Recommended:** endDate, description, image, offers, performer, organizer

### Review
**Required:** itemReviewed, author, reviewRating
**Recommended:** datePublished, reviewBody

### Service
**Required:** name, provider
**Recommended:** description, serviceType, areaServed, offers

### SoftwareApplication
**Required:** name
**Recommended:** operatingSystem, applicationCategory, offers, aggregateRating
