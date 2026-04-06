# Transcript: Perspective Check on UK Freelancer Invoice API

## Task
Evaluate whether an Express + Prisma + PostgreSQL invoice generation and PDF export API for UK freelancers is worth continuing, given existing tools and stack alternatives.

## Steps Taken

### Step 1: Check project structure
- **Tool:** Bash (ls)
- **Purpose:** Verified the outputs directory path and checked the project root for any existing codebase or context files.
- **Finding:** No existing invoice API codebase found in this repo -- the task is advisory based on the user's description.

### Step 2: Search for existing UK freelancer invoicing tools
- **Tool:** WebSearch x3 (parallel)
- **Queries:**
  1. "UK freelancer invoice generation PDF software tools 2026"
  2. "best invoicing tools UK freelancers self-employed 2026"
  3. "Express Prisma PostgreSQL invoice API alternatives comparison 2026"
- **Finding:** The market is heavily saturated. Wave, Zoho Invoice, Invoice Ninja, QuickFile, and Sighted offer free invoicing. FreeAgent (free with NatWest) and QuickBooks are UK gold standards. Multiple open-source self-hosted options exist on GitHub (InvoicePlane, InvoiceShelf, Invoice-Generator API).

### Step 3: Research MTD compliance and stack alternatives
- **Tool:** WebSearch x3 (parallel)
- **Queries:**
  1. "UK Making Tax Digital ITSA April 2026 freelancers requirements"
  2. "invoice API open source self-hosted UK freelancer PDF generation github"
  3. "Supabase vs Prisma PostgreSQL invoice app 2026 comparison"
- **Finding:** MTD for ITSA became mandatory April 2026 for earners over GBP 50k. This is a critical compliance requirement the user likely has not accounted for. Supabase offers a lighter-weight alternative to the Express + Prisma stack with managed PostgreSQL, auth, and typed client built in.

### Step 4: Write the perspective check
- **Tool:** Write
- **Output:** `perspective-check.md` -- a structured analysis covering existing tools, MTD compliance risk, stack assessment, alternative approaches, and a clear recommendation.

### Step 5: Write this transcript
- **Tool:** Write
- **Output:** `transcript.md`

## Key Findings

1. **The market is saturated.** Dozens of free and paid tools already handle UK freelancer invoicing with PDF export.
2. **MTD for ITSA is the biggest blind spot.** As of April 2026, UK freelancers earning over GBP 50k must use HMRC-compatible software for quarterly digital submissions. An invoice-only tool is insufficient.
3. **The stack is functional but not optimal.** PostgreSQL is the right database. Express is dated for 2026 (Fastify or Hono are better choices). Prisma is solid but adds deployment weight.
4. **Recommendation:** Stop building unless there is a differentiated angle (AI-powered invoice creation, MTD-first tooling, IR35 tracking, or chat-based invoicing). Otherwise, use FreeAgent or Wave.

## Output Files
- `/Users/giovannicordova/Documents/02_projects/skills-gc/perspective-workspace/iteration-1/eval-0-full-mode/without_skill/outputs/perspective-check.md`
- `/Users/giovannicordova/Documents/02_projects/skills-gc/perspective-workspace/iteration-1/eval-0-full-mode/without_skill/outputs/transcript.md`
