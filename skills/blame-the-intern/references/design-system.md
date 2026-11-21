# Design system

Use this for any visual work: web, mobile, and desktop apps, and also emails, documents, charts, terminal output, or anything else with colors, fonts, or layout.

## Before you build anything visual

1. **Find the existing design system:** tokens (colors, fonts, font sizes, spacing, radius, shadows, motion, breakpoints), the theme, and the shared components. Search before you build.
2. **Reuse the existing component.** If it lacks what you need, add a variant to it. Never create a second button, input, dialog, card, or icon set.
3. **Add missing pieces to the design system first.** If an element will be reused and the design system doesn't have it, add it there, then use it.

## If there is no design system

Create the minimum in one place, using the platform's own theming method (CSS variables, a theme provider, a theme file, asset catalogs):

- a token file: raw values first, then names by purpose (`color-text-muted`, `color-action-primary`)
- a theme built from those tokens (light and dark, if the project needs both)
- the shared components the current task needs
- a component gallery or stories, if the stack supports one

If components are already scattered across the project, move them into this place and point every screen at them, a few at a time ([fixing-existing-code.md](fixing-existing-code.md)).

## Rules for every visual change

- Components and screens use purpose-named tokens only. No raw colors, pixel sizes, or font names outside the token files.
- When you replace a hardcoded value with a token, keep the exact value: reuse a token with the same value, or add one. Don't swap in a similar token that changes how the screen looks unless the user asks.
- Define the brand once: name, logo, colors, and fonts. A rebrand should touch only the token and brand files.
- Every interactive component handles hover, focus, pressed, disabled, loading, and error states.
- Every component works with the keyboard, has labels for screen readers, and meets contrast rules (WCAG 2.2 AA on the web, the platform's accessibility guidelines elsewhere).
- Look at the result when you can: screenshots, previews, or simulators.
