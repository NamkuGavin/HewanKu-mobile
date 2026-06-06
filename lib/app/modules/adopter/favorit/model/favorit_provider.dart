import 'package:flutter/material.dart';
import 'favorit_item.dart';

/// Cara pakai:
/// 1. Wrap MaterialApp atau root widget dengan FavoritProvider
/// 2. Akses dari mana saja via: FavoritProvider.of(context)
class FavoritProvider extends InheritedNotifier<ValueNotifier<List<FavoritItem>>> {
  const FavoritProvider({
    super.key,
    required super.notifier,
    required super.child,
  });

  static ValueNotifier<List<FavoritItem>> of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<FavoritProvider>();
    assert(provider != null, 'FavoritProvider tidak ditemukan di widget tree.');
    return provider!.notifier!;
  }

  static void tambah(BuildContext context, FavoritItem item) {
    final notifier = of(context);
    final list = List<FavoritItem>.from(notifier.value);
    // Cek duplikat berdasarkan namaHewan
    if (!list.any((f) => f.namaHewan == item.namaHewan)) {
      notifier.value = [...list, item];
    }
  }

  static void hapus(BuildContext context, FavoritItem item) {
    final notifier = of(context);
    notifier.value = notifier.value
        .where((f) => f.namaHewan != item.namaHewan)
        .toList();
  }

  static bool isFavorit(BuildContext context, String namaHewan) {
    final notifier = of(context);
    return notifier.value.any((f) => f.namaHewan == namaHewan);
  }
}