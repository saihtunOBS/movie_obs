String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email';
  }

  return null; // Valid
}

String? phoneValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Phone number is required';
  }

  return null; // Valid
}

String? nameValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Name is required';
  }
  return null; // Valid
}
