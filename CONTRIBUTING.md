# Contributing

Thanks for helping. Issues and pull requests are welcome.

## Layout

| Path | What it is |
| --- | --- |
| `skills/<name>/SKILL.md` | One skill. The folder name must match the `name` in its frontmatter |
| `skills/<name>/references/` | Files the skill tells the agent to read at a given step |
| `evals/trigger-queries.json` | Prompts that should and shouldn't load the skill |
| `rules/AGENTS.md` | The always-on rule. Edit it here only; the check makes every copy match it |
| `rules/blame-the-intern.mdc`, `adapters/` | The same rule in the format Cursor, Kiro, and Windsurf expect |
| `hooks/hooks.json` | The session-start reminder used by the Claude Code, Codex, and Copilot plugins |
| `plugin.json`, `.claude-plugin/`, `.cursor-plugin/`, `.antigravity-plugin/`, `.agents/plugins/`, `gemini-extension.json`, `GEMINI.md` | Plugin and extension manifests, one per agent, all at the same version |
| `CHANGELOG.md` | One entry per version |
| `scripts/check-skills.rb` | The repository check |

## Before you open a pull request

1. Turn on the pre-push hook once, so the check runs before every push:

   ```sh
   git config core.hooksPath .githooks
   ```

2. Run the check yourself (Ruby 2.6 or later, no gems needed):

   ```sh
   ruby scripts/check-skills.rb
   ```

   It checks the frontmatter against the [Agent Skills spec](https://agentskills.io/specification), the 500-line limit, every reference link, and the eval and plugin files.

3. If you changed a skill's `description`, run the trigger evals in `evals/` (see the README) and include the results in the pull request.
4. If you change the version, change it in every manifest and add a `CHANGELOG.md` entry. The check fails otherwise.
5. If you changed a rule, say which agent mistake it prevents. If you can, show a before and after run on a real task.

## Writing style

Skills are read by agents, so keep them short and literal:

- one rule per line, in plain words, in the order the agent works
- no stack, framework, or project names in rules that apply to every project
- every reference file linked from `SKILL.md`, with a line saying when to read it
- `SKILL.md` under 500 lines

## Security

Skills must not run scripts or make network calls on their own. If you find a security problem, open an issue without exploit details, and the maintainer will follow up.
