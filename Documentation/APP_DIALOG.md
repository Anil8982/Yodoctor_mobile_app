# AppDialog Usage Guide

`AppDialog` is the shared glassmorphic dialog system for the app.

## Import

```dart
import 'package:yodoctor/core/widgets/dialogs/app_dialog.dart';

```

---

## Basic Usage

To show a standard dialog anywhere in the app, use `AppDialog.show()`:

```dart
AppDialog.show(
  context: context,
  title: 'Delete Item?',
  content: 'Are you sure you want to delete this item? This action cannot be undone.',
  icon: Icons.delete_forever_rounded,
  confirmLabel: 'Delete',
  cancelLabel: 'Cancel',
  isDestructive: true,
  onConfirm: () async {
    // Handle confirmation action
  },
);

```

---

## Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `BuildContext` | **Required** | The build context to show the dialog. |
| `title` | `String` | **Required** | The main heading of the dialog. |
| `content` | `dynamic` | **Required** | Accepts a raw `String` or any custom Flutter `Widget`. |
| `icon` | `IconData?` | `null` | Optional leading icon in the header. |
| `confirmLabel` | `String` | `'Confirm'` | Label for the primary action button. |
| `cancelLabel` | `String` | `'Cancel'` | Label for the secondary action button. |
| `onConfirm` | `VoidCallback` | **Required** | Callback executed when the confirm button is pressed. |
| `onCancel` | `VoidCallback?` | `null` | Optional custom callback for the cancel button. |
| `isDestructive` | `bool` | `false` | If `true`, applies error/danger theme colors to the primary button. |
| `showCancel` | `bool` | `true` | Set to `false` to hide the cancel button (e.g., for info alerts). |
| `customAccentColor` | `Color?` | `null` | Override default primary or error accent color. |
| `extraActions` | `List<Widget>?` | `null` | Additional custom action buttons placed before the cancel button. |

---

## Examples

### 1. Info Alert (No Cancel Button)

```dart
AppDialog.show(
  context: context,
  title: 'Profile Updated',
  content: 'Your changes have been saved successfully.',
  icon: Icons.check_circle_rounded,
  confirmLabel: 'Okay',
  showCancel: false,
  onConfirm: () {},
);

```

### 2. Custom Widget Content

```dart
AppDialog.show(
  context: context,
  title: 'Select Options',
  content: const Column(
    children: [
      Text('Please pick a category for this record.'),
      // Add custom widgets here
    ],
  ),
  icon: Icons.folder_rounded,
  confirmLabel: 'Apply',
  onConfirm: () {
    // Handle apply
  },
);
```