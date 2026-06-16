import 'package:flutter/material.dart';

class AdopsiNavigationRequest {
  final String category;
  final int requestId;

  const AdopsiNavigationRequest({
    required this.category,
    required this.requestId,
  });
}

class AdopsiSearchNavigationRequest {
  final String query;
  final int requestId;

  const AdopsiSearchNavigationRequest({
    required this.query,
    required this.requestId,
  });
}

class AdopsiNavigationController {
  AdopsiNavigationController._();

  static final ValueNotifier<AdopsiNavigationRequest?> categoryRequest =
      ValueNotifier<AdopsiNavigationRequest?>(null);
  static final ValueNotifier<AdopsiSearchNavigationRequest?> searchRequest =
      ValueNotifier<AdopsiSearchNavigationRequest?>(null);

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

  static void openSearch({String query = ''}) {
    searchRequest.value = AdopsiSearchNavigationRequest(
      query: query.trim(),
      requestId: DateTime.now().microsecondsSinceEpoch,
    );
  }
}
