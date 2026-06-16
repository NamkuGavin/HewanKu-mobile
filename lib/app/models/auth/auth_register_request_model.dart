class AuthRegisterRequestModel {
  final String email;
  final String password;
  final String namaDepan;
  final String namaBelakang;
  final String noTelepon;
  final String confirmPassword;
  final String keyRole;

  const AuthRegisterRequestModel({
    required this.email,
    required this.password,
    required this.namaDepan,
    required this.namaBelakang,
    required this.noTelepon,
    required this.confirmPassword,
    required this.keyRole,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'namaDepan': namaDepan,
      'namaBelakang': namaBelakang,
      'noTelepon': noTelepon,
      'confirmPassword': confirmPassword,
      'keyRole': keyRole,
    };
  }
}
