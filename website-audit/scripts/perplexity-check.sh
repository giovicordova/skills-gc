#!/usr/bin/env bash
# Check if a domain is cited by Perplexity AI using the Sonar API.
# Usage: bash perplexity-check.sh <domain> <query1> <query2> ... <queryN>
#
# Requires: PERPLEXITY_API_KEY env var, curl, jq

set -euo pipefail

DOMAIN="${1:?Usage: perplexity-check.sh <domain> <query1> [query2] ...}"
shift

if [ -z "${PERPLEXITY_API_KEY:-}" ]; then
  echo '{"error": "PERPLEXITY_API_KEY not set", "queries_tested": 0, "citations_found": 0}'
  exit 0
fi

RESULTS="[]"
TOTAL=0
CITED=0

for QUERY in "$@"; do
  TOTAL=$((TOTAL + 1))

  RESPONSE=$(curl -s "https://api.perplexity.ai/chat/completions" \
    -H "Authorization: Bearer $PERPLEXITY_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{
      \"model\": \"sonar\",
      \"messages\": [{\"role\": \"user\", \"content\": \"$QUERY\"}],
      \"return_citations\": true
    }" 2>/dev/null || echo '{"error": "request_failed"}')

  # Check if domain appears in citations
  HAS_CITATION=$(echo "$RESPONSE" | jq -r --arg domain "$DOMAIN" '
    if .citations then
      [.citations[] | select(contains($domain))] | length > 0
    else
      false
    end
  ' 2>/dev/null || echo "false")

  CITATION_URLS=$(echo "$RESPONSE" | jq -r --arg domain "$DOMAIN" '
    if .citations then
      [.citations[] | select(contains($domain))]
    else
      []
    end
  ' 2>/dev/null || echo "[]")

  if [ "$HAS_CITATION" = "true" ]; then
    CITED=$((CITED + 1))
  fi

  RESULTS=$(echo "$RESULTS" | jq --arg q "$QUERY" --arg cited "$HAS_CITATION" --argjson urls "$CITATION_URLS" \
    '. + [{"query": $q, "cited": ($cited == "true"), "citation_urls": $urls}]')

  # Rate limit: 1 second between requests
  sleep 1
done

jq -n \
  --arg domain "$DOMAIN" \
  --argjson total "$TOTAL" \
  --argjson cited "$CITED" \
  --argjson results "$RESULTS" \
  '{
    domain: $domain,
    queries_tested: $total,
    citations_found: $cited,
    citation_rate: (if $total > 0 then ($cited / $total * 100 | round) else 0 end),
    results: $results
  }'
