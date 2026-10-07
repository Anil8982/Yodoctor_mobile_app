# YoDoctor Material 3 Color Usage Rules

## Purpose

This document defines the standard rules for using Material 3 colors throughout the YoDoctor Flutter application.

These rules apply only to:

- Doctor
- Patient

The Admin theme is not covered by this document.

The goal is to maintain a consistent, semantic, accessible, and predictable color system across all screens and components.

---

# 1. Core Color Rules

## Rule 1 — Always Prefer Semantic ColorScheme Tokens

UI code should use the Material 3 `ColorScheme` whenever possible.

### Preferred

```dart
final colorScheme = Theme.of(context).colorScheme;

Container(
  color: colorScheme.surface,
)
````

### Avoid

```dart
Container(
  color: Colors.white,
)
```

### Avoid

```dart
Container(
  color: const Color(0xFFFFFFFF),
)
```

Raw colors should not be introduced directly into UI code unless they are explicitly defined as part of the application's design system.

---

# 2. Background Color Hierarchy

Use colors according to the visual hierarchy of the UI.

## Main Application Background

Use:

```dart
colorScheme.surface
```

Typical usage:

* Scaffold background
* Main screen background
* Page background
* General application surface

Do NOT normally use:

```dart
colorScheme.primary
colorScheme.secondary
colorScheme.tertiary
```

as the main Scaffold background.

---

## Grouped / Section Background

Use:

```dart
colorScheme.surfaceContainer
```

Typical usage:

* Grouped sections
* Secondary content areas
* Content containers
* Subtle visual separation
* Supporting UI sections

---

## Elevated / Stronger Surface

Use:

```dart
colorScheme.surfaceContainerHigh
```

Typical usage:

* Elevated cards
* Important grouped sections
* Dialog-like content areas
* Bottom-sheet sections
* UI that needs more visual separation from the main surface

Do not use it automatically for every card.

Choose the surface level based on the required visual hierarchy.

---

## Highest Surface Level

Use:

```dart
colorScheme.surfaceContainerHighest
```

Only when stronger surface separation is actually required.

Typical usage:

* Highly emphasized containers
* Selected/elevated UI sections
* Strong visual grouping

Avoid using this token everywhere because it reduces the visual hierarchy between different surfaces.

---

# 3. Primary Color

## `primary`

Purpose:

The main brand and action color.

Typical usage:

* Main CTA buttons
* Primary actions
* Selected navigation item
* Active controls
* Important interactive elements
* Progress indicators when representing the primary action
* Brand-focused interactive elements

Example:

```dart
FilledButton(
  onPressed: () {},
  child: const Text('Continue'),
)
```

The button should normally obtain its color from the theme rather than manually specifying a color.

---

## `onPrimary`

Purpose:

Foreground content displayed on top of `primary`.

Use for:

* Text on primary background
* Icons on primary background
* Content inside primary-colored buttons

Relationship:

```text
primary
   ↓
onPrimary
```

Never manually choose black/white text based on visual guessing when the semantic `onPrimary` token exists.

---

# 4. Primary Container

## `primaryContainer`

Purpose:

A softer version of the primary color.

Typical usage:

* Selected cards
* Soft highlighted sections
* Selected states
* Primary information containers
* Subtle brand-colored backgrounds
* Highlighted UI areas

It should generally be preferred over using a strong `primary` background for large areas.

---

## `onPrimaryContainer`

Use for:

* Text on `primaryContainer`
* Icons on `primaryContainer`
* Supporting content inside primary-colored containers

Relationship:

```text
primaryContainer
       ↓
onPrimaryContainer
```

---

# 5. Secondary Color

## `secondary`

Purpose:

Supporting interactive color.

Typical usage:

* Secondary actions
* Supporting buttons
* Secondary interactive controls
* Supporting navigation/action elements
* UI that should be visually distinct from the primary action

Do not use `secondary` as another primary CTA.

---

## `onSecondary`

Use for:

* Text on `secondary`
* Icons on `secondary`
* Content inside secondary-colored components

Relationship:

```text
secondary
   ↓
onSecondary
```

---

# 6. Secondary Container

## `secondaryContainer`

Purpose:

Soft secondary-colored background.

Typical usage:

* Secondary highlighted sections
* Filters
* Supporting chips
* Secondary selected states
* Supporting information containers

---

## `onSecondaryContainer`

Use for:

* Text on `secondaryContainer`
* Icons on `secondaryContainer`

Relationship:

```text
secondaryContainer
       ↓
