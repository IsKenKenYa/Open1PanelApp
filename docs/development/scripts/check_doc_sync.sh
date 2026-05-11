#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"

DOCS=(
  "$REPO_ROOT/AGENTS.md"
  "$REPO_ROOT/CLAUDE.md"
  "$REPO_ROOT/.kiro/steering/development_workflow.md"
  "$REPO_ROOT/.kiro/steering/functional_test_rules.md"
  "$REPO_ROOT/docs/development/cross_platform_ui_governance.md"
)

THRESHOLD_DAYS=1
THRESHOLD_SECONDS=$((THRESHOLD_DAYS * 86400))

now=$(date +%s)
newest_mtime=0
newest_file=""

for doc in "${DOCS[@]}"; do
  if [ ! -f "$doc" ]; then
    echo "::error::Required doc not found: $doc"
    echo "MISSING: $doc"
    exit 1
  fi
  mtime=$(stat -f %m "$doc" 2>/dev/null || stat -c %Y "$doc" 2>/dev/null)
  if [ "$mtime" -gt "$newest_mtime" ]; then
    newest_mtime=$mtime
    newest_file="$doc"
  fi
done

out_of_sync=()
for doc in "${DOCS[@]}"; do
  mtime=$(stat -f %m "$doc" 2>/dev/null || stat -c %Y "$doc" 2>/dev/null)
  diff_seconds=$((newest_mtime - mtime))
  if [ "$diff_seconds" -gt "$THRESHOLD_SECONDS" ]; then
    diff_days=$((diff_seconds / 86400))
    out_of_sync+=("$doc (last modified $diff_days day(s) before $newest_file)")
  fi
done

if [ ${#out_of_sync[@]} -eq 0 ]; then
  echo "All docs are in sync."
  exit 0
fi

echo "::warning::The following docs are out of sync with $newest_file:"
echo ""
for doc in "${out_of_sync[@]}"; do
  echo "  - $doc"
done
echo ""
echo "Please update the outdated docs to reflect the latest changes."
exit 1
