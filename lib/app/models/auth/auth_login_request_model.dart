class AuthLoginRequestModel {
  final String email;
  final String password;

  const AuthLoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
