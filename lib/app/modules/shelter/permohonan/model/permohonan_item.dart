enum StatusPermohonan { pending, disetujui, ditolak }

class PermohonanItem {
  final String id;
  final String namaHewan;
  final String jenisHewan;
  final String namaAdopter;
  final String namaFile;
  final String waktu;
  final String? imageUrl;
  StatusPermohonan status;

  PermohonanItem({
    required this.id,
    required this.namaHewan,
    required this.jenisHewan,
    required this.namaAdopter,
    required this.namaFile,
    required this.waktu,
    this.imageUrl,
    this.status = StatusPermohonan.pending,
  });

  // Label tampil: "Luna (Golden Retriever)"
  String get judulHewan => '$namaHewan ($jenisHewan)';
}
