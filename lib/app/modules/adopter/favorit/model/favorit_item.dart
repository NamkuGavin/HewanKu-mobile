import '../../adopsi/widgets/hewan_model.dart';

class FavoritItem {
  final String imageUrl;
  final String namaHewan;
  final String namaShelter;
  final HewanModel hewan;

  const FavoritItem({
    required this.imageUrl,
    required this.namaHewan,
    required this.namaShelter,
    required this.hewan,
  });

  // Nama lengkap yang tampil: "Anjing Chiuhuahua, Shelter Abadi Hewan"
  String get judulLengkap => '$namaHewan, $namaShelter';
}
