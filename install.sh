#!/usr/bin/env bash
# Apply the portable Pink Matter usability baseline without replacing unrelated
# personal Karabiner settings.
set -euo pipefail

config_path="${KARABINER_CONFIG_PATH:-$HOME/.config/karabiner/karabiner.json}"
backup_root="${PINK_MATTER_STANDARD_BACKUP_DIR:-$HOME/Library/Application Support/PinkMatterStandard/backups}"

if ! command -v jq >/dev/null 2>&1; then
  printf '%s\n' "jq is required. Install it with: brew install jq" >&2
  exit 69
fi

if [[ ! -f "$config_path" ]]; then
  printf '%s\n' \
    "Karabiner config not found at: $config_path" \
    "Install and open Karabiner-Elements once, then rerun this installer." >&2
  exit 66
fi

if ! jq -e \
  '(.profiles // []) | any(.selected == true)' \
  "$config_path" >/dev/null; then
  printf '%s\n' "Karabiner config has no selected profile; refusing to guess." >&2
  exit 65
fi

install -d -m 700 "$backup_root"
timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
backup_path="$(mktemp "$backup_root/karabiner.json.$timestamp.XXXXXX")"
cp -p "$config_path" "$backup_path"

config_dir="$(dirname "$config_path")"
temp_path="$(mktemp "$config_dir/.pink-matter-karabiner.XXXXXX")"
cleanup() {
  [[ ! -e "$temp_path" ]] || rm -f "$temp_path"
}
trap cleanup EXIT

jq '
  (.profiles[] | select(.selected == true) | .simple_modifications) |=
    (
      (. // [])
      | map(select(.from.key_code? != "caps_lock"))
      + [
          {
            "from": {"key_code": "caps_lock"},
            "to": [{"key_code": "left_control"}]
          }
        ]
    )
' "$config_path" > "$temp_path"

jq empty "$temp_path"
chmod "$(stat -f '%Lp' "$config_path")" "$temp_path"
mv "$temp_path" "$config_path"

printf '%s\n' \
  "Applied Pink Matter standard v1: Caps Lock -> Left Control." \
  "Preserved all unrelated Karabiner mappings." \
  "Backup: $backup_path"
