import '../../modules/adopter/adopsi/widgets/hewan_model.dart';

class AdopterHomeAnimalsModel {
  final List<AdopterFeaturedAnimalModel> hewanUnggulan;
  final List<AdopterFeaturedAnimalModel> rekomendasiUntukmu;
  final List<AdopterFeaturedAnimalModel> ratingTertinggi;
  final List<AdopterFeaturedAnimalModel> daftarFavorit;

  const AdopterHomeAnimalsModel({
    required this.hewanUnggulan,
    required this.rekomendasiUntukmu,
    required this.ratingTertinggi,
    this.daftarFavorit = const <AdopterFeaturedAnimalModel>[],
  });

  factory AdopterHomeAnimalsModel.fromJson(Map<String, dynamic> json) {
    final featuredItems = parseAdopterAnimalList(json['hewanUnggulan']);
    final recommendedItems = parseAdopterAnimalList(json['rekomendasiUntukmu']);
    final topRatedItems = parseAdopterAnimalList(json['ratingTertinggi']);
    final favoriteItems = parseAdopterAnimalList(json['daftarFavorit']);

    return AdopterHomeAnimalsModel(
      hewanUnggulan: featuredItems,
      rekomendasiUntukmu: recommendedItems,
      ratingTertinggi: topRatedItems,
      daftarFavorit: favoriteItems,
    );
  }

  List<HewanModel> get featuredAnimals => hewanUnggulan.map((item) => item.toHewanModel()).toList(growable: false);

  List<HewanModel> get recommendedAnimals => rekomendasiUntukmu.map((item) => item.toHewanModel()).toList(growable: false);

  List<HewanModel> get topRatedAnimals => ratingTertinggi.map((item) => item.toHewanModel()).toList(growable: false);

  List<HewanModel> get favoriteAnimals => daftarFavorit.map((item) => item.toHewanModel()).toList(growable: false);
}

class AdopterFeaturedAnimalModel {
  final int id;
  final double harga;
  final String jenis;
  final String nama;
  final double rating;
  final String status;
  final String updatedDate;
  final int umur;
  final String jenisKelamin;
  final String nomorTelepon;
  final String urlFoto;
  final int jumlahFavorit;
  final AdopterFeaturedShelterModel shelter;

  const AdopterFeaturedAnimalModel({
    required this.id,
    required this.harga,
    required this.jenis,
    required this.nama,
    required this.rating,
    required this.status,
    required this.updatedDate,
    required this.umur,
    required this.jenisKelamin,
    required this.nomorTelepon,
    required this.urlFoto,
    required this.jumlahFavorit,
    required this.shelter,
  });

  factory AdopterFeaturedAnimalModel.fromJson(Map<String, dynamic> json) {
    return AdopterFeaturedAnimalModel(
      id: _readInt(json['id']),
      harga: _readDouble(json['harga']),
      jenis: _cleanText(json['jenis']),
      nama: _cleanText(json['nama']),
      rating: _readDouble(json['rating']),
      status: _cleanText(json['status']),
      updatedDate: _cleanText(json['updatedDate']),
      umur: _readInt(json['umur']),
      jenisKelamin: _cleanText(json['jenisKelamin']),
      nomorTelepon: _cleanText(json['nomorTelepon']),
      urlFoto: _cleanText(json['urlFoto']),
      jumlahFavorit: _readInt(json['jumlahFavorit']),
      shelter: AdopterFeaturedShelterModel.fromJson(_readMap(json['shelter'])),
    );
  }

  HewanModel toHewanModel() {
    final kategori = jenis.isEmpty ? '-' : jenis;
    final kontakShelter = nomorTelepon.isNotEmpty ? nomorTelepon : shelter.noTelepon.trim();

    return HewanModel(
      id: id,
      name: nama.isEmpty ? 'Hewan Tanpa Nama' : nama,
      shelter: shelter.label,
      price: _formatRupiah(harga),
      rating: rating < 0 ? 0 : rating,
      reviewCount: 0,
      tags: kategori == '-' ? const [] : <String>[kategori],
      imageUrl: urlFoto,
      fallbackColorValue: _resolveFallbackColor(kategori),
      umur: umur > 0 ? '$umur Tahun' : '-',
      jenisKelamin: jenisKelamin.isEmpty ? '-' : jenisKelamin,
      kontakShelter: kontakShelter.isEmpty ? '-' : kontakShelter,
      kategori: kategori,
      statusAdopsi: status.isEmpty ? 'Belum diadopsi' : status,
    );
  }
}

