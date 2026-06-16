import 'dart:convert';

import 'auth_login_data_model.dart';

class AuthSessionModel {
  final String token;
  final int userId;
  final String email;
  final String role;
  final bool rememberMe;
  final DateTime? expiresAt;

  const AuthSessionModel({
    required this.token,
    required this.userId,
    required this.email,
    required this.role,
    required this.rememberMe,
    required this.expiresAt,
  });

  factory AuthSessionModel.fromLoginData({
    required AuthLoginDataModel data,
    required String role,
    required bool rememberMe,
  }) {
    return AuthSessionModel(
      token: data.token,
      userId: data.userId,
      email: data.email,
      role: role,
      rememberMe: rememberMe,
      expiresAt: _extractExpiry(data.token),
    );
  }

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      token: (json['token'] ?? '').toString(),
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      rememberMe: json['rememberMe'] == true,
      expiresAt: json['expiresAt'] is String && (json['expiresAt'] as String).isNotEmpty
          ? DateTime.tryParse(json['expiresAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'email': email,
      'role': role,
      'rememberMe': rememberMe,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  bool get isExpired {
    if (expiresAt == null) {
      return false;
    }
    return DateTime.now().isAfter(expiresAt!);
  }

  AuthSessionModel copyWith({
    String? token,
    int? userId,
    String? email,
    String? role,
    bool? rememberMe,
    DateTime? expiresAt,
  }) {
    return AuthSessionModel(
      token: token ?? this.token,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      role: role ?? this.role,
      rememberMe: rememberMe ?? this.rememberMe,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  static DateTime? _extractExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      final exp = decoded['exp'];
      if (exp is! num) {
        return null;
      }
      return DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000);
    } catch (_) {
      return null;
    }
  }
}
