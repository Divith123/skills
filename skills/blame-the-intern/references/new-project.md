# New project

Use this when the folder is empty or the user hasn't chosen a stack yet. For a small script or tool, skip to step 4 with the standard choice that is already installed, and say why.

1. **Ask what they're building** if it isn't clear: what it does, who uses it, where it runs (web, mobile, desktop, server, command line), and any must-haves (offline use, scale, budget, the team's skills).
2. **Research current options.** Your training data is out of date. Search the web for the current recommended stacks for this kind of project. For each candidate, check its latest stable version, recent releases, license, and adoption on its official site and package registry.
3. **Propose two or three stacks** in a short table: what each is good at, its trade-offs, and its latest stable version. Recommend one and say why. Wait for the user's choice. If you can't ask (a non-interactive run), still do the research and the comparison, use your recommendation (prefer one that needs no new installs when the request allows it), and put the comparison table in the report.
4. **Create the project with the official tool** for the chosen version (for example the framework's own `create` command), following its current docs. Ask before running installers.
5. **Set up the structure from the start:**
   - feature folders from the first feature (SKILL.md, Step 4)
   - one place for the design system: tokens, theme, and shared components ([design-system.md](design-system.md))
   - format, lint, and type-check tools, with scripts to run them
   - a test setup, with tests placed the way the stack recommends
   - a short AGENTS.md with the commands, the folder layout, and this line: "Follow the blame-the-intern skill for every coding task unless the user says otherwise."
6. **Build what the user asked for,** following SKILL.md from Step 3.
