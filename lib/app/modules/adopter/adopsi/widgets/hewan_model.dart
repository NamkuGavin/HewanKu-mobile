/// Model data untuk satu item hewan di halaman Lihat Semua
class HewanModel {
  final String name;
  final String shelter;
  final String priceRange;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final String imageUrl;
  final int fallbackColorValue;

  // Field baru untuk detail pembayaran
  final String? ras;
  final String? umur;
  final String? berat;
  final String? kesehatan;
  final String? kontakShelter;

  const HewanModel({
    required this.name,
    required this.shelter,
    required this.priceRange,
    required this.rating,
    required this.reviewCount,
    required this.tags,
    required this.imageUrl,
    required this.fallbackColorValue,
    this.ras,
    this.umur,
    this.berat,
    this.kesehatan,
    this.kontakShelter,
  });
}