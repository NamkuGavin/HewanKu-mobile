class DetailAdopsiRow {
  final String imageUrl;
  final String namaHewan;
  final String subNama;
  final String harga;

  const DetailAdopsiRow({
    required this.imageUrl,
    required this.namaHewan,
    required this.subNama,
    required this.harga,
  });
}

class PesananTerakhirItem {
  final String namaShelter;
  final String nomorInvoice;
  final String tanggal;
  final String statusLabel;
  final List<DetailAdopsiRow> detailAdopsi;
  final String totalBiaya;
  final String pesanTerimakasih;

  const PesananTerakhirItem({
    required this.namaShelter,
    required this.nomorInvoice,
    required this.tanggal,
    required this.statusLabel,
    required this.detailAdopsi,
    required this.totalBiaya,
    this.pesanTerimakasih =
        'Terima kasih telah menyelesaikan proses adopsi dengan baik',
  });
}
