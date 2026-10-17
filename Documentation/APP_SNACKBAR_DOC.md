# AppSnackBar

A reusable global SnackBar utility used throughout the application.

---

## Overview

`AppSnackBar` provides a centralized way to display snackbars anywhere in the app without requiring a `BuildContext`.

### Supported Types

- Success
- Error
- Warning
- Info
- Loading

---

# Basic Usage

```dart
AppSnackBar.show(
  message: "Profile updated successfully",
);
```

---

# Success

```dart
AppSnackBar.show(
  message: "Profile updated successfully",
  type: AppSnackBarType.success,
);
```

---

# Error

```dart
AppSnackBar.show(
  message: "Something went wrong",
  type: AppSnackBarType.error,
);
```

---

# Warning

```dart
AppSnackBar.show(
  message: "Low battery",
  type: AppSnackBarType.warning,
);
```

---

# Info

```dart
AppSnackBar.show(
  message: "New update available",
  type: AppSnackBarType.info,
);
```

---

# Loading

```dart
AppSnackBar.show(
  message: "Uploading...",
  type: AppSnackBarType.loading,
  dismissible: false,
);
```

Hide loading snackbar:

```dart
AppSnackBar.hide();
```

---

# Action Button

```dart
AppSnackBar.show(
  message: "File deleted",
  actionLabel: "UNDO",
  onAction: restoreFile,
);
```

---

# Copy Button

```dart
AppSnackBar.show(
  message: apiError,
  type: AppSnackBarType.error,
  copyable: true,
);
```

---

# Custom Accent Color

```dart
AppSnackBar.show(
  message: "Payment successful",
  customAccentColor: Colors.green,
);
```

---

# Custom Icon

```dart
AppSnackBar.show(
  message: "Bookmark added",
  customIcon: Icons.bookmark,
);
```

---

# Disable Haptic

```dart
AppSnackBar.show(
  message: "Background sync complete",
  haptic: false,
);
```

---

# Keep Existing Snackbar

```dart
AppSnackBar.show(
  message: "Download completed",
  replaceCurrent: false,
);
```

---

# BuildContext Extensions

## Success

```dart
context.showSuccessSnackBar("Saved successfully");
```

## Error

```dart
context.showErrorSnackBar("Unable to login");
```

## Warning

```dart
context.showWarningSnackBar("Low storage");
```

## Info

```dart
context.showInfoSnackBar("Connected");
```

## Loading

```dart
context.showLoadingSnackBar("Loading...");
```

## Hide

```dart
context.hideCurrentSnackBar();
```

---

# Parameters

| Parameter | Description |
|-----------|-------------|
| `message` | Snackbar message |
| `type` | Snackbar type |
| `actionLabel` | Action button text |
| `onAction` | Action callback |
| `copyable` | Shows copy button |
| `dismissible` | Shows close button |
| `haptic` | Enables haptic feedback |
| `replaceCurrent` | Replaces current snackbar |
| `leading` | Custom leading widget *(Reserved for future use)* |
| `duration` | Custom display duration |
| `customAccentColor` | Custom accent color |
| `customIcon` | Custom icon |
| `maxAdaptiveWidth` | Maximum snackbar width *(Reserved for future use)* |

---

# Notes

- Global utility (no `BuildContext` required).
- Duplicate snackbars are automatically throttled.
- Supports Light & Dark themes.
- Loading snackbar remains visible until `AppSnackBar.hide()` is called.
- Context extension methods are available for widget-level usage.
- Intended to be the single snackbar implementation across the project.

---

# Example

```dart
AppSnackBar.show(
message: "Emergency cancellations initiated",
type: AppSnackBarType.success,
);
```