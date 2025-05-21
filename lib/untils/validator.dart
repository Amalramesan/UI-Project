String? emailValidator(String? value) {
  if (value == null || value.isEmpty) return 'Please enter email';
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) return "Enter a password";
  if (value.length <= 6) return "Enter at least six characters";
  return null;
}
