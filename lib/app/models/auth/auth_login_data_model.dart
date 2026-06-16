class AuthLoginDataModel {
  final String token;
  final int userId;
  final String email;

  const AuthLoginDataModel({required this.token, required this.userId, required this.email});

  factory AuthLoginDataModel.fromJson(Map<String, dynamic> json) {
    return AuthLoginDataModel(
      token: (json['token'] ?? '').toString(),
      userId: (json['id'] as num?)?.toInt() ?? 0,
      email: (json['email'] ?? '').toString(),
    );
  }
}
