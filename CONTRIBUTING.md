# Contributing

Thanks for helping. Issues and pull requests are welcome.

## Layout

| Path | What it is |
| --- | --- |
| `skills/<name>/SKILL.md` | One skill. The folder name must match the `name` in its frontmatter |
| `skills/<name>/references/` | Files the skill tells the agent to read at a given step |
| `evals/trigger-queries.json` | Prompts that should and shouldn't load the skill |
| `hooks/hooks.json` | The Claude Code plugin's session-start reminder |
| `.claude-plugin/` | Claude Code plugin and marketplace manifests |
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
4. If you changed a rule, say which agent mistake it prevents. If you can, show a before and after run on a real task.

## Writing style

Skills are read by agents, so keep them short and literal:

- one rule per line, in plain words, in the order the agent works
- no stack, framework, or project names in rules that apply to every project
- every reference file linked from `SKILL.md`, with a line saying when to read it
- `SKILL.md` under 500 lines

## Security

Skills must not run scripts or make network calls on their own. If you find a security problem, open an issue without exploit details, and the maintainer will follow up.
