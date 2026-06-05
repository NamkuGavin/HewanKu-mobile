import 'package:flutter/material.dart';

import 'pesanan_item.dart';

/// Cara pakai:
/// 1. Wrap di main.dart: PesananProvider(notifier: ValueNotifier([]), child: ...)
/// 2. Tambah item: PesananProvider.tambah(context, item)
class PesananProvider extends InheritedNotifier<ValueNotifier<List<PesananItem>>> {
  const PesananProvider({
    super.key,
    required super.notifier,
    required super.child,
  });

  static ValueNotifier<List<PesananItem>> of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<PesananProvider>();
    assert(provider != null, 'PesananProvider tidak ditemukan di widget tree.');
    return provider!.notifier!;
  }

  static void tambah(BuildContext context, PesananItem item) {
    final notifier = of(context);
    notifier.value = [item, ...notifier.value];
  }
}