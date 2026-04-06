# Perspective Report — UK Freelancer Invoice API

> 4 April 2026

## What You're Building

An Express API with Prisma ORM and PostgreSQL that handles invoice generation and PDF export, targeted at UK freelancers. Three weeks in. The core workflow: create invoices, store them in Postgres, export them as PDFs.

## What Already Exists

This is a crowded space. Multiple products already solve this problem end-to-end, several of them free or open-source:

- **[Invoice Ninja](https://invoiceninja.com/)** — Source-available (Laravel/PHP), self-hostable, full API with comprehensive documentation, handles invoices, quotes, payments, expenses, time tracking. Supports PDF export, client portal, 80+ payment gateways. Over 45k GitHub stars. This is the closest match to what you're building — except it's mature, battle-tested, and free to self-host with all Pro/Enterprise features included. The API alone likely covers your entire use case.

- **[Crater](https://crater.financial/)** — Open-source invoicing built with Laravel and VueJS, self-hosted, includes APIs, webhooks, and SDKs. Customer portal, expense tracking, payment management. Less feature-rich than Invoice Ninja but cleaner and simpler.

- **[Stripe Invoicing](https://stripe.com/invoicing)** — Fully managed invoicing API. Create, send, and track invoices programmatically. Handles payment collection, reminders, PDF generation. No self-hosting needed. Cost: 0.4%–0.5% per paid invoice. For a freelancer generating modest volume, this is likely cheaper than hosting and maintaining your own infrastructure.

- **[FreeAgent](https://www.freeagent.com/)** — Cloud accounting and invoicing built specifically for UK freelancers. HMRC-recognised for Making Tax Digital. Free with NatWest, RBS, or Mettle business accounts. Handles invoicing, expenses, tax returns, and MTD compliance in one platform.

- **[Wave](https://www.waveapps.com/)** — Completely free invoicing and accounting. Unlimited invoices, unlimited clients. No premium tier for core features.

- **[QuickFile](https://www.quickfile.co.uk/)** — Free for low-transaction sole traders in the UK. Full MTD VAT and Income Tax Self Assessment support.

**The honest assessment:** You are rebuilding something that already exists in multiple mature forms. Invoice Ninja alone has a comprehensive REST API that does everything you've described — and it's self-hostable for free.

## Alternative Approaches

### 1. Use Stripe Invoicing API directly
**What:** Instead of building an invoice system, use Stripe's Invoicing API as your backend. It handles creation, PDF generation, payment collection, and tracking.
**Trade-offs:** You lose full control over data and PDF layout. You gain payment processing, automatic reminders, a hosted invoice page, and zero infrastructure to maintain. At freelancer volumes, the per-invoice cost is negligible.

### 2. Self-host Invoice Ninja and extend it
**What:** Deploy Invoice Ninja (Docker one-liner), use its API for your custom frontend or integrations. Extend via its plugin system or API endpoints.
**Trade-offs:** You inherit a PHP/Laravel stack instead of Node.js. But you get years of edge cases handled — tax calculations, multi-currency, recurring invoices, payment gateway integrations, client portals, and PDF templates. You skip 3+ months of building what already exists.

### 3. Headless invoice generation library + your own storage
**What:** Use a dedicated invoice generation library (like [invoice-generator-api](https://github.com/Invoice-Generator/invoice-generator-api) on GitHub) for PDF creation, keep your own Prisma/Postgres for data storage.
**Trade-offs:** You still own the data model and storage, but outsource the PDF rendering complexity. Middle ground between full custom and full SaaS.

### 4. If you continue custom: modernise the stack
**What:** If this is a learning project or has unique requirements not covered above, the stack choices themselves can be improved:
- **Express → Hono or Fastify.** Express is legacy at this point. Fastify handles 2–3x more requests with half the latency. Hono handles 3x more than Express with 40% less memory, and runs on edge/serverless out of the box. Express 5 just shipped but it's catching up to where Fastify was years ago.
- **PDF generation:** Use Puppeteer/Playwright for HTML-to-PDF (best for complex layouts you already have as HTML/CSS) or PDFKit for programmatic generation (lighter, no headless browser dependency).
- **Prisma is solid** for this use case. See audit notes below on version.

## Codebase Audit

Since there is no codebase provided for direct inspection, this audit covers the stated stack against current best practices.

### Prisma ORM
- **Current state:** Prisma 7 shipped in early 2026. Major change: the Rust engine has been removed entirely, replaced with a pure TypeScript implementation. This means smaller bundle size, no binary compatibility issues, and faster cold starts.
- **Recommendation:** If you're on Prisma 5.x or early 6.x, upgrade to Prisma 7. The new ESM-first generator gives you full control over generated code location (no more magic in `node_modules`). TypedSQL (preview in 5.19+, stable in 6+) lets you write raw SQL with full type safety — useful for complex invoice queries with aggregations.
- **Connection pooling:** Configure `connection_limit` and `pool_timeout` in your database URL. For a single-user freelancer app, default pool size (5) is fine. If deploying serverless, consider Prisma Accelerate for connection pooling.

### Express.js
- **Current state:** Express 5.1 shipped. Breaking changes include named wildcards (`/*splat` instead of `/*`), removed `req.param()`, and changes to optional parameter handling. If you're on Express 4, migration is needed eventually but not urgent for a new project.
- **Honest take:** Express is the jQuery of Node.js frameworks — ubiquitous, well-documented, but showing its age. For a new API in 2026, Fastify or Hono are objectively better choices in performance, developer experience, and ecosystem momentum. If you're already 3 weeks in with Express, switching now depends on how much you've built. If it's mostly Prisma models and a few routes, switching is cheap. If you've built significant middleware, stay with Express and move on.

### PostgreSQL
- **Solid choice.** PostgreSQL is the right database for invoice data — relational, ACID-compliant, excellent JSON support for flexible invoice line items. No notes here.

### PDF Generation (unknown library)
- **Puppeteer/Playwright:** Best if you have HTML/CSS invoice templates. Resource-heavy (spins up a headless browser). Use `@sparticuz/chromium` for serverless deployments.
- **PDFKit:** Lightweight, programmatic, no browser dependency. Better for server environments with limited resources. More code to write for layout.
- **React-PDF (`@react-pdf/renderer`):** Good if you're in a React ecosystem and want component-based PDF templates. Lower resource usage than Puppeteer.

## Coherency

No codebase was provided for direct coherency analysis. If you'd like this assessed, share the repository or key files and I'll run a follow-up.

## Recommendation

**Adopt** — existing tools already do this well enough. Building a custom invoice API from scratch for personal freelancing use is a significant time investment for a solved problem.

### Recommended path

For a UK freelancer who needs invoicing + PDF export + potential MTD compliance:

1. **Simplest:** Use FreeAgent (free with NatWest/RBS/Mettle accounts) or Wave (free, no bank requirement). These handle invoicing, PDF, accounting, and MTD compliance out of the box.

2. **If you need API control:** Use Stripe Invoicing API. You get programmatic invoice creation, PDF generation, payment collection, and webhooks — with no infrastructure to maintain.

3. **If you want self-hosted + API:** Deploy Invoice Ninja. Docker setup, full REST API, self-hostable with all features. Extend it rather than rebuild it.

4. **If this is a learning project:** That's a valid reason to continue. But know that's the reason — not because the tool doesn't exist.

### Action Items

- [ ] Evaluate whether FreeAgent (free via bank account) or Wave meets your actual invoicing needs before writing more code
- [ ] If API access is required, test Stripe Invoicing API — create a test invoice via their API quickstart to see if it covers your use case
- [ ] If self-hosting is important, deploy Invoice Ninja via Docker (`docker-compose up`) and test its API against your requirements
- [ ] If continuing the custom build: upgrade to Prisma 7 for the pure TypeScript engine and ESM-first generator
- [ ] If continuing the custom build: benchmark whether Fastify or Hono would be a better fit than Express for your API layer — both have Express-like APIs making migration straightforward

- Note: the decision between adopt vs. continue-custom is the critical architectural choice. It deserves a focused session where you list the specific features you need and check them against Invoice Ninja's API and Stripe Invoicing. If either covers 80%+, building custom is not the right use of your time.

> After implementing action items, update this file: `- [ ]` → `- [x]`
