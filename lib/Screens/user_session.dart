class UserSession {
  static String displayName = "User";
  static String email = "user@gmail.com";

  static String get avatarLetter =>
      email.isNotEmpty ? email[0].toUpperCase() : "U";
}
