# AGENTS.md

Follow the blame-the-intern skill (`skills/blame-the-intern/SKILL.md`) for every task in this repository unless the user says otherwise.

## Layout

- `skills/<name>/`: one folder per skill. Each skill's always-on rule copies live in `rules/` and `adapters/<agent>/`.
- Plugin manifests for each agent sit at the root and in `.claude-plugin/`, `.cursor-plugin/`, `.antigravity-plugin/`, and `.agents/plugins/`. They share one version.
- `evals/<name>.json`: trigger prompts for the skill with that name.

## Commands

- Check everything: `ruby scripts/check-skills.rb`
- Run the check before every push: `git config core.hooksPath .githooks`

## Rules for this repo

- Edit the always-on rule only in `rules/AGENTS.md`, and the version only in `plugin.json`. Then run `ruby scripts/sync-copies.rb` to update every copy. The check fails if any copy differs.
- Add a `CHANGELOG.md` entry for each new version.
- Never commit `research/` or `problems/`; they are git-ignored on purpose.