onSecondaryContainer
```

---

# 7. Tertiary Color

## `tertiary`

Purpose:

Accent color for special or supporting visual emphasis.

Typical usage:

* Special UI accents
* Additional visual distinction
* Supporting status or category indicators
* Small decorative accents
* Secondary visual emphasis

Do NOT use `tertiary` as a replacement for `primary`.

The primary action should remain visually primary.

---

## `onTertiary`

Use for:

* Text on `tertiary`
* Icons on `tertiary`

---

## `tertiaryContainer`

Use for:

* Soft tertiary highlights
* Accent containers
* Special category states

---

## `onTertiaryContainer`

Use for:

* Text and icons on `tertiaryContainer`

---

# 8. Main Text Colors

## `onSurface`

This is the default main foreground color.

Use for:

* Primary text
* Headings
* Important labels
* Main content
* Primary icons
* Important UI information

Example:

```dart
Text(
  'Upcoming Appointment',
  style: TextStyle(
    color: colorScheme.onSurface,
  ),
)
```

---

## `onSurfaceVariant`

Use for secondary or supporting content.

Typical usage:

* Secondary text
* Supporting descriptions
* Metadata
* Helper text
* Less prominent labels
* Secondary icons
* Placeholder-like supporting content

Example:

```dart
Text(
  'Today, 10:30 AM',
  style: TextStyle(
    color: colorScheme.onSurfaceVariant,
  ),
)
```

Do not use `onSurfaceVariant` for important primary headings.

---

# 9. Borders, Dividers and Outlines

## `outline`

Use for:

* TextField borders
* Outlined button borders
* Card borders
* Component boundaries
* Subtle dividers

Example:

```dart
BorderSide(
  color: colorScheme.outline,
)
```

Do not use strong primary/secondary colors for normal borders.

---

## `outlineVariant`

Use for softer boundaries.

Typical usage:

* Very subtle dividers
* Low-emphasis borders
* Section separators
* Subtle card boundaries

Prefer `outlineVariant` when `outline` looks visually too strong.

---

# 10. Error Colors

## `error`

Use for:

* Validation errors
* Destructive actions
* Error states
* Failed operations
* Invalid input states

Examples:

* Invalid email
* Invalid OTP
* Failed API operation
* Delete/destructive action indication

---

## `onError`

Use for:

* Text on `error`
* Icons on `error`
* Content inside an error-colored component

Relationship:

```text
error
   ↓
onError
```

---

## `errorContainer`

Use for softer error backgrounds.

Typical usage:

* Error messages
* Error banners
* Error sections
* Validation containers
* Non-destructive error notifications

---

## `onErrorContainer`

Use for:

* Error message text
* Error icons
* Supporting content inside `errorContainer`

Relationship:

```text
errorContainer
       ↓
onErrorContainer
```

---

# 11. Success Colors

Success colors should be used only for successful states.

Typical usage:

* Successful operation
* Appointment confirmed
* Payment successful
* Profile updated successfully
* Verification completed
* Successful API response

Use the application's defined semantic success token.

Do not manually introduce random green shades in individual screens.

Example:

```dart
colorScheme.success
```

If the application exposes success through a custom extension, use that semantic token consistently.

---

# 12. Warning Colors

Warning colors should communicate a state that requires attention but is not an error.

Typical usage:

* Pending state
* Expiring information
* Incomplete profile
* Attention required
* Non-critical warning

Use the application's defined semantic warning token.

Do not use random orange/yellow colors directly in UI code.

---

# 13. Info Colors

Information colors should communicate neutral informational content.

Typical usage:

* Helpful information
* Informational banners
* Tips
* Explanations
* Non-critical notices

Use the application's defined semantic info token.

Do not use arbitrary blue colors for informational states.

---

# 14. Scaffold Rules

The default Scaffold background should be:

```dart
colorScheme.surface
```

Example:

```dart
Scaffold(
  backgroundColor: colorScheme.surface,
)
```

Do not normally use:

```dart
colorScheme.primary
colorScheme.secondary
colorScheme.tertiary
```

as the Scaffold background.

The application background should remain visually neutral so that cards, buttons, navigation, and highlighted states can stand out.

---

# 15. AppBar Rules

The AppBar should normally use a surface-based color.

Preferred:

```dart
colorScheme.surface
```

or another appropriate surface token based on the screen hierarchy.

The AppBar should not automatically use `primary`.

Use a primary-colored AppBar only when the design specifically requires strong brand emphasis.

AppBar title:

```dart
colorScheme.onSurface
```

or the appropriate `on*` token when using a colored AppBar background.

---

# 16. Card Rules

Default cards should use a surface container.

Preferred:

```dart
colorScheme.surfaceContainer
```

or:

```dart
colorScheme.surfaceContainerHigh
```

depending on the required elevation/hierarchy.

Card text:

```dart
colorScheme.onSurface
```

Secondary card text:

```dart
colorScheme.onSurfaceVariant
```

Do not make every card primary-colored.

Primary colors should be reserved for meaningful emphasis.

---

# 17. Button Rules

## Primary Action

Use the Material 3 primary button styling.

Semantic relationship:

```text
primary
   ↓
