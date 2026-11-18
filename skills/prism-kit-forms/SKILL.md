---
name: prism-kit-forms
description: >-
  Use when the user is building forms with prism_kit: PrismForm,
  PrismFormController, PrismTextField/PrismPasswordField/PrismDropdownField,
  or Validators. Ensures correct headless-controller wiring, validator
  composition, and the sealed PrismFormStatus lifecycle handling.
---

# Prism Kit Forms

## Guidelines

* Wrap fields in `PrismForm` (widget-managed, creates/disposes its own
  `PrismFormController` when none is passed) OR drive a standalone
  `PrismFormController` headlessly for custom UIs. Never do both for the
  same form.
* ALWAYS pass a `name` to every field — it is the key in
  `controller.values`/`controller.errors`.
* Compose validators with `Validators.all([...])` or pass a list to the
  field's `validators` parameter. Built-ins: `Validators.required()`,
  `.email()`, `.minLength(n)`, `.maxLength(n)`, `.pattern(RegExp)`,
  `.number()`.
* Handle submission with the sealed `PrismFormStatus` types exhaustively:
  `pristine`, `editing`, `submitting`, `success`, `failure`. Use a `switch`
  expression so a new status is a compile error.
* Submit through `await controller.submit((values) => api.call(values))` —
  it drives the `submitting`/`success`/`failure` lifecycle and throws
  `PrismSubmissionException` on failure.
* Read live state with `controller.values`, `controller.errors`,
  `controller.touched` (all unmodifiable views), and listen via
  `PrismFormScope` (an `InheritedNotifier`) or `ListenableBuilder` on the
  controller.
* Show validation errors only after `touched` contains the field or the user
  attempted a submit (the controller tracks both).

## Examples

### Declarative form

```dart
final controller = PrismFormController();

PrismForm(
  controller: controller,
  child: Column(children: [
    PrismTextField(
      name: 'email',
      label: 'Email',
      validators: [Validators.required(), Validators.email()],
    ),
    PrismPasswordField(name: 'password'),
    PrismDropdownField<String>(
      name: 'role',
      label: 'Role',
      items: const ['Admin', 'Editor'],
    ),
    PrismCheckboxField(name: 'terms', label: 'Accept terms'),
  ]),
)
```

### Submitting with the lifecycle

```dart
if (await controller.submit((values) => api.register(values))) {
  // success
}
```

### Exhaustive status handling

```dart
switch (controller.status) {
  PrismFormPristine() => const Text('Start typing…'),
  PrismFormEditing() => const Text('Editing'),
  PrismFormSubmitting() => const PrismLinearProgress(),
  PrismFormSuccess() => const Text('Saved!'),
  PrismFormFailure() => Text('Error: ${controller.submissionError}'),
}
```

### Custom validator

```dart
final PrismValidator phone = (value) =>
    (value ?? '').startsWith('+') ? null : 'Include country code';

PrismTextField(
  name: 'phone',
  label: 'Phone',
  validators: [Validators.required(), phone],
)
```
