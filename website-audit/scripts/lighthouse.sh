#!/usr/bin/env bash
# Run Lighthouse audit and extract key metrics.
# Usage: bash lighthouse.sh <url> <output-json-path>
#
# Requires: lighthouse (npm install -g lighthouse), chromium

set -euo pipefail

URL="${1:?Usage: lighthouse.sh <url> <output-json-path>}"
OUTPUT="${2:?Usage: lighthouse.sh <url> <output-json-path>}"

# Run Lighthouse in headless mode
lighthouse "$URL" \
  --output=json \
  --output-path="$OUTPUT" \
  --chrome-flags="--headless --no-sandbox --disable-gpu" \
  --only-categories=performance,accessibility,best-practices,seo \
  --quiet 2>/dev/null

# Extract key metrics with jq
jq '{
  performance: (.categories.performance.score * 100),
  accessibility: (.categories.accessibility.score * 100),
  best_practices: (.categories["best-practices"].score * 100),
  seo: (.categories.seo.score * 100),
  core_web_vitals: {
    lcp: .audits["largest-contentful-paint"].numericValue,
    fid: (.audits["max-potential-fid"].numericValue // null),
    cls: .audits["cumulative-layout-shift"].numericValue,
    ttfb: (.audits["server-response-time"].numericValue // null),
    inp: (.audits["interaction-to-next-paint"].numericValue // null)
  },
  page_load_time: .audits["interactive"].numericValue
}' "$OUTPUT"
