# Skills

[Agent Skills](https://agentskills.io) by Divith S. They work with Claude Code, Codex, Cursor, GitHub Copilot, OpenCode, Kiro, and any other agent that supports the open standard.

| Skill | What it does |
| --- | --- |
| [blame-the-intern](skills/blame-the-intern/SKILL.md) ([skills.sh](https://www.skills.sh/divith123/skills/blame-the-intern)) | Makes your coding agent work like a careful senior developer on every project, in any language, framework, or platform |

## blame-the-intern

Coding agents often start writing before they understand the project. They rebuild components that already exist, pile files into one folder, write ten comments for one line, use APIs from old training data, fake data with mocks, hide errors with fallbacks, and then call the work "production-ready". This skill gives the agent one way of working that prevents those mistakes, for web, mobile, desktop, backend, libraries, scripts, and monorepos alike.

The name is a joke. The skill judges code, not people.

### How the agent works with it

| Step | What the agent does |
| --- | --- |
| 1. Understand the project | Reads the README, instructions, config, installed versions, folder structure, conventions, and every file the task touches, before writing any code |
| 2. Ask about existing problems | On the first task in an existing project, lists the problems it found and asks: fix all now, fix only in the files each task touches, or leave them |
| 3. Do the task | Follows a set path for bug fixes, features, UI changes, packages, refactors, and questions, and compares approaches before picking one |
| 4. Write the code | Reuses before adding, changes as little as possible, keeps one place for each rule, organizes files by feature, writes real code with no mocks or hidden fallbacks |
| 5. Check its work | Runs format, lint, type checks, tests, and build; runs the feature; reads its own diff |
| 6. Report | Says briefly what changed, which files, which checks passed, failed, or didn't run, and what's left |

### Works at any stage

| Your situation | What the skill does |
| --- | --- |
| Empty folder, no stack yet | Researches current stacks, proposes two or three, and sets up a clean structure from day one: feature folders, a design system, lint, tests |
| Stack chosen, little code | Follows the project's setup and keeps it clean as it grows |
| Large existing project, maybe already messy | Reads the structure first, lists existing problems, and asks before fixing anything, so working features don't break |

### Files

| File | When the agent reads it |
| --- | --- |
| [`SKILL.md`](skills/blame-the-intern/SKILL.md) | On every coding task: the rules, the six steps, and the coding standards |
| [`references/new-project.md`](skills/blame-the-intern/references/new-project.md) | When there's no project or stack yet |
| [`references/fixing-existing-code.md`](skills/blame-the-intern/references/fixing-existing-code.md) | For refactors, cleanups, or fixing existing problems |
| [`references/design-system.md`](skills/blame-the-intern/references/design-system.md) | For any visual change |
| [`references/research-and-packages.md`](skills/blame-the-intern/references/research-and-packages.md) | Before using a library or API, and before suggesting a package |

The skill itself has no scripts, makes no network calls, and needs no extra permissions. The plugins add one session-start hook that prints a short reminder (see [`hooks/hooks.json`](hooks/hooks.json)). Read the files before installing; they're short.

## Install

Agents load a skill only when they decide a task needs it, and they sometimes skip it. So each install below has two parts: the skill, and a short always-on rule ([`rules/AGENTS.md`](rules/AGENTS.md)) that tells the agent to load the skill for every coding task. Where an agent has a plugin or extension, it installs both at once.

```sh
RAW="https://raw.githubusercontent.com/Divith123/skills/main"
```

| Agent | Install | Always-on rule |
| --- | --- | --- |
| Claude Code | `/plugin marketplace add Divith123/skills`, then `/plugin install blame-the-intern@divith-skills` | Included: a session-start hook |
| Codex | `codex plugin marketplace add Divith123/skills`, then `codex plugin add blame-the-intern@divith-skills` | `curl -fsSL $RAW/rules/AGENTS.md >> ~/.codex/AGENTS.md` (the plugin hook runs only in the Codex desktop app, after you trust it) |
| Gemini CLI | `gemini extensions install https://github.com/Divith123/skills` | Included: the extension's context file |
| Antigravity | `agy plugin install https://github.com/Divith123/skills` | Included: the plugin's always-on rule |
| Cursor | `git clone https://github.com/Divith123/skills ~/.cursor/plugins/local/blame-the-intern`, then reload Cursor | Included: an always-apply rule. For one project instead, copy [`adapters/cursor/blame-the-intern.mdc`](adapters/cursor/blame-the-intern.mdc) into `.cursor/rules/` |
| GitHub Copilot CLI | `copilot plugin marketplace add Divith123/skills`, then `copilot plugin install blame-the-intern@divith-skills` | `curl -fsSL $RAW/rules/AGENTS.md >> ~/.copilot/copilot-instructions.md` |
| GitHub Copilot in VS Code | `npx skills add Divith123/skills --skill blame-the-intern -a github-copilot` | Add the text of `rules/AGENTS.md` to `.github/copilot-instructions.md` |
| OpenCode | `npx skills add Divith123/skills --skill blame-the-intern -a opencode -g` | `curl -fsSL $RAW/rules/AGENTS.md >> ~/.config/opencode/AGENTS.md` |
| Kiro | `npx skills add Divith123/skills --skill blame-the-intern -a kiro-cli -g` | `mkdir -p ~/.kiro/steering && curl -fsSL $RAW/adapters/kiro/blame-the-intern.md -o ~/.kiro/steering/blame-the-intern.md` |
| Zed | `npx skills add Divith123/skills --skill blame-the-intern -a zed -g` | `curl -fsSL $RAW/rules/AGENTS.md >> ~/.config/zed/AGENTS.md` (Windows: `%APPDATA%\Zed\AGENTS.md`) |
| Windsurf / Devin | `npx skills add Divith123/skills --skill blame-the-intern -a windsurf -g` | `mkdir -p ~/.devin/rules && curl -fsSL $RAW/adapters/windsurf/blame-the-intern.md -o ~/.devin/rules/blame-the-intern.md` |
| Cline | `npx skills add Divith123/skills --skill blame-the-intern -a cline -g` | `curl -fsSL $RAW/rules/AGENTS.md -o ~/Documents/Cline/Rules/blame-the-intern.md` |
| Any other agent | `npx skills add Divith123/skills --skill blame-the-intern` and pick your agent | Add the text of `rules/AGENTS.md` to the agent's global instructions file, or to `AGENTS.md` in your project |

Set `RAW` in your shell first, or paste the full URL. The `>>` commands append to your existing file, so nothing you already have is lost.

Every rule file contains the same text, and the repository check fails if any copy drifts. In tests on this machine, the always-on rule changed how often the agent loaded the skill on coding tasks from 0 of 3 to 3 of 3 in Kiro, and from 1 of 3 to 3 of 3 in OpenCode. The other rows follow each agent's current documentation and haven't been run here.

To install only the skill by hand, copy `skills/blame-the-intern/` into your agent's skills folder and keep the folder name.

## Use

Ask for any coding task as usual. You can also call the skill by name: `/blame-the-intern` in Claude Code, Cursor, Copilot, and Kiro, `$blame-the-intern` in Codex, or `@blame-the-intern` in OpenCode.

To turn it off for one task, say so in your message. The skill tells the agent that only you can set its rules aside.

## Development

`ruby scripts/check-skills.rb` checks every skill against the [Agent Skills spec](https://agentskills.io/specification): the frontmatter, the 500-line limit, every reference link, and the eval and plugin files. Run `git config core.hooksPath .githooks` once to run it before every push. The same check runs in GitHub Actions on pushes and pull requests. See [CONTRIBUTING.md](CONTRIBUTING.md).

`evals/blame-the-intern.json` holds 20 prompts: 10 coding tasks that should load the skill and 10 non-coding requests that shouldn't. It uses the format of Anthropic's [skill-creator](https://github.com/anthropics/skills/tree/main/skills/skill-creator). With Claude Code installed, run this from the skill-creator folder after changing the `description`:

```sh
python -m scripts.run_eval --eval-set /path/to/skills/evals/blame-the-intern.json --skill-path /path/to/skills/skills/blame-the-intern
```

## License

[MIT](LICENSE)
