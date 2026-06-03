#!/usr/bin/env bash
# Audit script: 检查 lib/ 目录中是否残留 print() / debugPrint() / stdout.writeln()。
#
# 这些调用应统一通过 appLogger 输出，本脚本作为 CI 与手动审计的兜底。
#
# 用法：
#   bash tool/audit_no_print.sh
#
# 退出码：
#   0 - 无违规
#   1 - 发现违规
#   2 - 工具异常

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

TARGET_DIRS=("lib")
EXCLUDE_PATTERN="(generated|\.g\.dart|\.freezed\.dart)"

# 1) 静态分析（avoid_print 规则）
echo "==> flutter analyze (avoid_print)"
if flutter analyze "${TARGET_DIRS[@]}" 2>&1 | grep -E "avoid_print|debugPrint" > /tmp/audit_print.txt; then
  if [[ -s /tmp/audit_print.txt ]]; then
    echo "❌ Found print/debugPrint usage:"
    cat /tmp/audit_print.txt
    exit 1
  fi
fi

# 2) 兜底 grep（防止某些调用绕过 lint，例如 string 拼接）
echo "==> grep audit (raw patterns)"
RAW_HITS=$(grep -RInE "^\s*print\s*\(|\bdebugPrint\s*\(|\bstdout\.writeln\s*\(" \
  --include="*.dart" "${TARGET_DIRS[@]}" 2>/dev/null \
  | grep -vE "$EXCLUDE_PATTERN" || true)
if [[ -n "$RAW_HITS" ]]; then
  echo "❌ Found raw print/debugPrint/stdout.writeln:"
  echo "$RAW_HITS"
  exit 1
fi

echo "✅ No print/debugPrint/stdout.writeln found in ${TARGET_DIRS[*]}"
exit 0
