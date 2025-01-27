bool isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

bool isValidPhoneNumber(String phoneNumber) {
  return RegExp(r'^\+?[0-9]{10,13}$').hasMatch(phoneNumber);
}

bool isValidPassword(String password) {
  return password.length >= 6;
}

bool isValidConfirmPassword(String password, String confirmPassword) {
  return password == confirmPassword;
}
