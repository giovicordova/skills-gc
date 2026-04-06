#!/usr/bin/env bash
# Check JSON-LD for deprecated or restricted schema types.
# Usage: bash check-schema-deprecations.sh '<json-ld-string>'
# Or:    echo '<json-ld-string>' | bash check-schema-deprecations.sh -
#
# Requires: jq

set -euo pipefail

if [ "${1:-}" = "-" ]; then
  INPUT=$(cat)
else
  INPUT="${1:?Usage: check-schema-deprecations.sh '<json-ld>' or echo '<json-ld>' | check-schema-deprecations.sh -}"
fi

# Deprecated/restricted types and their status
# Based on Google's structured data documentation as of 2025
DEPRECATIONS='{
  "HowTo": {"status": "removed", "date": "2024-09", "note": "Google no longer shows HowTo rich results"},
  "FAQPage": {"status": "restricted", "date": "2023-08", "note": "Only shown for well-known government and health websites"},
  "SearchAction": {"status": "warning", "date": "2024", "note": "WebSite SearchAction sitelinks searchbox being deprecated"},
  "Speakable": {"status": "limited", "date": "2024", "note": "Only available in EN for Google Assistant news results"},
  "VideoObject": {"status": "changed", "date": "2024", "note": "Clip and Seek markup no longer required — Google auto-detects"},
  "LearningResource": {"status": "removed", "date": "2024", "note": "Education Q&A and learning resource removed from search features"}
}'

# Extract all @type values from the JSON-LD (handles nested and arrays)
TYPES=$(echo "$INPUT" | jq -r '
  [.. | objects | .["@type"] // empty] | flatten | unique | .[]
' 2>/dev/null || echo "")

if [ -z "$TYPES" ]; then
  echo '{"valid": true, "types_found": [], "warnings": [], "errors": []}'
  exit 0
fi

WARNINGS="[]"
ERRORS="[]"
TYPES_FOUND="[]"

while IFS= read -r TYPE; do
  [ -z "$TYPE" ] && continue
  TYPES_FOUND=$(echo "$TYPES_FOUND" | jq --arg t "$TYPE" '. + [$t]')

  DEPRECATION=$(echo "$DEPRECATIONS" | jq --arg t "$TYPE" '.[$t] // null')
  if [ "$DEPRECATION" != "null" ]; then
    STATUS=$(echo "$DEPRECATION" | jq -r '.status')
    NOTE=$(echo "$DEPRECATION" | jq -r '.note')
    DATE=$(echo "$DEPRECATION" | jq -r '.date')

    ENTRY=$(jq -n --arg type "$TYPE" --arg status "$STATUS" --arg note "$NOTE" --arg date "$DATE" \
      '{"type": $type, "status": $status, "since": $date, "note": $note}')

    if [ "$STATUS" = "removed" ]; then
      ERRORS=$(echo "$ERRORS" | jq --argjson e "$ENTRY" '. + [$e]')
    else
      WARNINGS=$(echo "$WARNINGS" | jq --argjson w "$ENTRY" '. + [$w]')
    fi
  fi
done <<< "$TYPES"

jq -n \
  --argjson types "$TYPES_FOUND" \
  --argjson warnings "$WARNINGS" \
  --argjson errors "$ERRORS" \
  '{
    valid: (($errors | length) == 0),
    types_found: $types,
    warnings: $warnings,
    errors: $errors,
    total_issues: (($warnings | length) + ($errors | length))
  }'
