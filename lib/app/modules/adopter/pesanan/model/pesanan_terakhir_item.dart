import 'package:flutter/material.dart';

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
  static const defaultPesanTerimakasih =
      'Terima kasih telah menyelesaikan proses adopsi dengan baik';

  final int orderId;
  final int animalId;
  final String animalName;
  final String namaShelter;
  final String nomorInvoice;
  final String tanggal;
  final String statusLabel;
  final Color statusColor;
  final List<DetailAdopsiRow> detailAdopsi;
  final String totalBiaya;
  final String pesanTerimakasih;
  final bool canReview;
  final String actionLabel;

  const PesananTerakhirItem({
    this.orderId = 0,
    this.animalId = 0,
    this.animalName = '',
    required this.namaShelter,
    required this.nomorInvoice,
    required this.tanggal,
    required this.statusLabel,
    this.statusColor = const Color(0xFF4CAF50),
    required this.detailAdopsi,
    required this.totalBiaya,
    this.pesanTerimakasih = defaultPesanTerimakasih,
    this.canReview = true,
    this.actionLabel = 'BERHASIL',
  });
}
