import 'package:flutter/material.dart';

/// Kontrol tab NavbarView dari mana saja tanpa callback chain.
/// Cara pakai:
/// ```dart
/// NavbarController.goTo(2); // pindah ke tab Pesanan
/// ```
class NavbarController {
  NavbarController._();
  static final ValueNotifier<int> tabIndex = ValueNotifier<int>(0);
  static void goTo(int index) => tabIndex.value = index;
}
