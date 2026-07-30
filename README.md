# Pink Matter basic usability standard

A small, versioned, public baseline for Pink Matter Macs.

Current standard (v1):

- macOS / Karabiner-Elements: **Caps Lock → Left Control**

## Install

Review the repository, then run:

```sh
git clone https://github.com/Exr0n/config-standard.git
cd config-standard
./install.sh
```

The installer:

- changes only the selected Karabiner profile;
- removes only conflicting Caps Lock source mappings in that profile;
- preserves unrelated and device-specific mappings;
- validates the resulting JSON; and
- writes a timestamped backup under
  `~/Library/Application Support/PinkMatterStandard/backups/`.

For delegated installation, give a coding agent
[`AGENT-INSTRUCTIONS.md`](AGENT-INSTRUCTIONS.md).

## Scope

Only broadly applicable Pink Matter usability settings belong here. Personal
machine behavior, credentials, host aliases, and private infrastructure do not.

## License

MIT
