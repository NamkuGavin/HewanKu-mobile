class AdopterAnimalFilterRequestModel {
  final String? jenis;
  final int hargaMin;
  final int hargaMax;

  const AdopterAnimalFilterRequestModel({required this.jenis, required this.hargaMin, required this.hargaMax});

  bool get hasJenis => jenis != null && jenis!.trim().isNotEmpty;
  bool get hasHarga => hargaMin >= 0 || hargaMax >= 0;
  bool get hasAnyFilter => hasJenis || hasHarga;

  Map<String, dynamic> toJson() {
    return {'jenis': hasJenis ? jenis : null, 'hargaMin': hasHarga ? hargaMin : -1, 'hargaMax': hasHarga ? hargaMax : -1};
  }
}
