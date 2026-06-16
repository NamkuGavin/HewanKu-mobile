class AuthChangePasswordRequestModel {
  final String email;
  final String password;
  final String repassword;

  const AuthChangePasswordRequestModel({required this.email, required this.password, required this.repassword});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'repassword': repassword};
  }
}
