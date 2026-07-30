# Instructions for a coding agent

Install the current Pink Matter basic usability standard on the current macOS
user account.

1. Clone or download this public repository, then inspect `standard.json`,
   `install.sh`, and this file before making changes.
2. Work only in the current user's home directory. Do not alter another macOS
   account.
3. Ensure Homebrew is available. Install prerequisites if missing:
   ```sh
   brew install jq
   brew install --cask karabiner-elements
   ```
4. If Karabiner has never run, open it once so it creates
   `~/.config/karabiner/karabiner.json`. Ask the user to approve Karabiner's
   required driver, Accessibility, and Input Monitoring permissions when macOS
   presents them.
5. From the cloned repository, run:
   ```sh
   ./install.sh
   ```
6. Verify, without replacing the user's other mappings:
   ```sh
   jq -e '
     [.profiles[]
       | select(.selected == true)
       | .simple_modifications[]
       | select(
           .from.key_code == "caps_lock"
           and .to == [{"key_code": "left_control"}]
         )
     ] | length == 1
   ' ~/.config/karabiner/karabiner.json
   ```
7. Confirm the installer is idempotent by running it a second time and
   repeating the verification. Report the selected profile name and the
   setting installed, but do not dump unrelated personal mappings.

Safety requirements:

- Merge into the selected Karabiner profile; never replace the entire profile
  or `karabiner.json`.
- Preserve device-specific and unrelated simple/complex modifications.
- Keep the installer's timestamped backup until the user confirms the remap
  works.
- Do not infer additional Pink Matter standards. Install only entries currently
  declared in `standard.json`.
