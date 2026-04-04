# AEO (Answer Engine Optimization) Rules

Answer Engine Optimization ensures content is structured for AI answer engines (Google AI Overviews, Perplexity, ChatGPT search) to extract and cite directly.

---

## Critical

### AEO-C1: First paragraph answers the question
The first paragraph of a page (within `<article>`, `<main>`, or the first `<p>`) should directly answer the page's primary question or topic. This is the text most likely to be extracted as a featured snippet or AI answer.

**Check:** First paragraph exists and is a declarative statement (not a question, not "Welcome to...", not navigation text).
**Evidence:** Quote the first paragraph and its word count.

### AEO-C2: Answer blocks 40-60 words
Key answer paragraphs should be 40-60 words — the sweet spot for featured snippet extraction. Too short lacks context; too long gets truncated.

**Check:** At least one paragraph in the main content area is 40-60 words and contains a direct answer.
**Evidence:** Quote the best candidate paragraph and its word count.

### AEO-C3: Key answers front-loaded
The most important information appears in the first 100 words of the page. Answer engines prioritise content near the top.

**Check:** The first 100 words contain the page's primary keyword/topic and a clear answer or definition.
**Evidence:** Quote the first 100 words.

### AEO-C4: Question-based headings
Headings (H2-H4) are phrased as questions that users actually ask. This directly maps to how people query answer engines.

**Check:** At least 20% of H2-H4 headings are question-based (start with who/what/where/when/why/how or end with ?).
**Evidence:** List question headings found and the percentage.

### AEO-C5: Concise definitions present
Key terms on the page have clear, concise definitions (1-2 sentences). Answer engines extract these for definition queries.

**Check:** If the page covers a specific topic or term, a clear "X is..." or "X refers to..." definition exists near the top.
**Evidence:** Quote any definitions found, or note their absence.

### AEO-C6: FAQ sections
Pages that answer multiple questions should have a dedicated FAQ section. This is high-value for "People Also Ask" and AI answer extraction.

**Check:** Look for FAQ sections (by ID, class, or FAQ schema). For pages that naturally answer multiple questions (guides, how-tos, product pages), an FAQ is expected.
**Evidence:** Note presence/absence and number of Q&A pairs if found.

---

## Important

### AEO-I1: Lists and tables for structured answers
Content uses `<ul>`, `<ol>`, and `<table>` where appropriate. Answer engines strongly prefer structured content for comparison, step, and list queries.

**Check:** Page contains at least one list or table if the content covers comparisons, steps, features, or specifications.
**Evidence:** Count of lists and tables found.

### AEO-I2: Clear, plain language
Content uses clear, jargon-free language at an appropriate reading level. Answer engines favour content that's accessible to a broad audience.

**Check:** Content avoids excessive jargon without explanation. Sentences are generally under 25 words.
**Evidence:** Note any complex or unclear passages.

### AEO-I3: Single primary question per page
Each page should focus on answering one primary question or topic. Pages that try to cover everything dilute their answer-engine relevance.

**Check:** The page has one clear topic reflected in the H1 and title. It does not try to answer unrelated questions.
**Evidence:** Note the primary topic and any off-topic sections.

### AEO-I4: Section length 100-150 words
Content sections (between headings) should be 100-150 words. This matches the extraction window of most answer engines.

**Check:** Measure the average words per section (content between H2/H3 headings).
**Evidence:** Average section word count.

---

## Nice to Have

### AEO-N1: Step-by-step instructions
How-to content uses numbered steps with clear action verbs. This is the most extractable format for procedural queries.

**Check:** If the page is a how-to or guide, it uses `<ol>` with numbered steps.
**Evidence:** Note presence of step-by-step formatting.

### AEO-N2: Summary or TL;DR
Long-form content includes a summary or TL;DR section, typically at the top or bottom.

**Check:** Look for summary, TL;DR, key takeaways, or overview section.
**Evidence:** Note presence and location.

### AEO-N3: Content depth 2000+ words
For comprehensive topic pages, content depth of 2000+ words signals authority to answer engines.

**Check:** Total word count of main content area.
**Evidence:** Word count.
