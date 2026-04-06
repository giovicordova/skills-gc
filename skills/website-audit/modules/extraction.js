/**
 * Playwright page.evaluate extraction function.
 * Captures 20+ signals from any web page for audit analysis.
 *
 * Usage in Playwright:
 *   const data = await page.evaluate(extractionFunction);
 *
 * Copy the function body below into browser_evaluate.
 */
() => {
  // --- Helpers ---
  const text = (sel) => {
    const el = document.querySelector(sel);
    return el ? el.textContent.trim() : null;
  };

  const attr = (sel, a) => {
    const el = document.querySelector(sel);
    return el ? el.getAttribute(a) : null;
  };

  const allText = (sel) =>
    [...document.querySelectorAll(sel)].map((el) => el.textContent.trim());

  const allAttr = (sel, a) =>
    [...document.querySelectorAll(sel)].map((el) => el.getAttribute(a)).filter(Boolean);

  const wordCount = (str) => (str ? str.split(/\s+/).filter(Boolean).length : 0);

  // --- Meta ---
  const title = document.title || null;
  const metaDescription = attr('meta[name="description"]', "content");
  const canonical = attr('link[rel="canonical"]', "href");
  const robots = attr('meta[name="robots"]', "content");
  const viewport = attr('meta[name="viewport"]', "content");
  const lang = document.documentElement.lang || null;
  const charset =
    document.characterSet ||
    attr('meta[charset]', "charset") ||
    null;

  // --- Open Graph ---
  const og = {};
  document.querySelectorAll('meta[property^="og:"]').forEach((el) => {
    og[el.getAttribute("property")] = el.getAttribute("content");
  });

  // --- Headings ---
  const headings = {};
  for (let i = 1; i <= 6; i++) {
    const found = allText(`h${i}`);
    if (found.length > 0) headings[`h${i}`] = found;
  }

  // --- Links ---
  const internalLinks = [];
  const externalLinks = [];
  const hostname = window.location.hostname;

  document.querySelectorAll("a[href]").forEach((a) => {
    const href = a.getAttribute("href");
    const hasNoopener = a.getAttribute("rel")?.includes("noopener") || false;
    try {
      const url = new URL(href, window.location.origin);
      if (url.hostname === hostname || url.hostname === `www.${hostname}` || `www.${url.hostname}` === hostname) {
        internalLinks.push({ href: url.pathname, text: a.textContent.trim().slice(0, 100) });
      } else if (url.protocol.startsWith("http")) {
        externalLinks.push({ href: url.href, text: a.textContent.trim().slice(0, 100), noopener: hasNoopener });
      }
    } catch {
      // Skip malformed URLs
    }
  });

  // --- Images ---
  const images = [...document.querySelectorAll("img")].map((img) => ({
    src: img.getAttribute("src"),
    alt: img.getAttribute("alt"),
    hasAlt: img.hasAttribute("alt"),
    altLength: (img.getAttribute("alt") || "").length,
    loading: img.getAttribute("loading"),
  }));

  // --- Structured Data (JSON-LD) ---
  const jsonLd = [...document.querySelectorAll('script[type="application/ld+json"]')]
    .map((s) => {
      try {
        return JSON.parse(s.textContent);
      } catch {
        return { _parseError: true, _raw: s.textContent.slice(0, 500) };
      }
    });

  // --- Content Metrics ---
  const bodyText = document.body ? document.body.innerText : "";
  const totalWords = wordCount(bodyText);

  // First paragraph (for AEO)
  const firstP = document.querySelector("article p, main p, .content p, p");
  const firstParagraph = firstP ? firstP.textContent.trim() : null;
  const firstParagraphWords = wordCount(firstParagraph);

  // Question-based headings
  const allHeadingTexts = allText("h1, h2, h3, h4, h5, h6");
  const questionHeadings = allHeadingTexts.filter((h) => /\?$|^(what|how|why|when|where|who|which|can|do|does|is|are|will|should)\b/i.test(h));

  // Lists and tables (AEO signals)
  const listCount = document.querySelectorAll("ul, ol").length;
  const tableCount = document.querySelectorAll("table").length;

  // FAQ sections
  const faqSections = document.querySelectorAll('[itemtype*="FAQPage"], .faq, #faq, [class*="faq"], [id*="faq"]').length;

  // --- GEO Signals ---
  const authorEl = document.querySelector('[rel="author"], .author, [class*="author"], [itemprop="author"]');
  const authorName = authorEl ? authorEl.textContent.trim() : null;

  const publishDate =
    attr('meta[property="article:published_time"]', "content") ||
    attr('time[datetime]', "datetime") ||
    attr('[itemprop="datePublished"]', "content") ||
    null;

  const modifiedDate =
    attr('meta[property="article:modified_time"]', "content") ||
    attr('[itemprop="dateModified"]', "content") ||
    null;

  // External references/sources
  const sourceLinks = externalLinks.filter(
    (l) => !l.href.includes("facebook.com") && !l.href.includes("twitter.com") && !l.href.includes("linkedin.com")
  );

  // --- Technical ---
  const httpEquiv = allAttr('meta[http-equiv]', "http-equiv");
  const hreflang = allAttr('link[hreflang]', "hreflang");

  return {
    url: window.location.href,
    timestamp: new Date().toISOString(),

    // Meta
    title,
    titleLength: title ? title.length : 0,
    metaDescription,
    metaDescriptionLength: metaDescription ? metaDescription.length : 0,
    canonical,
    robots,
    viewport,
    lang,
    charset,
    og,

    // Headings
    headings,
    h1Count: (headings.h1 || []).length,
    questionHeadings,

    // Links
    internalLinks: internalLinks.slice(0, 100),
    internalLinkCount: internalLinks.length,
    externalLinks: externalLinks.slice(0, 50),
    externalLinkCount: externalLinks.length,

    // Images
    images: images.slice(0, 50),
    imageCount: images.length,
    imagesWithoutAlt: images.filter((i) => !i.hasAlt || i.alt === "").length,

    // Structured data
    jsonLd,
    jsonLdCount: jsonLd.length,
    jsonLdTypes: jsonLd
      .flatMap((j) => (j["@type"] ? [].concat(j["@type"]) : []))
      .filter(Boolean),

    // Content
    totalWords,
    firstParagraph: firstParagraph ? firstParagraph.slice(0, 500) : null,
    firstParagraphWords,
    listCount,
    tableCount,
    faqSections,

    // GEO signals
    authorName,
    publishDate,
    modifiedDate,
    sourceLinksCount: sourceLinks.length,

    // Technical
    httpEquiv,
    hreflang,
  };
}
