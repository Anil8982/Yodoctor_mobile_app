# Form Components Documentation

## Common Parameters Across Fields

These parameters are shared by almost all custom form components:

| Parameter | Type | Description |
|-----------|------|-------------|
| `label` | `String` | The title or label text displayed above the input field. |
| `isRequired` | `bool` | When `true`, shows a red asterisk (`*`) next to the label to indicate a mandatory field. |
| `hint` | `String` | Placeholder text displayed inside the field when no value is entered or selected. |
| `icon` | `IconData` | Prefix icon displayed on the left side of the input field. |
| `enabled` | `bool` | Controls whether the field is interactive (`true`) or disabled (`false`). |
| `validator` | `String? Function(...)` | Form validation function that checks the field's input value and returns an error message if invalid, or `null` if valid. |
| `autovalidateMode` | `AutovalidateMode?` | Defines when validation should trigger automatically (e.g., `AutovalidateMode.onUserInteraction`). |
| `isInvalid` | `bool` | Manual override flag to force the field into an error state regardless of standard form validation. |
| `errorText` | `String?` | Custom error message displayed when `isInvalid` is `true`. |
| `onChanged` | `ValueChanged` | Callback triggered whenever the entered or selected value changes. |

---

# 1. AppTextField

Used for standard text inputs, multi-line text areas, passwords, numbers, and emails.

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `controller` | `TextEditingController?` | Manages the text being edited and retains the current value. |
| `isPassword` | `bool` | If `true`, obscures the text input and displays a visibility toggle icon. |
| `keyboardType` | `TextInputType` | Sets the keyboard layout (e.g., phone, email, number). |
| `maxLength` | `int?` | Maximum number of characters allowed. |
| `maxLines` | `int?` | Maximum visible lines. Use values greater than `1` for multi-line input. |
| `minLines` | `int?` | Minimum visible lines for expandable text fields. |
| `inputFormatters` | `List<TextInputFormatter>?` | Restricts or formats typed text (e.g., digits only). |
| `textCapitalization` | `TextCapitalization` | Controls automatic capitalization behavior. |
| `readOnly` | `bool` | Makes the field non-editable while still allowing tap events. |
| `onTap` | `VoidCallback?` | Callback executed when the field is tapped. |

---

# 2. AppDropdownField

Used for selecting a single option from a standard Material dropdown.

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `value` | `String?` | Currently selected dropdown value. |
| `items` | `List<String>` | List of available dropdown options. |

---

# 3. AppDatePickerField

Used for selecting a date using the native calendar dialog.

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `value` | `DateTime?` | Currently selected date. |
| `firstDate` | `DateTime?` | Earliest selectable date. |
| `lastDate` | `DateTime?` | Latest selectable date. |

---

# 4. AppTimePickerField

Used for selecting a time using the native time picker dialog.

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `value` | `TimeOfDay?` | Currently selected time. |

---

# 5. AppMultiSelectField

Used for selecting multiple options through a checkable bottom sheet.

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `selectedItems` | `List<String>` | Currently selected items. |
| `options` | `List<String>` | Complete list of selectable options. |

---

# 6. AppSearchSelectField

Used for selecting a single option from a large searchable dataset.

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `value` | `String?` | Currently selected value. |
| `items` | `List<String>` | Complete searchable list of available options. |

---

## Example Usage

```dart
AppTextField(
  label: 'Full Name',
  isRequired: true,
  hint: 'Enter your full name',
  icon: Icons.person,
  controller: nameController,
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  },
)

AppDropdownField(
  label: 'Gender',
  hint: 'Select Gender',
  icon: Icons.people,
  value: gender,
  items: ['Male', 'Female', 'Other'],
  onChanged: (value) => setState(() => gender = value),
)

AppDatePickerField(
  label: 'Date of Birth',
  hint: 'Select Date',
  icon: Icons.calendar_today,
  value: dob,
  onChanged: (date) => setState(() => dob = date),
)

AppTimePickerField(
  label: 'Appointment Time',
  hint: 'Select Time',
  icon: Icons.access_time,
  value: appointmentTime,
  onChanged: (time) => setState(() => appointmentTime = time),
)

AppMultiSelectField(
  label: 'Languages',
  hint: 'Select Languages',
  icon: Icons.language,
  selectedItems: languages,
  options: ['English', 'Hindi', 'Marathi'],
  onChanged: (items) => setState(() => languages = items),
)

AppSearchSelectField(
  label: 'City',
  hint: 'Search City',
  icon: Icons.location_city,
  value: city,
  items: cityList,
  onChanged: (value) => setState(() => city = value),
)
```