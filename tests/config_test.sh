#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
packages=$(nix eval --no-write-lock-file --json \
  "$root#darwinConfigurations.mbp16.config.environment.systemPackages" \
  --apply 'map (pkg: { pname = pkg.pname or ""; version = pkg.version or ""; })')
casks=$(nix eval --no-write-lock-file --json \
  "$root#darwinConfigurations.mbp16.config.homebrew.casks")

jq -e '
  any(.[]; .pname == "nodejs" and (.version | startswith("24."))) and
  any(.[]; .pname == "password-store") and
  any(.[]; .pname == "ruff") and
  any(.[]; .pname == "uv") and
  all(.[]; (.pname | ascii_downcase) as $name | ["eza", "shellcheck"] | index($name) == null)
' <<<"$packages" >/dev/null
jq -e 'all(.[]; .name != "mactex")' <<<"$casks" >/dev/null

echo "nix-darwin config test: PASS"