onPrimary
```

Examples:

* Book Appointment
* Continue
* Confirm
* Submit
* Save

---

## Secondary Action

Use secondary or tonal styling.

Possible semantic relationship:

```text
secondary
secondaryContainer
onSecondaryContainer
```

Examples:

* Edit
* View Details
* Filter
* Secondary navigation/action

---

## Destructive Action

Use:

```text
error
onError
```

only when the action is genuinely destructive.

Examples:

* Delete account
* Delete appointment
* Remove important data

Do not use red merely to attract attention.

---

# 18. TextField Rules

Default TextField background should use an appropriate surface/container token.

Text:

```dart
colorScheme.onSurface
```

Hint/supporting text:

```dart
colorScheme.onSurfaceVariant
```

Normal border:

```dart
colorScheme.outline
```

Focused border:

Use the appropriate primary semantic styling.

Error border/text:

```dart
colorScheme.error
```

Avoid hardcoded colors for focused/error states.

---

# 19. Navigation Rules

Selected navigation items should use the primary semantic color system.

For example:

```text
Selected:
primaryContainer
+
onPrimaryContainer

Unselected:
surface / transparent
+
onSurfaceVariant
```

The exact Material component styling should be preferred over manually rebuilding navigation colors.

Do not use multiple unrelated brand colors for navigation states.

---

# 20. Dialog Rules

Dialogs should normally use:

```dart
colorScheme.surfaceContainerHigh
```

or the appropriate surface container level.

Main dialog text:

```dart
colorScheme.onSurface
```

Secondary dialog text:

```dart
colorScheme.onSurfaceVariant
```

Actions should follow the primary/secondary/error rules defined above.

---

# 21. Bottom Sheet Rules

Bottom sheets should use a surface-based color.

Preferred:

```dart
colorScheme.surfaceContainerHigh
```

or another appropriate surface container level.

Avoid using `primary` as the entire bottom-sheet background.

Use primary colors only for meaningful actions or selected states inside the sheet.

---

# 22. Snackbar Rules

Normal informational snackbar:

Use the appropriate surface/inverse surface Material styling.

Error snackbar:

Use the application's error semantic colors.

Success snackbar:

Use the application's success semantic colors.

Do not create custom random colors for every snackbar.

---

# 23. Status / State Color Rules

Use status colors according to meaning, not decoration.

| State            | Semantic Color |
| ---------------- | -------------- |
| Success          | `success`      |
| Error            | `error`        |
| Warning          | `warning`      |
| Information      | `info`         |
| Primary action   | `primary`      |
| Secondary action | `secondary`    |

The same state must use the same semantic color throughout the application.

For example:

If green means "Success", it must not mean "Selected" on another screen.

---

# 24. Foreground / Background Pairing Rule

Whenever a color is used as a background, use its corresponding semantic foreground token.

Correct:

```text
primary
→ onPrimary

primaryContainer
→ onPrimaryContainer

secondary
→ onSecondary

secondaryContainer
→ onSecondaryContainer

tertiary
→ onTertiary

tertiaryContainer
→ onTertiaryContainer

error
→ onError

errorContainer
→ onErrorContainer

