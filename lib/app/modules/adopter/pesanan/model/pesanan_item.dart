import 'package:flutter/material.dart';

enum PesananStatus { sedangDiproses, berhasil, dibatalkan }

enum TimelineStatus { selesai, aktif, menunggu }

class TimelineStep {
  final String judul;
  final String? waktu;
  final TimelineStatus status;

  const TimelineStep({required this.judul, this.waktu, required this.status});
}

class DetailHewan {
  final String imageUrl;
  final String namaHewan;
  final String subNama;
  final String totalBiaya;

  const DetailHewan({
    required this.imageUrl,
    required this.namaHewan,
    required this.subNama,
    required this.totalBiaya,
  });
}

class PesananItem {
  final String namaShelter;
  final String nomorInvoice;
  final String tanggal;
  final String nomorOrder;
  final String infoOrder;
  final PesananStatus status;
  final DetailHewan hewan;
  final List<TimelineStep> timeline;
  final String perkiraanKedatangan;

  const PesananItem({
    required this.namaShelter,
    required this.nomorInvoice,
    required this.tanggal,
    required this.nomorOrder,
    required this.infoOrder,
    required this.status,
    required this.hewan,
    required this.timeline,
    required this.perkiraanKedatangan,
  });

  String get statusLabel {
    switch (status) {
      case PesananStatus.sedangDiproses:
        return 'Sedang Diproses';
      case PesananStatus.berhasil:
        return 'Berhasil';
      case PesananStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }

  Color get statusColor {
    switch (status) {
      case PesananStatus.sedangDiproses:
        return const Color(0xFFF87537);
      case PesananStatus.berhasil:
        return const Color(0xFF4CAF50);
      case PesananStatus.dibatalkan:
        return const Color(0xFFE53935);
    }
  }
}
