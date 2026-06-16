class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final int? apiCode;
  final Object? errors;
  final bool isUnauthorized;

  const ApiException({required this.message, this.statusCode, this.apiCode, this.errors, this.isUnauthorized = false});

  @override
  String toString() => 'ApiException(message: $message, statusCode: $statusCode, apiCode: $apiCode)';
}
