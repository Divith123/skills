# Skills

[Agent Skills](https://agentskills.io) by Divith S. They work with Claude Code, Codex, Cursor, GitHub Copilot, OpenCode, Kiro, and any other agent that supports the open standard.

| Skill | What it does |
| --- | --- |
| [blame-the-intern](skills/blame-the-intern/SKILL.md) | Makes your coding agent work like a careful senior developer on every project, in any language, framework, or platform |

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

The skill itself has no scripts, makes no network calls, and needs no extra permissions. The Claude Code plugin adds one hook that prints a reminder at session start (see [`hooks/hooks.json`](hooks/hooks.json)). Read the files before installing; they're short.

## Install

With the [skills CLI](https://github.com/vercel-labs/skills), for most agents:

```sh
npx skills add Divith123/skills --skill blame-the-intern       # this project
npx skills add Divith123/skills --skill blame-the-intern -g    # all your projects
```

As a Claude Code plugin, which also adds the session-start reminder:

```text
/plugin marketplace add Divith123/skills
/plugin install blame-the-intern@divith-skills
```

By hand: copy `skills/blame-the-intern/` into your agent's skills folder and keep the folder name.

| Agent | All projects | One project |
| --- | --- | --- |
| Claude Code | `~/.claude/skills/` | `.claude/skills/` |
| Codex | `~/.agents/skills/` | `.agents/skills/` |
| Cursor | `~/.cursor/skills/` | `.cursor/skills/` or `.agents/skills/` |
| GitHub Copilot | `~/.copilot/skills/` or `~/.agents/skills/` | `.github/skills/`, `.claude/skills/`, or `.agents/skills/` |
| OpenCode | `~/.config/opencode/skills/` | `.opencode/skills/` |
| Kiro | `~/.kiro/skills/` | `.kiro/skills/` |

## Use it on every task

Agents decide on their own when to load a skill, and sometimes they skip it. To make the agent follow it on every task, add this line to your project's `AGENTS.md` (or `CLAUDE.md`, which Claude Code reads instead when both exist):

```md
Follow the blame-the-intern skill for every coding task unless I say otherwise.
```

You can also call it by name: `/blame-the-intern` in Claude Code, Cursor, Copilot, and Kiro, `$blame-the-intern` in Codex, or `@blame-the-intern` in OpenCode.

To turn it off for one task, say so in your message. The skill tells the agent that only you can set its rules aside.

## Development

`ruby scripts/check-skills.rb` checks every skill against the [Agent Skills spec](https://agentskills.io/specification): the frontmatter, the 500-line limit, every reference link, and the eval and plugin files. CI runs it on every push and pull request.

`evals/trigger-queries.json` holds 20 prompts: 10 coding tasks that should load the skill and 10 non-coding requests that shouldn't. It uses the format of Anthropic's [skill-creator](https://github.com/anthropics/skills/tree/main/skills/skill-creator). With Claude Code installed, run this from the skill-creator folder after changing the `description`:

```sh
python -m scripts.run_eval --eval-set /path/to/skills/evals/trigger-queries.json --skill-path /path/to/skills/skills/blame-the-intern
```

## License

[MIT](LICENSE)
