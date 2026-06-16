class ApiResponseModel<T> {
  final int? code;
  final String? status;
  final String? message;
  final T? data;
  final Object? errors;

  const ApiResponseModel({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json, {T? Function(Object? rawData)? dataParser}) {
    return ApiResponseModel<T>(
      code: json['code'] as int?,
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: dataParser != null ? dataParser(json['data']) : json['data'] as T?,
      errors: json['errors'],
    );
  }

  bool get isSuccessCode => code == 200 || code == 201;

  bool get hasFailureStatus {
    final normalized = status?.trim().toUpperCase();
    return normalized == 'UNAUTHORIZED' || normalized == 'FORBIDDEN' || normalized == 'BAD_REQUEST' || normalized == 'ERROR';
  }

  bool get isSuccessful => isSuccessCode && !hasFailureStatus && errors == null;
}
