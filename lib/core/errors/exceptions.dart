class EmailConfirmationRequiredException implements Exception {
  final String message;

  EmailConfirmationRequiredException({
    this.message = 'Email confirmation required.',
  });

  @override
  String toString() => message;
}
