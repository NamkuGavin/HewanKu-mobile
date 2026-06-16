class AuthVerifyOtpRequestModel {
  final String email;
  final String otp;

  const AuthVerifyOtpRequestModel({required this.email, required this.otp});

  Map<String, dynamic> toJson() {
    return {'email': email, 'otp': otp};
  }
}
