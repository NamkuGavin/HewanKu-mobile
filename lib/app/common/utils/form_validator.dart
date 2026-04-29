class FormValidator {
  // Private constructor agar class ini tidak perlu dibuat object-nya.
  // Pemakaiannya cukup: FormValidator.email(value)
  FormValidator._();

  // Validasi nama
  // Aturan:
  // - Tidak boleh kosong
  // - Minimal 2 karakter
  // - Hanya boleh huruf, spasi, titik, petik, dan strip
  static String? name(String? value, {String fieldName = 'Nama'}) {
    final input = value?.trim() ?? '';

    if (input.isEmpty) {
      return '$fieldName wajib diisi';
    }
    if (input.length < 2) {
      return '$fieldName minimal 2 karakter';
    }

    final nameRegex = RegExp(r"^[a-zA-Z\s'.-]+$");
    if (!nameRegex.hasMatch(input)) {
      return '$fieldName hanya boleh berisi huruf';
    }
    return null;
  }

  // Validasi nomor handphone Indonesia
  // Contoh valid:
  // 081234567890
  // 6281234567890
  // +6281234567890
  static String? phone(String? value) {
    final input = value?.trim().replaceAll(' ', '').replaceAll('-', '') ?? '';
    if (input.isEmpty) {
      return 'Nomor handphone wajib diisi';
    }
    final phoneRegex = RegExp(r'^(?:\+62|62|0)8[1-9][0-9]{7,11}$');

    if (!phoneRegex.hasMatch(input)) {
      return 'Format nomor handphone tidak valid';
    }
    return null;
  }

  // Validasi email
  static String? email(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Email wajib diisi';
    }

    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailRegex.hasMatch(input)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Validasi password
  // Aturan:
  // - Tidak boleh kosong
  // - Minimal 12 karakter
  static String? password(String? value) {
    final input = value ?? '';
    if (input.isEmpty) {
      return 'Sandi wajib diisi';
    }
    if (input.length < 12) {
      return 'Sandi minimal 12 karakter';
    }
    return null;
  }

  // Validasi konfirmasi password
  // Aturan:
  // - Tidak boleh kosong
  // - Harus sama dengan password utama
  static String? confirmPassword(String? value, {required String password}) {
    final input = value ?? '';
    if (input.isEmpty) {
      return 'Konfirmasi sandi wajib diisi';
    }
    if (input != password) {
      return 'Konfirmasi sandi tidak sama';
    }
    return null;
  }
}
