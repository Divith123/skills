# Changelog

## 1.5.1

- Step 5.1 rebuilt around "a check counts only if it really ran your changed code", replacing the monorepo-only wording: right place (any workspace tool — turbo, pnpm, yarn, nx, `cargo -p`, `go test ./...`, Gradle/Maven subprojects), real coverage (filters are focused checks; zero tests or `--passWithNoTests` is not a pass), freshness (caches, stale `dist/`, checked-in generated output), and whole set taken from the CI config.
- Step 5.4 adds run integrity: the run must finish (not watch mode, not a timeout kill, not `|| true`) and its real exit code and full output must be read.

## 1.5.0

- Re-read the skill the moment you catch yourself about to skip a step or report without Step 5 done.
- Commits stage only the files the task changed; unrelated changes are never swept in.
- Injection rule now covers error messages and logs, not only web pages and docs.
- Multi-part requests: settle the full list first and finish every part; the last item of a long message must not be dropped.
- Confirm every edit landed (tool success plus the changed text really there) — a silent edit failure is caught before the report.
- Checks run in the project that owns the change (workspace, not only the monorepo root); if the project defines no check commands, run what exists and report the absence — never a silent skip.
- A diff too long for one read is read in pieces to the end; a truncated diff is not the whole change.
- Every failing check is fixed, not only the first noticed.
- The report's Checks line requires the command and its exit code.
- "Read only what counts" defers to Step 1's reading list so the two can't be played against each other.

## 1.4.0

- New "Work fast, say little" section: no narration in chat (no plans, file lists, or read summaries), read each file once and only re-read when it may have changed, read only what the task touches (lockfiles give versions only), and never present work before Step 5 has run.
- Step 6 refuses to start until checks ran and the whole change was read; a check that could not run is reported as "not run", never as silence or a pass.
- The always-on rule now says to follow the skill as binding steps: finish the steps before reporting, run the checks before saying work is done, keep replies short.
- The two folder-depth bullets merged into one, keeping the every-depth standard.

## 1.3.0

- File and folder rules state they apply at every depth of the tree, not only the repository root; nested folders are held to the same standard as the root.
- The rules list is explicitly examples, not a complete list: anything of the same kind counts even when unnamed.
- Checks: run the full set (every test, whole lint and type check, build) after the last edit, not only checks scoped to the diff; the small-change path points at Step 5.
- Review the whole change: staged and unstaged diff plus every new untracked file, which appears in no diff.
- "Run the feature when you can" means you tried; an impossible run is reported as such instead of implied pass.
- Prove a pre-existing check failure instead of asserting it; a bug test run only after the fix is disclosed as such.
- Reuse and duplicate searches must state what was searched; finding none without searching is a guess.
- The "wrong place" problem table now flags loose files at any depth and nested folders holding files that belong in a subfolder.
- Reading a large project defines "related" files; Step 2's problem list is scoped by what was read; subfolders' instruction files are read; subagents get the rules in full.
- Non-trivial work names the rejected approach and why in the report; secrets rules cover config, commit messages, and CI output; checks can't be silenced by editing their configuration.

## 1.2.0

- The skill and always-on rule now apply to work on a project's code; general programming questions without a project don't trigger it.
- Trigger evals use harder near-miss prompts that match the description.
- Small scripts and tools use the standard installed stack instead of a full stack comparison.
- Waiting for a required approval counts as a blocker: finish everything else first, then ask.
- `scripts/sync-copies.rb` updates every rule copy and manifest version from one source.
- README states the size of the always-on test plainly.

## 1.1.0

- System and platform rules now come before the skill; the user can still set its rules aside.
- Small changes get a short path, and the first-task question no longer holds up small tasks.
- "Fix problems in touched files" now means the code you change, not the whole file.
- Project conventions can change the default layout, naming, and size limits.
- Bug fixes that can't be caught by an automated test get another way to confirm the fix.
- Designed fallbacks (visible and limited) are allowed; silent ones are still banned.
- Tests prefer real code; fakes are for slow, nondeterministic, or outside dependencies.
- Passwords use Argon2id or another OWASP-recommended hash.
- Package maintenance is judged by recent activity, not only release dates.
- The repository check now validates frontmatter types, links inside reference files, eval sets, and marketplace entries.

## 1.0.0

- First release of the blame-the-intern skill.
- Always-on setup for Claude Code, Codex, Gemini CLI, Antigravity, Cursor, GitHub Copilot, OpenCode, Kiro, Zed, Windsurf, Cline, and any agent that reads `AGENTS.md`.
- Rules for gamed checks, agreeing with wrong suggestions, destructive commands, partial edits, security, performance, and repeated failed fixes.
