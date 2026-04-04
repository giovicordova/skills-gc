# Perspective Check: UK Freelancer Invoice API (Express + Prisma + PostgreSQL)

## The Hard Truth: This Already Exists -- Many Times Over

You are 3 weeks into building something that dozens of mature tools already do, many of them free. Before writing another line of code, you need to decide whether you are building a **product** or solving a **personal problem** -- because the answer changes everything.

---

## 1. Existing Tools That Already Do This

### Free (genuinely free, not trial-limited)

| Tool | What It Does | UK-Specific |
|------|-------------|-------------|
| **Wave** | Invoicing + accounting + PDF export. No feature gates on invoicing. Revenue comes from payment processing fees. | VAT support, GBP |
| **Zoho Invoice** | Free since 2023. Time tracking + invoicing + PDF. Clean workflow. | Multi-currency, VAT |
| **Invoice Ninja** | Unlimited invoices, multiple clients, reporting, professional PDF output. Open source. | Multi-currency |
| **QuickFile** | Free for low-transaction sole traders. Full MTD VAT and ITSA support. | Built for UK |
| **Sighted** | Free invoicing and accounting exclusively for sole traders in the UK and Ireland. | UK-only |

### Paid but battle-tested

| Tool | Cost | Why It Matters |
|------|------|----------------|
| **FreeAgent** | Free with NatWest/RBS/Ulster Bank account; otherwise ~GBP 19/mo | UK gold standard. Bank integration, tax time automation, MTD-compliant. |
| **QuickBooks Self-Employed** | GBP 10 + VAT/mo | HMRC-recognised. MTD-compliant. |
| **FreshBooks** | From ~GBP 12/mo | Time tracking + expenses + invoicing + mobile app. |

### Open-source self-hosted (if you want control)

| Project | Stack | Notes |
|---------|-------|-------|
| **InvoicePlane** | PHP 8.2+ | Mature. PDF generation, client management, quotes. |
| **InvoiceShelf** | Laravel + VueJS | Modern. Mobile app. Expense tracking. |
| **Invoice-Generator API** | Node.js | Free API specifically for generating invoice PDFs and e-Invoices. |

**Verdict:** The market is saturated. Unless you have a specific angle none of these cover, you are reinventing the wheel.

---

## 2. The MTD Elephant in the Room

This is the biggest risk you may not have accounted for.

**From April 2026 (i.e., now)**, HMRC's Making Tax Digital for Income Tax Self Assessment (MTD for ITSA) requires:

- Sole traders and landlords earning over **GBP 50,000** must keep digital records and submit quarterly updates via HMRC-compatible software.
- Those earning **GBP 30,000-50,000** join in April 2027.
- The **GBP 20,000+** threshold follows after that.

**What this means for your project:**
- Simple invoice generation is no longer enough for UK freelancers. They need MTD-compliant record-keeping.
- Your Express API would need to integrate with HMRC's MTD APIs for quarterly submissions.
- Penalties are real: a points-based system where 4 missed quarterly updates trigger a GBP 200 fine, with GBP 200 per miss thereafter.

If your tool does not handle MTD compliance, UK freelancers will still need a second tool (QuickBooks, FreeAgent, Xero) anyway -- which makes your invoice-only tool redundant for most users.

---

## 3. Stack Assessment: Express + Prisma + PostgreSQL

### What is right about it

- **PostgreSQL** -- Correct choice for financial/invoice data. ACID-compliant, mature, reliable. No change needed.
- **Prisma** -- Good ORM for TypeScript/Node.js. Type-safe queries, clean migrations. The schema-first approach suits invoice data modelling well.
- **Express** -- Works. Proven. Massive ecosystem.

### What is questionable

