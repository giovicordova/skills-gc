# Transcript — Perspective Skill Execution

## Task
Strategic reality check on a 3-week-old Express/Prisma/PostgreSQL API for UK freelancer invoice generation and PDF export.

## Mode
Full mode (all 6 stages). No codebase provided — worked from the described stack and problem domain.

---

## Stage 1: Understand the scope
- **Tool:** Read — read `perspective/SKILL.md`
- **Tool:** Bash — checked project root structure with `ls`
- **Tool:** Bash — created outputs directory
- **Finding:** No actual codebase or input files provided. Project described as Express + Prisma + PostgreSQL invoice API for UK freelancers, 3 weeks into development. Proceeded with described stack for research and audit.

## Stage 2: Research the landscape
Ran 11 web searches covering different angles:

1. **WebSearch** — "UK freelancer invoice generation software tools 2025 2026"
   - Found: FreeAgent, Wave, Sighted, FreshBooks, Moxie, Tofu. Market valued at $446M.

2. **WebSearch** — "open source invoice generator API self-hosted PDF export"
   - Found: Invoice Ninja (Laravel, full API, self-hostable), Crater, invoice-generator-api on GitHub, Manta, Serverless Invoices, EasyInvoicePDF.

3. **WebSearch** — "best invoicing software UK freelancers sole traders 2026"
   - Found: QuickFile (free, MTD-compliant), FreeAgent (free via bank accounts), Wave, Xero. MTD becomes mandatory April 2026.

4. **WebSearch** — "Express Prisma PostgreSQL invoice API Node.js project github"
   - Found: Several boilerplate repos but no dedicated invoice API projects in this exact stack.

5. **WebSearch** — "alternatives to building custom invoice system freelancer API"
   - Found: Stripe, Wave, Bloom.io, Harpoon, HoneyBook, UniBee (open-source).

6. **WebSearch** — "HMRC Making Tax Digital invoice requirements UK 2026"
   - Found: MTD mandatory from April 2026 for income >£50k. Quarterly digital reporting. E-invoicing mandatory for B2B/B2G from April 2029. Specific invoice field requirements documented.

7. **WebSearch** — "Invoice Ninja self-hosted API open source features 2026"
   - Found: Full REST API, v5.10.8, all Pro/Enterprise features in self-hosted, Docker deployment, comprehensive API docs.

8. **WebSearch** — "Crater invoice open source self-hosted API"
   - Found: Laravel/VueJS, APIs + webhooks + SDKs, Docker deployment, customer portal.

9. **WebSearch** — "Node.js PDF generation invoice 2025 best library puppeteer vs pdfkit vs react-pdf"
   - Found: Puppeteer (high fidelity, resource heavy), PDFKit (lightweight, programmatic), React-PDF (component-based). Trade-offs documented.

10. **WebSearch** — "Express.js vs Fastify vs Hono Node.js API 2025 2026 performance comparison"
    - Found: Hono 3x faster than Express, Fastify 2-3x faster. Express is slowest of the three. Hono best for edge/serverless.

11. **WebSearch** — "Stripe invoicing API freelancer UK integration"
    - Found: Full Invoicing API, no-code and API options, PDF generation included, webhook events, global availability.

## Stage 3: Coherency analysis
- **Skipped** — no codebase provided for direct inspection. Noted in report that this can be done as a follow-up if files are shared.

## Stage 4: Audit the codebase
Used Context7 MCP for live documentation on key dependencies:

1. **Tool:** mcp__plugin_context7_context7__resolve-library-id — resolved Prisma (`/websites/prisma_io`) and Express (`/websites/expressjs_en`)

2. **Tool:** mcp__plugin_context7_context7__query-docs — Prisma connection pooling, PostgreSQL configuration, best practices
   - Found: connection_limit and pool_timeout configuration, connection pool sizing guidance.

3. **Tool:** mcp__plugin_context7_context7__query-docs — Express v5 migration, breaking changes
   - Found: Named wildcards required, req.param() removed, optional parameter changes, Node 18+ required.

4. **Tool:** mcp__plugin_context7_context7__query-docs — Prisma latest version, TypedSQL, upgrade guide
   - Found: TypedSQL preview feature, ESM-first generator, upgrade paths from v5 to v6/v7.

5. **WebSearch** — "Prisma ORM 6.0 7.0 release 2025 2026 major changes"
   - Found: Prisma 7 removed Rust engine entirely, pure TypeScript, ESM-first, ~98% fewer types, 70% faster type checking, new caching layer.

## Stage 5: Report
- **Tool:** Write — created `2026-04-04-perspective-report.md` in the outputs directory
- **Recommendation:** Adopt — existing tools (Invoice Ninja, Stripe Invoicing, FreeAgent, Wave) already solve this problem comprehensively
- **5 action items** provided, prioritised by impact

## Stage 6: Implement
Not applicable — report delivered, awaiting user decision on action items.

---

## Tools Used Summary
| Tool | Count | Purpose |
|------|-------|---------|
| Read | 1 | Read SKILL.md |
| Bash | 2 | Directory listing, directory creation |
| WebSearch | 11 | Landscape research, alternatives, stack comparisons, UK tax requirements |
| ToolSearch | 3 | Load WebSearch, Context7 resolve, Context7 query tools |
| mcp__plugin_context7_context7__resolve-library-id | 2 | Resolve Prisma and Express library IDs |
| mcp__plugin_context7_context7__query-docs | 3 | Pull live docs for Prisma and Express |
| Write | 2 | Perspective report and this transcript |
