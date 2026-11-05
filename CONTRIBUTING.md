# Contributing

Improvements are welcome: new emotion mappings, platform syntax updates, better examples, installer support for more agents.

## How to contribute

1. **Fork** this repository (button at the top right on GitHub).
2. **Create a branch**: `git checkout -b improve-<topic>`
3. **Make your change.** The skill lives in `plugins/visual-prompt-engine/skills/visual-prompt-engine/`.
4. **Test locally**: run `./install.sh --project` (macOS/Linux) or `.\install.ps1 -Project` (Windows) in a test folder and try a prompt.
5. **Open a pull request** with a before/after prompt example if you changed the skill's behaviour.

## Rules

- Keep `SKILL.md` under 500 lines; long tables belong in `references/`.
- Keep the skill folder name and the `name:` field in `SKILL.md` identical.
- For a release, bump the version in **both** `plugin.json` and `marketplace.json` and add an entry to `CHANGELOG.md`. The Validate check fails if the versions differ.
- Do not add content you don't have the right to publish.
