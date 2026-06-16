// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/app_snackbar.dart';
import '../../models/api/api_response_model.dart';
import '../navigation/app_router_service.dart';
import '../session/auth_session_service.dart';
import 'api_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  final http.Client _client = http.Client();
  bool _isHandlingUnauthorized = false;

  Future<ApiResponseModel<T>> get<T>({
    required String path,
    bool requiresAuth = false,
    Object? body,
    T? Function(Object? rawData)? dataParser,
  }) {
    return _send<T>(method: 'GET', path: path, body: body, requiresAuth: requiresAuth, dataParser: dataParser);
  }

  Future<ApiResponseModel<T>> post<T>({
    required String path,
    Object? body,
    bool requiresAuth = false,
    T? Function(Object? rawData)? dataParser,
  }) {
    return _send<T>(method: 'POST', path: path, body: body, requiresAuth: requiresAuth, dataParser: dataParser);
  }

  Future<ApiResponseModel<T>> patch<T>({
    required String path,
    Object? body,
    bool requiresAuth = false,
    T? Function(Object? rawData)? dataParser,
  }) {
    return _send<T>(method: 'PATCH', path: path, body: body, requiresAuth: requiresAuth, dataParser: dataParser);
  }

  Future<ApiResponseModel<T>> _send<T>({
    required String method,
    required String path,
    Object? body,
    required bool requiresAuth,
    T? Function(Object? rawData)? dataParser,
  }) async {
    _logRequest(method: method, path: path, requiresAuth: requiresAuth);

    final headers = <String, String>{'Accept': 'application/json', 'Content-Type': 'application/json'};

    if (requiresAuth) {
      final session = AuthSessionService.instance.currentSession;
      if (session == null) {
        await _handleUnauthorized('Sesi tidak ditemukan. Silakan login kembali.');
        throw const ApiException(message: 'Sesi tidak ditemukan. Silakan login kembali.', isUnauthorized: true);
      }

      if (session.isExpired) {
        await _handleUnauthorized('Sesi kamu sudah berakhir. Silakan login kembali.');
        throw const ApiException(message: 'Sesi kamu sudah berakhir. Silakan login kembali.', isUnauthorized: true);
      }

      headers['Authorization'] = 'Bearer ${session.token}';
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final payload = body == null ? null : jsonEncode(body);

    late http.Response response;
    try {
      switch (method) {
        case 'GET':
          if (payload == null) {
            response = await _client.get(uri, headers: headers);
          } else {
            final request = http.Request(method, uri)
              ..headers.addAll(headers)
              ..body = payload;
            response = await http.Response.fromStream(await _client.send(request));
          }
          break;
        case 'POST':
          response = await _client.post(uri, headers: headers, body: payload);
          break;
        case 'PATCH':
          response = await _client.patch(uri, headers: headers, body: payload);
          break;
        default:
          throw ApiException(message: 'HTTP method tidak didukung: $method');
      }
    } catch (error) {
      _logTransportFailure(method: method, path: path, error: error);
      throw const ApiException(message: 'Gagal terhubung ke server. Periksa koneksi internet kamu.');
    }

    final parsedBody = _tryDecode(response.body);
    final envelope = parsedBody is Map<String, dynamic>
        ? ApiResponseModel<T>.fromJson(parsedBody, dataParser: dataParser)
        : ApiResponseModel<T>(
            code: response.statusCode,
            status: null,
            message: null,
            data: dataParser != null ? dataParser(parsedBody) : parsedBody as T?,
            errors: null,
          );

    final unauthorized = _isUnauthorized(response.statusCode, envelope);
    if (requiresAuth && unauthorized) {
      _logResponse(method: method, path: path, statusCode: response.statusCode, response: envelope, unauthorized: true);
      await _handleUnauthorized(_resolveMessage(response.statusCode, envelope, parsedBody));
      throw ApiException(
        message: _resolveMessage(response.statusCode, envelope, parsedBody),
        statusCode: response.statusCode,
        apiCode: envelope.code,
        errors: envelope.errors,
        isUnauthorized: true,
      );
    }

    final success = _isSuccessful(response.statusCode, envelope);
    if (!success) {
      _logResponse(method: method, path: path, statusCode: response.statusCode, response: envelope, unauthorized: false);
      throw ApiException(
        message: _resolveMessage(response.statusCode, envelope, parsedBody),
        statusCode: response.statusCode,
        apiCode: envelope.code,
        errors: envelope.errors,
      );
    }

    _logResponse(method: method, path: path, statusCode: response.statusCode, response: envelope, unauthorized: false);
    return envelope;
  }

  void _logRequest({required String method, required String path, required bool requiresAuth}) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('[API] $method $path auth=$requiresAuth');
  }

  void _logTransportFailure({required String method, required String path, required Object error}) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('[API] $method $path transport_error=$error');
  }

  void _logResponse<T>({
    required String method,
    required String path,
    required int statusCode,
    required ApiResponseModel<T> response,
    required bool unauthorized,
  }) {
    if (!kDebugMode) {
      return;
    }

    final message = response.message?.trim();
    final normalizedMessage = message == null || message.isEmpty ? '-' : message;
    debugPrint(
      '[API] $method $path status=$statusCode code=${response.code} '
      'apiStatus=${response.status ?? '-'} unauthorized=$unauthorized '
      'message=$normalizedMessage',
    );
  }

  Object? _tryDecode(String body) {
    if (body.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
      return decoded;
    } catch (_) {
      return body;
    }
  }

  bool _isSuccessful<T>(int statusCode, ApiResponseModel<T> response) {
    final okHttp = statusCode == 200 || statusCode == 201;
    final okEnvelope =
        response.isSuccessful ||
        ((response.code == null || response.code == 200 || response.code == 201) &&
            !response.hasFailureStatus &&
            response.errors == null);
    return okHttp && okEnvelope;
  }

  bool _isUnauthorized<T>(int statusCode, ApiResponseModel<T> response) {
    if (statusCode == 401 || statusCode == 403) {
      return true;
    }

    final apiCode = response.code;
    if (apiCode == 401 || apiCode == 403) {
      return true;
    }

    final normalizedStatus = response.status?.trim().toUpperCase();
    return normalizedStatus == 'UNAUTHORIZED' || normalizedStatus == 'FORBIDDEN';
  }

  String _resolveMessage<T>(int statusCode, ApiResponseModel<T> response, Object? parsedBody) {
    final message = response.message?.trim();
    if (message != null && message.isNotEmpty) {
      return message;
    }

    if (response.errors is String && (response.errors as String).trim().isNotEmpty) {
      return (response.errors as String).trim();
    }

    if (parsedBody is Map<String, dynamic>) {
      final error = parsedBody['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error.trim();
      }
    }

    switch (statusCode) {
      case 200:
      case 201:
        return 'Permintaan berhasil.';
      case 400:
        return 'Permintaan tidak valid.';
      case 401:
        return 'Sesi kamu tidak valid. Silakan login kembali.';
      case 403:
        return 'Akses ditolak atau sesi sudah berakhir. Silakan login kembali.';
      case 404:
        return 'Endpoint tidak ditemukan.';
      case 500:
        return 'Terjadi kesalahan pada server.';
      default:
        return 'Terjadi kesalahan saat memproses permintaan.';
    }
  }

  Future<void> _handleUnauthorized(String message) async {
    if (_isHandlingUnauthorized) {
      return;
    }

    _isHandlingUnauthorized = true;
    await AuthSessionService.instance.clearSession();
    await AppRouterService.goToAdopterLogin(message: message, type: AppSnackbarType.warning);
    _isHandlingUnauthorized = false;
  }
}
