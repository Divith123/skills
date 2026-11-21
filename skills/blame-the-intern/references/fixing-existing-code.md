# Fixing existing code

Use this for a refactor or cleanup, or when the user chose to fix all existing problems.

## 1. Find the problems first

Don't change anything yet. Write down each problem with its file and line, what goes wrong because of it, and its cause.

| Problem | Signs |
| --- | --- |
| Duplicates | The same logic, validation, constants, or UI in several places; several versions of one component |
| Wrong place | A feature spread across root folders; piles of loose files at the top of a folder; feature folders with dozens of loose files |
| Too big | Files over 400 lines or functions over 50 lines that mix responsibilities |
| Bad names | `utils`, `misc`, `temp`, `final`, `v2`; different names for the same concept |
| Unneeded code | Dead code; unused exports, flags, and settings; layers that only pass calls along; features nobody uses |
| Fake or hidden behavior | Mocks, placeholders, and TODO stubs in real code; fallbacks that hide errors |
| Noise comments | Comments that repeat the code, change history, banners, commented-out code, comments that are now wrong |
| Hardcoded UI | Raw colors, fonts, and sizes instead of design tokens |
| Weak tests | Tests that check nothing real; important logic or past bugs with no test |
| Outdated code | Deprecated APIs or patterns for the installed versions |

Before calling code unused, prove nothing uses it: search for dynamic imports, string references, config, reflection, and outside users.

Some odd code is there on purpose, such as a retry for a flaky API or a workaround for a library bug. Find the reason before removing it. If it's needed, keep it and add a one-line comment saying why.

## 2. Plan

Group the problems by cause. Put the riskiest first (wrong results, security holes). Show the user the list and the plan. In a large project, fix the groups the user picks, a few at a time, not everything at once.

## 3. Fix one group at a time

1. If the code you'll change has no tests, first add tests that capture how it behaves now.
2. Change one group only.
3. Update everything that refers to what you moved or renamed: imports, exports, routes, tests, config, and docs. Search for the old names, including inside strings.
4. Run the checks. Behavior must stay the same. Fix any new failure before starting the next group.
5. Don't mix in unrelated changes, reformatting, or upgrades.

If two copies of a rule disagree, merging them changes behavior, so ask the user which one is right. To change a public API, ask first, then add the new version, move the callers to it, and remove the old one last.

## 4. Report

Use the report from SKILL.md, Step 6. List the problems you didn't fix, and why.