surface
→ onSurface
```

Do not manually decide whether black or white text looks better.

---

# 25. Light and Dark Theme Rule

The same semantic token must maintain the same meaning in both Light and Dark themes.

For example:

```text
primary = main brand/action
surface = main background
onSurface = main text
error = error state
```

The actual color value may change between Light and Dark themes.

The semantic meaning must not change.

Example:

```dart
colorScheme.primary
```

should represent the primary action in both themes.

Do not create separate UI logic such as:

```dart
if (isDark) {
  color = Colors.white;
} else {
  color = Colors.black;
}
```

when a Material 3 semantic token already exists.

---

# 26. Doctor and Patient Theme Rule

Doctor and Patient may have different brand colors.

However, the semantic meaning of each Material token must remain consistent.

For example:

Doctor:

```text
primary → Doctor's main brand/action color
secondary → Doctor's supporting action color
surface → Doctor's neutral background
```

Patient:

```text
primary → Patient's main brand/action color
secondary → Patient's supporting action color
surface → Patient's neutral background
```

The component implementation should not change simply because the user role changes.

Only the theme's semantic color values should change where appropriate.

---

# 27. Forbidden Color Usage

Avoid these patterns in UI code:

```dart
Colors.white
Colors.black
Colors.blue
Colors.green
Colors.red
Colors.orange
```

when a semantic ColorScheme token can be used.

Avoid:

```dart
Color(0xFF...)
```

directly inside widgets.

Avoid creating a new random color for individual screens.

Avoid using:

```dart
primary
```

for every highlighted element.

Avoid using:

```dart
error
```

just because something needs visual attention.

Avoid using:

```dart
success
```

as a generic green accent.

Every color should have a semantic purpose.

---

# 28. Raw Color Exception

Raw colors are allowed only when they are part of the centralized design system.

For example:

```dart
class AppColors {
  static const doctorPrimary = Color(...);
  static const patientPrimary = Color(...);
}
```

These values should then be mapped into the Material 3 `ColorScheme`.

UI widgets should consume the semantic `ColorScheme` instead of directly consuming the raw color.

Preferred architecture:

```text
Raw Brand Colors
       ↓
AppColors
       ↓
ColorScheme
       ↓
Theme
       ↓
UI Components
```

---

# 29. Component-Level Decision Rule

When implementing a new UI component, ask:

1. What is this component's semantic purpose?
2. Is it a background, foreground, border, action, or status?
3. Is it primary, secondary, tertiary, neutral, error, success, warning, or info?
4. Which Material 3 ColorScheme token represents that meaning?
5. What is the corresponding `on*` color if the token is used as a background?
6. Does the same meaning remain consistent in Light and Dark themes?
7. Does the same meaning remain consistent for Doctor and Patient themes?

Only then choose the color.

---

# 30. Golden Rule

## Do not choose colors based on appearance alone.

Choose colors based on semantic meaning.

Bad approach:

> "This section looks empty, let's make it blue."

Good approach:

> "This section represents a primary highlighted state, therefore use `primaryContainer` with `onPrimaryContainer`."

Bad approach:

> "This error text looks better in dark red."

Good approach:

> "This is an error state, therefore use the application's `error` semantic token."

---

# 31. Final Architecture

The expected color architecture is:

```text
                    AppColors
                       │
                       ▼
                Material 3 Theme
                       │
                       ▼
                  ColorScheme
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
       Doctor       Patient      Dark/Light
          │            │            │
          └────────────┼────────────┘
                       ▼
                       UI
```

The UI should primarily consume:

```dart
Theme.of(context).colorScheme
```

or:

```dart
final colorScheme = Theme.of(context).colorScheme;
```

and then use semantic tokens such as:

```dart
colorScheme.primary
colorScheme.onPrimary
colorScheme.primaryContainer
colorScheme.onPrimaryContainer

colorScheme.secondary
colorScheme.onSecondary
colorScheme.secondaryContainer
colorScheme.onSecondaryContainer

colorScheme.tertiary
colorScheme.onTertiary
colorScheme.tertiaryContainer
colorScheme.onTertiaryContainer

colorScheme.surface
colorScheme.surfaceContainer
colorScheme.surfaceContainerHigh
colorScheme.surfaceContainerHighest

colorScheme.onSurface
colorScheme.onSurfaceVariant

colorScheme.outline
colorScheme.outlineVariant

colorScheme.error
colorScheme.onError
colorScheme.errorContainer
colorScheme.onErrorContainer
```

Custom semantic tokens such as:

```dart
success
warning
info
```

must also be centralized and consistently used.

---

# Summary

The YoDoctor UI should follow these principles:

1. Use Material 3 semantic colors.
2. Use `surface` for the main Scaffold background.
3. Use surface containers for cards and grouped content.
4. Use `primary` for the main action/brand.
5. Use `secondary` for supporting actions.
6. Use `tertiary` only for additional accent purposes.
7. Use `on*` tokens for content placed on colored backgrounds.
8. Use `onSurface` for primary text.
9. Use `onSurfaceVariant` for secondary text.
10. Use `outline` / `outlineVariant` for borders and dividers.
11. Use `error`, `success`, `warning`, and `info` only according to their semantic meaning.
12. Do not use arbitrary raw colors inside UI widgets.
13. Keep semantic meaning consistent across Light and Dark themes.
14. Keep semantic meaning consistent across Doctor and Patient themes.
15. Prefer centralized theme configuration over screen-specific color decisions.
16. Never select a color simply because it "looks good"; select it because it has the correct semantic purpose.

```