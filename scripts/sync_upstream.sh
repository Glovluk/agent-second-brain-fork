#!/usr/bin/env bash
set -euo pipefail

# Синхронизация форка с апстримом.
# Использование: scripts/sync_upstream.sh [branch]

BRANCH="${1:-main}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Ошибка: команда должна быть запущена внутри git-репозитория." >&2
  exit 1
fi

if ! git remote get-url upstream >/dev/null 2>&1; then
  echo "Ошибка: не найден remote 'upstream'. Сначала добавьте его." >&2
  exit 1
fi

git fetch upstream
git checkout "$BRANCH"
git merge --no-edit "upstream/$BRANCH"
git push origin "$BRANCH"

TAG="upstream-sync-$(date +%Y%m%d)"
git tag -a "$TAG" -m "Синхронизация с upstream/$BRANCH"
git push origin "$TAG"

echo "Готово: синхронизировано с upstream/$BRANCH и создан тег $TAG."
