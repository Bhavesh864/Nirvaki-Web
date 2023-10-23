String? validateEmail(String? value) {
  if (value?.trim() == null || value!.trim().isEmpty) {
    return 'Please enter your email';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
  if (!emailRegex.hasMatch(value.trim())) {
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

String? validateSignupPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one number';
  }

  if (!value.contains(RegExp(r'[!@#\$%^&*()_+{}|:;<>,.?~\-]'))) {
    return 'Password must contain at least one symbol';
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

String? validateEmailNotMandatory(String? value) {
  if (value == null || value.isNotEmpty) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailRegex.hasMatch(value!)) {
      return 'Please enter a valid email address';
    }
  }
  return null;
}

String? isYouTubeVideoURL(String url) {
  if (url.isEmpty) {
    return null;
  }
  final RegExp regExp = RegExp(
    r'^https?:\/\/(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]+)',
    caseSensitive: false,
  );

  if (!regExp.hasMatch(url)) {
    return 'Please enter a valid Youtube video link';
  }
  return null;
}
