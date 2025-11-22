class SignUpResult {
  final bool ok;
  final String? error;
  final String? token;

  SignUpResult({
    required this.ok,
    this.error,
    this.token,
  });
}
