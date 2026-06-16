import 'package:flutter/material.dart';

class AdopsiNavigationRequest {
  final String category;
  final int requestId;

  const AdopsiNavigationRequest({required this.category, required this.requestId});
}

class AdopsiNavigationController {
  AdopsiNavigationController._();

  static final ValueNotifier<AdopsiNavigationRequest?> categoryRequest = ValueNotifier<AdopsiNavigationRequest?>(null);

  static void filterByCategory(String category) {
    final normalizedCategory = category.trim();
    if (normalizedCategory.isEmpty) {
      return;
    }

    categoryRequest.value = AdopsiNavigationRequest(
      category: normalizedCategory,
      requestId: DateTime.now().microsecondsSinceEpoch,
    );
  }
}
