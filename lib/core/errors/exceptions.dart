class EmailConfirmationRequiredException implements Exception {
  final String message;

  EmailConfirmationRequiredException({
    this.message = 'Email confirmation required.',
  });

  @override
  String toString() => message;
}

class UserAlreadyRegisteredException implements Exception {
  final String message;

  UserAlreadyRegisteredException({
    this.message = 'User already registered. Please login.',
  });

  @override
  String toString() => message;
}
