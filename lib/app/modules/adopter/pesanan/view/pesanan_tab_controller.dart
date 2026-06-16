import 'package:flutter/material.dart';

class PesananTabController {
  PesananTabController._();

  static final ValueNotifier<int> selectedTab = ValueNotifier<int>(0);
  static final ValueNotifier<int> refreshTick = ValueNotifier<int>(0);

  static void openPesananSaya({bool refresh = false}) {
    selectedTab.value = 0;
    if (refresh) {
      requestRefresh();
    }
  }

  static void openPesananTerakhir({bool refresh = false}) {
    selectedTab.value = 1;
    if (refresh) {
      requestRefresh();
    }
  }

  static void requestRefresh() => refreshTick.value++;
}
