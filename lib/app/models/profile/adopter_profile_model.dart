class AdopterProfileModel {
  final String email;
  final String displayName;
  final String noTelepon;
  final String? avatarUrl;
  final String? namaDepan;
  final String? namaBelakang;

  const AdopterProfileModel({
    required this.email,
    required this.displayName,
    required this.noTelepon,
    required this.avatarUrl,
    required this.namaDepan,
    required this.namaBelakang,
  });

  factory AdopterProfileModel.fromJson(Map<String, dynamic> json) {
    return AdopterProfileModel(
      email: _readString(json, const ['email']),
      displayName: _resolveDisplayName(json),
      noTelepon: _readString(json, const ['noTelepon']),
      avatarUrl: _readNullableString(json, const ['fotoProfil', 'urlFotoProfil', 'imageUrl', 'avatarUrl']),
      namaDepan: _readNullableString(json, const ['namaDepan']),
      namaBelakang: _readNullableString(json, const ['namaBelakang']),
    );
  }

  String get fullName {
    final display = displayName.trim();
    if (display.isNotEmpty) {
      return display;
    }

    final firstName = namaDepan?.trim() ?? '';
    final lastName = namaBelakang?.trim() ?? '';
    final combined = '$firstName $lastName'.trim();
    if (combined.isNotEmpty) {
      return combined;
    }

    return '';
  }

  static String _resolveDisplayName(Map<String, dynamic> json) {
    final display = _readString(json, const ['displayName', 'nama']);
    if (display.isNotEmpty) {
      return display;
    }

    final firstName = _readNullableString(json, const ['namaDepan'])?.trim();
    final lastName = _readNullableString(json, const ['namaBelakang'])?.trim();
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    final value = _readNullableString(json, keys);
    return value?.trim() ?? '';
  }

  static String? _readNullableString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) {
        continue;
      }

      final text = value.toString().trim();
      if (text.isNotEmpty) {
        return text;
      }
    }

    return null;
  }
}