AdopterFeaturedAnimalModel? parseAdopterAnimal(Object? rawItem) {
  if (rawItem is Map<String, dynamic>) {
    return AdopterFeaturedAnimalModel.fromJson(rawItem);
  }

  if (rawItem is Map) {
    return AdopterFeaturedAnimalModel.fromJson(Map<String, dynamic>.from(rawItem));
  }

  return null;
}

class AdopterFeaturedShelterModel {
  final String email;
  final String namaDepan;
  final String namaBelakang;
  final String displayName;
  final String nama;
  final String noTelepon;

  const AdopterFeaturedShelterModel({
    required this.email,
    required this.namaDepan,
    required this.namaBelakang,
    required this.displayName,
    required this.nama,
    required this.noTelepon,
  });

  factory AdopterFeaturedShelterModel.fromJson(Map<String, dynamic> json) {
    return AdopterFeaturedShelterModel(
      email: _cleanText(json['email']),
      namaDepan: _cleanText(json['namaDepan']),
      namaBelakang: _cleanText(json['namaBelakang']),
      displayName: _cleanText(json['displayName']),
      nama: _cleanText(json['nama']),
      noTelepon: _cleanText(json['noTelepon']),
    );
  }

  String get label {
    if (nama.isNotEmpty) {
      return nama;
    }
    if (displayName.isNotEmpty) {
      return displayName;
    }

    final fullName = '${namaDepan.trim()} ${namaBelakang.trim()}'.trim();
    if (fullName.isNotEmpty) {
      return fullName;
    }

    if (email.isNotEmpty) {
      return email;
    }

    return 'Shelter HewanKu';
  }
}

Map<String, dynamic> _readMap(Object? raw) {
  if (raw is Map<String, dynamic>) {
    return raw;
  }
  if (raw is Map) {
    return Map<String, dynamic>.from(raw);
  }
  return const <String, dynamic>{};
}

int _readInt(Object? raw) {
  if (raw is int) {
    return raw;
  }
  if (raw is num) {
    return raw.toInt();
  }
  if (raw is String) {
    return int.tryParse(raw.trim()) ?? 0;
  }
  return 0;
}

double _readDouble(Object? raw) {
  if (raw is double) {
    return raw;
  }
  if (raw is num) {
    return raw.toDouble();
  }
  if (raw is String) {
    return double.tryParse(raw.trim()) ?? 0;
  }
  return 0;
}

String _cleanText(Object? raw) {
  return raw?.toString().trim() ?? '';
}

List<AdopterFeaturedAnimalModel> parseAdopterAnimalList(Object? rawList) {
  return rawList is List
      ? rawList.whereType<Object?>().map(parseAdopterAnimal).whereType<AdopterFeaturedAnimalModel>().toList(growable: false)
      : const <AdopterFeaturedAnimalModel>[];
}

String _formatRupiah(double value) {
  final digits = value.round().toString();
  final buffer = StringBuffer();

  for (int index = 0; index < digits.length; index++) {
    final reverseIndex = digits.length - index;
    buffer.write(digits[index]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('.');
    }
  }

  return 'Rp $buffer';
}

int _resolveFallbackColor(String kategori) {
  switch (kategori.trim().toLowerCase()) {
    case 'anjing':
      return 0xFFD9C4AE;
    case 'kucing':
      return 0xFFE8DDD0;
    case 'kelinci':
      return 0xFFF2E5DA;
    case 'burung':
      return 0xFFD8E8F5;
    case 'hamster':
      return 0xFFE9D8C3;
    default:
      return 0xFFFFD8C0;
  }
}
