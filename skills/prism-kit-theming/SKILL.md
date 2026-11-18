---
name: prism-kit-theming
description: >-
  Use when the user is theming or customizing prism_kit: PrismTokens,
  PrismColors, prismTheme(), token presets, or adaptive breakpoints. Ensures
  ThemeExtension registration, null-safe context accessors, and
  platform-adaptive token usage.
---

# Prism Kit Theming

## Guidelines

* Prefer `prismTheme(seed: ...)` over hand-building `ThemeData` — one call
  seeds the scheme, registers `PrismTokens`, and handles light/dark
  brightness in a single place. Pass `base:` to extend existing themes
  instead of replacing them.
* Access tokens and colors ONLY through the null-safe context extension:
  `context.prismTokens` and `context.prismColors`. They fall back to Prism
  defaults when tokens are not registered — never use `!` or manual null
  checks.
* Register custom tokens as a `ThemeExtension` on `ThemeData.extensions`:
  `extensions: const [PrismTokens(spaceMd: 20, radiusMd: 16)]`.
* Use semantic tokens, not raw numbers: `tokens.spaceMd`, `tokens.radiusLg`,
  `tokens.durationMedium`, `tokens.curveStandard`,
  `tokens.contentMaxWidth`, `tokens.controlHeight`. NEVER hardcode `16.0`,
  `Duration(milliseconds: 300)` or `BorderRadius.circular(12)` in component
  code.
* Pick presets with `PrismTokenPresets.preset(density:, shape:, motion:)`
  for quick personality changes (`PrismDensity`, `PrismShape`,
  `PrismMotion`).
* Use `tokens.breakpointCompact`/`breakpointExpanded` (or the
  `PrismBreakpoint.compact`/`medium`/`expanded` constants) for responsive
  decisions so components stay consistent on phone/desktop/web.
* Semantic colors from `context.prismColors` (e.g. `surfaceRaised`) always
  respect the current brightness — do not branch on `Brightness` manually
  for surfaces.

## Examples

### One-call app theming

```dart
MaterialApp(
  theme: prismTheme(seed: brandPurple),
  darkTheme: prismTheme(seed: brandPurple, brightness: Brightness.dark),
)
```

### Extending an existing theme

```dart
prismTheme(
  seed: Colors.teal,
  base: myTypographyTheme, // fonts/component themes survive
)
```

### Custom tokens

```dart
ThemeData(
  extensions: const [
    PrismTokens(spaceMd: 20, radiusMd: 16, contentMaxWidth: 800),
  ],
)
```

### Reading anywhere in the tree

```dart
Padding(
  padding: EdgeInsets.all(context.prismTokens.spaceMd),
  child: Container(
    decoration: BoxDecoration(
      color: context.prismColors.surfaceRaised,
      borderRadius: BorderRadius.circular(context.prismTokens.radiusMd),
    ),
  ),
)
```

### Responsive breakpoints

```dart
final tokens = context.prismTokens;
final isWide = MediaQuery.sizeOf(context).width >= tokens.breakpointExpanded;
```