| Concern | Detail |
|---------|--------|
| **Express is showing its age** | No built-in TypeScript support, no native async error handling, minimal structure. For a new project in 2026, **Fastify** or **Hono** would give you better performance, better TypeScript support, and a more modern DX. |
| **PDF generation approach matters** | You have not mentioned your PDF library. This is often the hardest part. Options: **Puppeteer/Playwright** (HTML-to-PDF, flexible but heavy), **pdf-lib** (programmatic, lightweight), **pdfmake** (declarative), or a service like **Gotenberg**. The choice significantly affects deployment complexity. |
| **No mention of authentication** | Invoice data is sensitive financial information. You need auth from day one. Rolling your own is risky -- consider **Clerk**, **Auth.js**, or **Supabase Auth**. |
| **Deployment overhead** | Express + Prisma + PostgreSQL means you need a server (not serverless-friendly with Prisma's binary engine). You are looking at a VPS or managed platform like Railway/Render. |

### Alternative stack worth considering

If you were starting fresh today and wanted to build something custom:

**Supabase + Edge Functions** -- Managed PostgreSQL, built-in auth, row-level security, real-time subscriptions, and you can add PDF generation via an Edge Function calling a service like Gotenberg. Much less code to maintain. No ORM needed (Supabase has a typed client).

**Or simply:** Use an existing open-source project (InvoiceShelf, Invoice Ninja) and customise it for UK-specific needs.

---

## 4. The Real Question: What Should You Actually Do?

### Option A: Stop building. Use existing tools. (Recommended for most cases)

If you are building this to solve your own invoicing problem as a UK freelancer:
- Use **FreeAgent** (free if you have NatWest/RBS) or **Wave** (free regardless).
- Both handle invoicing, PDF export, AND MTD compliance.
- You save 3 weeks of past work and months of future maintenance.

### Option B: Pivot to a niche that does not exist yet.

If you want to build a product, you need a differentiated angle. Gaps in the market:

1. **AI-powered invoice creation from conversation/email** -- "Forward me the email thread, I will generate the invoice." None of the existing tools do this well.
2. **MTD-first invoicing for sub-GBP 50k freelancers** -- Prepare them before the threshold drops. Most tools target businesses already above the threshold.
3. **Invoice + IR35 status tracker** -- For contractors navigating IR35 determinations alongside invoicing. Genuinely underserved.
4. **WhatsApp/Telegram invoice bot** -- Many UK tradespeople and freelancers do not use desktop apps. A chat-based interface for creating and sending invoices would be novel.

### Option C: Continue, but reframe as a learning project.

If the goal is to learn Express, Prisma, and PostgreSQL -- that is completely valid. But be honest about it. Do not spend months polishing something that FreeAgent already does better with a decade of refinement behind it.

---

## 5. Summary

| Question | Answer |
|----------|--------|
| Does this already exist? | Yes, extensively. Free and paid options abound. |
| Is the stack wrong? | No, but it is not optimal. PostgreSQL is solid; Express and Prisma are fine but heavier than needed. |
| Biggest blind spot? | MTD for ITSA compliance. Without it, the tool is incomplete for UK freelancers from April 2026. |
| Should you continue? | Only if you have a specific angle the existing tools miss, or if this is explicitly a learning exercise. |

---

## Sources

- [Making Tax Digital for Freelancers: Essential Guide to the 2026 Changes](https://www.no-worries.co.uk/blog/2026-changes-for-freelancers-mtd/)
- [Making Tax Digital for Income Tax in 2026](https://www.startyourbusinessmag.com/blog/2026/03/06/making-tax-digital-for-income-tax-in-2026-what-sole-traders-freelancers-and-landlords-need-to-know-and-do/)
- [Making Tax Digital Starts in 24 Days -- What UK Developers Need to Know](https://dev.to/landolio/making-tax-digital-starts-in-24-days-what-uk-developers-need-to-know-2cfb)
- [Best Invoice Software UK 2026](https://www.kaeltripton.com/best-invoice-software-uk/)
- [Best Invoicing Software for Freelancers in 2026](https://tofu.com/blog/the-best-invoicing-software-for-freelancers-in-2025)
- [9 Best Invoice Apps for UK Small Businesses 2026](https://www.mobiletransaction.org/invoice-apps-for-small-business-uk/)
- [IPSE: Best Invoicing Tools for Freelancers](https://www.ipse.co.uk/advice/best-invoicing-tools-apps-freelancers)
- [InvoicePlane on GitHub](https://github.com/InvoicePlane/InvoicePlane)
- [InvoiceShelf on GitHub](https://github.com/InvoiceShelf/InvoiceShelf)
- [Invoice-Generator API on GitHub](https://github.com/Invoice-Generator/invoice-generator-api)
- [Supabase vs Prisma: Feature Comparison](https://www.leanware.co/insights/supabase-vs-prisma)
- [The Next Evolution of Prisma ORM](https://www.prisma.io/blog/the-next-evolution-of-prisma-orm)
