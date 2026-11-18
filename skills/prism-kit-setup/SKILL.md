---
name: prism-kit-setup
description: >-
  Use when the user is adding prism_kit to a Flutter project, creating a first
  Prism-based screen, or wiring the design system into MaterialApp. Ensures
  correct imports (package:material_ui, not package:flutter/material.dart),
  token registration, and idiomatic component usage.
---

# Prism Kit Setup

## Guidelines

* ALWAYS import `package:material_ui/material_ui.dart` (Flutter 3.50+) instead
  of `package:flutter/material.dart`. prism_kit 2.1.0 targets the standalone
  design packages; `package:flutter/material.dart` is deprecated.
* Import the library with `import 'package:prism_kit/prism.dart';`.
* prism_kit components work with ZERO configuration out of the box. Do not
  force users to register tokens for a first demo.
* Register `PrismTokens` as a `ThemeExtension` on `ThemeData.extensions` ONLY
  when the user wants custom spacing/radii/motion. Read them back with the
  null-safe context extension `context.prismTokens`.
* NEVER read `PrismColors`/`PrismTokens` with `!` or manual null checks — the
  context extension falls back to Prism defaults automatically.
* Set `environment: sdk: ^3.14.0` and `flutter: ">=3.50.0"` in pubspec.yaml.

## Examples

### Minimal start (zero configuration)

```dart
import 'package:material_ui/material_ui.dart';
import 'package:prism_kit/prism.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prism Demo',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const HomePage(),
    );
  }
}
```

### Custom tokens

```dart
MaterialApp(
  theme: ThemeData(
    colorSchemeSeed: Colors.teal,
    extensions: const [
      PrismTokens(spaceMd: 20, radiusMd: 16),
    ],
  ),
)
```

### Reading tokens/colors anywhere in the tree

```dart
Padding(
  padding: EdgeInsets.all(context.prismTokens.spaceMd),
  child: Container(color: context.prismColors.surfaceRaised),
)
```

### Adding prism_kit to a project

```yaml
dependencies:
  material_ui: ^1.11.1
  prism_kit: ^2.1.0
```
