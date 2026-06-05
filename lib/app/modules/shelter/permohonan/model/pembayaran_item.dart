import 'package:flutter/material.dart';

enum StatusPembayaran { berhasil, dibatalkan, menunggu }

class PembayaranItem {
  final String namaHewan;
  final String jenisHewan;
  final String umur;
  final String namaAdopter;
  final String metodePembayaran; // "QRIS", "Transfer Bank"
  final String waktu;
  final String totalBayar;
  final StatusPembayaran status;
  final String? imageUrl;

  const PembayaranItem({
    required this.namaHewan,
    required this.jenisHewan,
    required this.umur,
    required this.namaAdopter,
    required this.metodePembayaran,
    required this.waktu,
    required this.totalBayar,
    required this.status,
    this.imageUrl,
  });

  String get statusLabel {
    switch (status) {
      case StatusPembayaran.berhasil:
        return 'BERHASIL';
      case StatusPembayaran.dibatalkan:
        return 'DIBATALKAN';
      case StatusPembayaran.menunggu:
        return 'MENUNGGU';
    }
  }

  Color get statusColor {
    switch (status) {
      case StatusPembayaran.berhasil:
        return const Color(0xFF4CAF50);
      case StatusPembayaran.dibatalkan:
        return const Color(0xFF9E9E9E);
      case StatusPembayaran.menunggu:
        return const Color(0xFFF87537);
    }
  }
}
