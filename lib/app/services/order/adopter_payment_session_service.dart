// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../models/order/adopter_payment_session_model.dart';

class AdopterPaymentSessionService {
  AdopterPaymentSessionService._();

  static final AdopterPaymentSessionService instance =
      AdopterPaymentSessionService._();

  Map<int, AdopterPaymentSessionModel>? _cache;

  Future<Map<int, AdopterPaymentSessionModel>> getAllSessions() async {
    await _ensureLoaded();
    return Map<int, AdopterPaymentSessionModel>.from(_cache!);
  }

  Future<AdopterPaymentSessionModel?> getSession(int orderId) async {
    await _ensureLoaded();
    return _cache![orderId];
  }

  Future<AdopterPaymentSessionModel> startSession({
    required int orderId,
    Duration duration = const Duration(minutes: 15),
    bool restart = false,
  }) async {
    await _ensureLoaded();

    final existing = _cache![orderId];
    if (!restart && existing != null && !existing.isExpired) {
      return existing;
    }

    final now = DateTime.now();
    final session = AdopterPaymentSessionModel(
      orderId: orderId,
      startedAt: now,
      expiresAt: now.add(duration),
    );

    _cache![orderId] = session;
    await _persist();
    return session;
  }

  Future<void> clearSession(int orderId) async {
    await _ensureLoaded();
    if (_cache!.remove(orderId) != null) {
      await _persist();
    }
  }

  Future<void> clearAll() async {
    _cache = <int, AdopterPaymentSessionModel>{};
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
      _cache = <int, AdopterPaymentSessionModel>{};
      return;
    }

    try {
      final raw = await file.readAsString();
      if (raw.trim().isEmpty) {
        _cache = <int, AdopterPaymentSessionModel>{};
        return;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        _cache = <int, AdopterPaymentSessionModel>{};
        return;
      }

      _cache = <int, AdopterPaymentSessionModel>{};
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          final session = AdopterPaymentSessionModel.fromJson(item);
          if (session.orderId > 0) {
            _cache![session.orderId] = session;
          }
          continue;
        }

        if (item is Map) {
          final session = AdopterPaymentSessionModel.fromJson(
            Map<String, dynamic>.from(item),
          );
          if (session.orderId > 0) {
            _cache![session.orderId] = session;
          }
        }
      }
    } catch (_) {
      _cache = <int, AdopterPaymentSessionModel>{};
      await clearAll();
    }
  }

  Future<void> _persist() async {
    final file = await _getFile();
    final payload = _cache!.values.map((item) => item.toJson()).toList();
    await file.writeAsString(jsonEncode(payload), flush: true);
  }

  Future<File> _getFile() async {
    final directory = await getApplicationSupportDirectory();
    return File(
      '${directory.path}${Platform.pathSeparator}adopter_payment_sessions.json',
    );
  }
}
