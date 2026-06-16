class AuthForgotPasswordRequestModel {
  final String email;

  const AuthForgotPasswordRequestModel({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}
