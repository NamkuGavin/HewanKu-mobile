class AdopterProfileUpdateRequestModel {
  final String email;
  final String displayName;
  final String noTelepon;

  const AdopterProfileUpdateRequestModel({required this.email, required this.displayName, required this.noTelepon});

  Map<String, dynamic> toJson() {
    return {'email': email.trim(), 'displayName': displayName.trim(), 'noTelepon': noTelepon.trim()};
  }
}
