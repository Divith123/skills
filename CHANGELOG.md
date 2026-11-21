# Changelog

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
