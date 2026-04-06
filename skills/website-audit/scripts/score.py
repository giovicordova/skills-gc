#!/usr/bin/env python3
"""
Deterministic scoring engine for website-audit.

Usage:
    python3 score.py <checks.json> [--categories cat1,cat2,...]

Input: JSON file with check results (see SKILL.md for format).
Output: JSON to stdout with per-category scores, overall score, and letter grades.
"""

import json
import sys

SEVERITY_WEIGHTS = {
    "Critical": 3,
    "Important": 2,
    "Nice to have": 1,
}

RESULT_MULTIPLIERS = {
    "PASS": 1.0,
    "WARNING": 0.5,
    "FAIL": 0.0,
}

CATEGORY_WEIGHTS = {
    "aeo": 0.25,
    "geo": 0.25,
    "seo-technical": 0.20,
    "seo-on-page": 0.15,
    "structured-data": 0.15,
}

EXCLUDED_RESULTS = {"N/A", "UNTESTABLE"}


def letter_grade(score: float) -> str:
    if score >= 95:
        return "A+"
    elif score >= 90:
        return "A"
    elif score >= 85:
        return "B+"
    elif score >= 80:
        return "B"
    elif score >= 75:
        return "C+"
    elif score >= 70:
        return "C"
    elif score >= 60:
        return "D"
    else:
        return "F"


def score_category(checks: list[dict]) -> dict:
    """Score a single category's checks."""
    total_weight = 0.0
    earned = 0.0
    counts = {"PASS": 0, "WARNING": 0, "FAIL": 0, "N/A": 0, "UNTESTABLE": 0}

    for check in checks:
        result = check.get("result", "UNTESTABLE")
        severity = check.get("severity", "Nice to have")
        counts[result] = counts.get(result, 0) + 1

        if result in EXCLUDED_RESULTS:
            continue

        weight = SEVERITY_WEIGHTS.get(severity, 1)
        multiplier = RESULT_MULTIPLIERS.get(result, 0.0)
        total_weight += weight
        earned += weight * multiplier

    if total_weight == 0:
        score = 0.0
    else:
        score = (earned / total_weight) * 100

    return {
        "score": round(score, 1),
        "grade": letter_grade(score),
        "total_checks": len(checks),
        "counts": counts,
    }


def score_overall(category_scores: dict, requested_categories: list[str] | None = None) -> dict:
    """Calculate weighted overall score with proportional redistribution."""
    if requested_categories is None:
        requested_categories = list(category_scores.keys())

    # Filter to categories that were actually audited and have scores
    audited = {k: v for k, v in category_scores.items() if k in requested_categories}

    if not audited:
        return {"score": 0.0, "grade": "F"}

    # Redistribute weights proportionally among audited categories
    total_configured_weight = sum(
        CATEGORY_WEIGHTS.get(cat, 0) for cat in audited
    )

    if total_configured_weight == 0:
        # Equal weight fallback
        weight_per = 1.0 / len(audited)
        redistributed = {cat: weight_per for cat in audited}
    else:
        redistributed = {
            cat: CATEGORY_WEIGHTS.get(cat, 0) / total_configured_weight
            for cat in audited
        }

    weighted_sum = sum(
        audited[cat]["score"] * redistributed[cat] for cat in audited
    )

    return {
        "score": round(weighted_sum, 1),
        "grade": letter_grade(weighted_sum),
        "category_weights_used": {k: round(v, 3) for k, v in redistributed.items()},
    }


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 score.py <checks.json> [--categories cat1,cat2,...]", file=sys.stderr)
        sys.exit(1)

    checks_path = sys.argv[1]

    # Parse optional --categories flag
    requested_categories = None
    if "--categories" in sys.argv:
        idx = sys.argv.index("--categories")
        if idx + 1 < len(sys.argv):
            requested_categories = sys.argv[idx + 1].split(",")

    with open(checks_path) as f:
        data = json.load(f)

    categories = data.get("categories", {})
    category_scores = {}

    for cat_name, cat_data in categories.items():
        checks = cat_data.get("checks", [])
        category_scores[cat_name] = score_category(checks)

    overall = score_overall(category_scores, requested_categories)

    result = {
        "domain": data.get("domain", "unknown"),
        "categories": category_scores,
        "overall": overall,
    }

    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
