// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AdopterReviewStateService {
  AdopterReviewStateService._();

  static final AdopterReviewStateService instance =
      AdopterReviewStateService._();

  Set<int>? _cache;

  Future<Set<int>> getReviewedOrderIds() async {
    await _ensureLoaded();
    return Set<int>.from(_cache!);
  }

  Future<bool> isReviewed(int orderId) async {
    await _ensureLoaded();
    return _cache!.contains(orderId);
  }

  Future<void> markReviewed(int orderId) async {
    if (orderId <= 0) {
      return;
    }

    await _ensureLoaded();
    if (_cache!.add(orderId)) {
      await _persist();
    }
  }

  Future<void> clearAll() async {
    _cache = <int>{};
    final file = await _getFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> _ensureLoaded() async {
    if (_cache != null) {
      return;
    }

    final file = await _getFile();
    if (!await file.exists()) {
      _cache = <int>{};
      return;
    }

    try {
      final raw = await file.readAsString();
      if (raw.trim().isEmpty) {
        _cache = <int>{};
        return;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        _cache = <int>{};
        return;
      }

      _cache = decoded
          .map((item) => _readInt(item))
          .where((value) => value > 0)
          .toSet();
    } catch (_) {
      _cache = <int>{};
      await clearAll();
    }
  }

  Future<void> _persist() async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(_cache!.toList()), flush: true);
  }

  Future<File> _getFile() async {
    final directory = await getApplicationSupportDirectory();
    return File(
      '${directory.path}${Platform.pathSeparator}adopter_reviewed_orders.json',
    );
  }
}

int _readInt(Object? raw) {
  if (raw is int) {
    return raw;
  }
  if (raw is num) {
    return raw.toInt();
  }
  if (raw is String) {
    return int.tryParse(raw.trim()) ?? 0;
  }
  return 0;
}
