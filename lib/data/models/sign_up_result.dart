class SignUpResult {
  final bool ok;
  final String? error;
  final String? token;
  final int? statusCode;

  SignUpResult({
    required this.ok,
    this.error,
    this.token,
    this.statusCode,
  });
}
