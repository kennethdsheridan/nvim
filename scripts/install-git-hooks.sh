#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"

git config core.hooksPath "$repo_root/.githooks"
chmod +x "$repo_root/.githooks/pre-push"

echo "Configured git hooks path: $repo_root/.githooks"
echo "Enabled pre-push hook: .githooks/pre-push"
