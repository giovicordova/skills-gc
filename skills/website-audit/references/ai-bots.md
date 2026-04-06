# AI Bot Policy Analysis

Analyses how a site's robots.txt handles AI crawlers. This section is **informational only** — it does not affect the audit score. The purpose is to help site owners understand their current AI crawler policy and make informed decisions.

---

## AI Bot Categories

### Training Bots
These bots crawl content to train AI models. Blocking them prevents your content from being used in model training but does not prevent your content from appearing in AI search results.

| Bot | Operator | Purpose |
|-----|----------|---------|
| GPTBot | OpenAI | Training data for GPT models |
| ClaudeBot | Anthropic | Training data for Claude models |
| Google-Extended | Google | Training data for Gemini and other AI |
| GoogleOther | Google | General-purpose Google crawler for non-search uses |
| Applebot-Extended | Apple | Training data for Apple AI features |
| Meta-ExternalAgent | Meta | Training data for Meta AI models |
| Bytespider | ByteDance | Training data for TikTok/ByteDance AI |

### Retrieval Bots
These bots fetch content in real-time to provide AI-powered search answers. Blocking them prevents your site from appearing in AI search results (Perplexity answers, ChatGPT search, etc.).

| Bot | Operator | Purpose |
|-----|----------|---------|
| OAI-SearchBot | OpenAI | Real-time retrieval for ChatGPT search |
| ChatGPT-User | OpenAI | ChatGPT browsing feature |
| Claude-SearchBot | Anthropic | Real-time retrieval for Claude search |
| Claude-User | Anthropic | Claude browsing feature |
| PerplexityBot | Perplexity | Real-time retrieval for Perplexity answers |
| Perplexity-User | Perplexity | Perplexity browsing feature |
| Amazonbot | Amazon | Training and retrieval for Alexa/Amazon AI |

---

## How to Check

Parse robots.txt for `User-agent` directives matching these bot names. For each bot, determine:

1. **Explicitly blocked** — Has a `User-agent: {bot}` section with `Disallow: /`
2. **Explicitly allowed** — Has a `User-agent: {bot}` section with `Allow: /`
3. **Blocked via wildcard** — A `User-agent: *` with `Disallow: /` would block these (unless overridden)
4. **Not mentioned** — No specific rules; falls back to `User-agent: *` rules

---

## Strategy Grading

Grade the site's overall AI crawler strategy:

| Grade | Strategy | Description |
|-------|----------|-------------|
| **A** | Selective | Training bots blocked, retrieval bots allowed. The site protects its content from model training while remaining visible in AI search results. This is the recommended strategy for most sites. |
| **B** | Permissive | All bots allowed (or no rules present). The site's content may be used for training and will appear in AI search. Appropriate for sites that want maximum visibility. |
| **C** | Partial | Some bots blocked, some allowed, with no clear pattern. May indicate the policy was set up incrementally without a coherent strategy. |
| **D** | Restrictive | Most bots blocked, including some retrieval bots. The site is limiting its AI search visibility, which may or may not be intentional. |
| **F** | No rules | No robots.txt or no bot-specific rules at all. The site has no AI crawler policy — this is almost certainly an oversight rather than a choice. |

---

## Report Format

Present the analysis as:

1. **Table** showing each bot, its type (training/retrieval), and its status (blocked/allowed/not mentioned)
2. **Strategy grade** with explanation
3. **Recommendation** (if the current strategy seems unintentional or suboptimal)

Example recommendation: "You're blocking ClaudeBot (training) but not GPTBot (training). Consider blocking GPTBot too for a consistent training-block policy. Your retrieval bots are all allowed, which is good for AI search visibility."
