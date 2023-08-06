String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  return null;
}

String? validateForNormalFeild({required String? value, required String? props}) {
  if (value == null || value.isEmpty) {
    return 'Please enter your $props';
  }
  return null;
}

String? validateForMobileNumberFeild({required String? value, required String? props}) {
  if (value == null || value.isEmpty) {
    return 'Please enter your $props';
  } else if (value.length < 10) {
    return "Enter Valid $props";
  }
  return null;
}
