// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../models/auth/auth_session_model.dart';

class AuthSessionService {
  AuthSessionService._();

  static final AuthSessionService instance = AuthSessionService._();

  AuthSessionModel? _currentSession;

  AuthSessionModel? get currentSession => _currentSession;
  bool get hasSession => _currentSession != null;

  Future<void> restorePersistedSession() async {
    final file = await _getSessionFile();
    if (!await file.exists()) {
      _currentSession = null;
      return;
    }

    try {
      final raw = await file.readAsString();
      if (raw.trim().isEmpty) {
        _currentSession = null;
        return;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        _currentSession = null;
        return;
      }

      _currentSession = AuthSessionModel.fromJson(decoded);
    } catch (_) {
      _currentSession = null;
      await clearSession();
    }
  }

  Future<void> saveSession(AuthSessionModel session) async {
    _currentSession = session;

    if (!session.rememberMe) {
      await _deletePersistedSession();
      return;
    }

    final file = await _getSessionFile();
    await file.writeAsString(jsonEncode(session.toJson()), flush: true);
  }

  Future<void> clearSession() async {
    _currentSession = null;
    await _deletePersistedSession();
  }

  Future<void> setMemoryOnlySession(AuthSessionModel session) async {
    _currentSession = session;
    await _deletePersistedSession();
  }

  Future<void> updateSessionEmail(String email) async {
    final session = _currentSession;
    if (session == null) {
      return;
    }

    final normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty || normalizedEmail == session.email) {
      return;
    }

    await saveSession(session.copyWith(email: normalizedEmail));
  }

  Future<void> _deletePersistedSession() async {
    final file = await _getSessionFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<File> _getSessionFile() async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}${Platform.pathSeparator}adopter_session.json');
  }
}
