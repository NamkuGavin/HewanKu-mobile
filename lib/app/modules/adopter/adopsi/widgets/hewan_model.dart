/// Model data untuk satu item hewan di halaman Lihat Semua
class HewanModel {
  final int id;
  final String name;
  final String shelter;
  final String price;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final String imageUrl;
  final int fallbackColorValue;

  // Field detail hewan
  final String? umur;
  final String? jenisKelamin;
  final String? kontakShelter;
  final String? kategori;
  final String? statusAdopsi;

  const HewanModel({
    this.id = 0,
    required this.name,
    required this.shelter,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.tags,
    required this.imageUrl,
    required this.fallbackColorValue,
    this.umur,
    this.jenisKelamin,
    this.kontakShelter,
    this.kategori,
    this.statusAdopsi,
  });

  String get resolvedStatusAdopsi {
    final status = statusAdopsi?.trim() ?? '';
    return status.isEmpty ? 'Belum diadopsi' : status;
  }

  String get normalizedStatusAdopsi => resolvedStatusAdopsi.toLowerCase();

  bool get isAvailableForAdoption {
    final status = normalizedStatusAdopsi;

    const availableKeywords = <String>[
      'tersedia',
      'available',
      'belum diadopsi',
    ];
    const unavailableKeywords = <String>[
      'tidak tersedia',
      'terjual',
      'habis',
      'sold',
      'adopted',
      'teradopsi',
      'sudah diadopsi',
      'telah diadopsi',
      'unavailable',
    ];

    if (availableKeywords.any(status.contains)) {
      return true;
    }

    if (unavailableKeywords.any(status.contains)) {
      return false;
    }

    return true;
  }
}
