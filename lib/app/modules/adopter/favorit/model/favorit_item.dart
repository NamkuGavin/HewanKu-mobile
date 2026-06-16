import '../../adopsi/widgets/hewan_model.dart';

class FavoritItem {
  final String imageUrl;
  final String namaHewan;
  final String namaShelter;
  final HewanModel hewan;

  const FavoritItem({required this.imageUrl, required this.namaHewan, required this.namaShelter, required this.hewan});

  String get judulLengkap => '$namaHewan, $namaShelter';
  int get id => hewan.id;

  factory FavoritItem.fromHewanModel(HewanModel hewan) {
    return FavoritItem(imageUrl: hewan.imageUrl, namaHewan: hewan.name, namaShelter: hewan.shelter, hewan: hewan);
  }
}
