#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPORTS_DIR="${SCRIPT_DIR}/reports"
DATE_STAMP="$(date +%Y%m%d)"
TIMESTAMP="$(date +%Y-%m-%dT%H:%M:%S)"

mkdir -p "${REPORTS_DIR}"

COVERAGE_REPORT="${REPORTS_DIR}/coverage_${DATE_STAMP}.json"
UPDATES_REPORT="${REPORTS_DIR}/updates_${DATE_STAMP}.json"

echo "========================================"
echo " API Daily Inspection"
echo " Timestamp: ${TIMESTAMP}"
echo "========================================"
echo ""

echo "[1/2] Running coverage check..."
cd "${SCRIPT_DIR}"
python3 check_module_client_coverage.py --all --json > "${COVERAGE_REPORT}" 2>&1 || true
echo "  Report saved: ${COVERAGE_REPORT}"
echo ""

echo "[2/2] Running update check..."
python3 check_module_api_updates.py --all --json > "${UPDATES_REPORT}" 2>&1 || true
echo "  Report saved: ${UPDATES_REPORT}"
echo ""

echo "========================================"
echo " Summary"
echo "========================================"

if command -v python3 &>/dev/null; then
  python3 - "${COVERAGE_REPORT}" "${UPDATES_REPORT}" <<'PYEOF'
import json
import sys

def summarize_coverage(path):
    try:
        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except (json.JSONDecodeError, FileNotFoundError):
        print("  Coverage report: unable to parse")
        return {"aligned": 0, "missing_in_client": 0, "extra_in_client": 0, "other": 0}

    aligned = 0
    missing = 0
    extra = 0
    other = 0
    for item in data.get("results", []):
        status = item.get("status", "")
        if status == "aligned":
            aligned += 1
        elif status == "missing_in_client":
            missing += 1
        elif status == "extra_in_client":
            extra += 1
        else:
            other += 1

    print(f"  Coverage: {aligned} aligned | {missing} missing_in_client | {extra} extra_in_client | {other} other")
    if missing > 0:
        modules = [item["module"] for item in data.get("results", []) if item.get("status") == "missing_in_client"]
        print(f"  BLOCKING - missing_in_client modules: {', '.join(modules)}")
    return {"aligned": aligned, "missing_in_client": missing, "extra_in_client": extra, "other": other}

def summarize_updates(path):
    try:
        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except (json.JSONDecodeError, FileNotFoundError):
        print("  Updates report: unable to parse")
        return {"unchanged": 0, "updated": 0, "missing_baseline": 0}

    unchanged = 0
    updated = 0
    missing_baseline = 0
    for item in data.get("results", []):
        status = item.get("status", "")
        if status == "unchanged":
            unchanged += 1
        elif status == "updated":
            updated += 1
        elif status == "missing_baseline":
            missing_baseline += 1

    print(f"  Updates:  {unchanged} unchanged | {updated} updated | {missing_baseline} missing_baseline")
    if updated > 0:
        modules = [item["module"] for item in data.get("results", []) if item.get("status") == "updated"]
        print(f"  ACTION - updated modules (re-run analyze_module_api.py): {', '.join(modules)}")
    if missing_baseline > 0:
        modules = [item["module"] for item in data.get("results", []) if item.get("status") == "missing_baseline"]
        print(f"  ACTION - missing baseline modules (run analyze_module_api.py): {', '.join(modules)}")
    return {"unchanged": unchanged, "updated": updated, "missing_baseline": missing_baseline}

cov_path = sys.argv[1]
upd_path = sys.argv[2]

print("")
cov = summarize_coverage(cov_path)
print("")
upd = summarize_updates(upd_path)

has_blocking = cov["missing_in_client"] > 0
has_action = upd["updated"] > 0 or upd["missing_baseline"] > 0

print("")
if has_blocking or has_action:
    print("  Result: INSPECTION REQUIRES ACTION")
    sys.exit(1)
else:
    print("  Result: ALL CLEAR")
    sys.exit(0)
PYEOF
else
  echo "  python3 not found, skipping summary generation"
  echo "  Result: UNKNOWN (check reports manually)"
fi

find "${REPORTS_DIR}" -name "*.json" -mtime +30 -delete 2>/dev/null || true

echo ""
echo "Reports directory: ${REPORTS_DIR}"
echo "Done."
