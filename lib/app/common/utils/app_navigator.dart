import 'package:flutter/material.dart';

/// AppNavigator
/// -----------------------------------------------------------------------------
/// Helper class untuk mengatur semua navigasi aplikasi.
/// Tujuannya agar kode Navigator.push, pop, replace, dan reset stack
/// tidak ditulis berulang-ulang di setiap halaman.
///
/// Contoh pemakaian:
/// AppNavigator.push(context, const DetailPage());
/// AppNavigator.replace(context, const HomePage());
/// AppNavigator.pushAndRemoveAll(context, const LoginPage());
class AppNavigator {
  AppNavigator._();

  /// Membuat route standar menggunakan MaterialPageRoute.
  ///
  /// Fungsi ini dipisah agar jika nanti ingin mengganti animasi/transisi,
  /// cukup ubah di satu tempat saja.
  static Route<T> _buildRoute<T>(Widget page) {
    return MaterialPageRoute<T>(builder: (_) => page);
  }

  /// Pindah ke halaman baru.
  ///
  /// Halaman sebelumnya tetap ada di stack,
  /// sehingga user masih bisa kembali menggunakan tombol back.
  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.push<T>(context, _buildRoute<T>(page));
  }

  /// Mengganti halaman saat ini dengan halaman baru.
  ///
  /// Cocok digunakan setelah splash screen,
  /// onboarding, atau login berhasil.
  static Future<T?> replace<T, TO>(BuildContext context, Widget page, {TO? result}) {
    return Navigator.pushReplacement<T, TO>(context, _buildRoute<T>(page), result: result);
  }

  /// Pindah ke halaman baru dan menghapus semua halaman sebelumnya.
  ///
  /// Cocok digunakan untuk:
  /// - Setelah login menuju Home
  /// - Setelah logout menuju Login
  /// - Setelah selesai onboarding
  ///
  /// Dengan cara ini user tidak bisa kembali ke halaman sebelumnya
  /// menggunakan tombol back.
  static Future<T?> pushAndRemoveAll<T>(BuildContext context, Widget page) {
    return Navigator.pushAndRemoveUntil<T>(context, _buildRoute<T>(page), (Route<dynamic> route) => false);
  }

  /// Kembali ke halaman sebelumnya.
  ///
  /// Aman digunakan karena dicek dulu apakah Navigator masih bisa pop.
  static void pop<T>(BuildContext context, [T? result]) {
    if (Navigator.canPop(context)) {
      Navigator.pop<T>(context, result);
    }
  }

  /// Kembali sampai halaman pertama/root.
  ///
  /// Cocok digunakan jika ingin kembali ke halaman awal
  /// tanpa membuka halaman baru.
  static void popUntilFirst(BuildContext context) {
    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
  }

  /// Kembali sampai route dengan nama tertentu.
  ///
  /// Ini berguna kalau kamu memakai named route.
  static void popUntilRouteName(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  /// Mengecek apakah halaman saat ini bisa kembali.
  ///
  /// Bisa dipakai untuk custom back button.
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }
}
