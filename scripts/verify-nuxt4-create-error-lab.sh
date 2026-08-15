#!/usr/bin/env bash
set -euo pipefail

project_root="${1:-.}"
cd "$project_root"

required_files=(
  package.json
  package-lock.json
  tsconfig.test.json
  nuxt.config.ts
  app/app.vue
  server/api/tasks.patch.ts
  test/tasks-api.test.ts
  README.md
  SUMMARY.md
  DESIGN.md
  coverage-matrix.md
  fundamentals/README.md
  fundamentals/01-create-error-response.md
  docs/debugging-record.md
  docs/git-history.md
  docs/reference-notes.md
  docs/vscode-test-debugging.md
  .vscode/launch.json
  .vscode/tasks.json
)

for required_file in "${required_files[@]}"; do
  if [[ ! -s "$required_file" ]]; then
    echo "必要な教材ファイルがありません: $required_file" >&2
    exit 1
  fi
done

git diff --check
npm run typecheck
npm test
npm run build

echo "Nuxt 4サーバーAPI教材の基本検証に成功しました。"
