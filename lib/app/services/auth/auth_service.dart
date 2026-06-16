import '../../models/api/api_response_model.dart';
import '../../models/auth/auth_change_password_request_model.dart';
import '../../models/auth/auth_forgot_password_request_model.dart';
import '../../models/auth/auth_login_data_model.dart';
import '../../models/auth/auth_login_request_model.dart';
import '../../models/auth/auth_register_request_model.dart';
import '../../models/auth/auth_session_model.dart';
import '../../models/auth/auth_verify_otp_request_model.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../session/auth_session_service.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  Future<ApiResponseModel<Object?>> registerAdopter(AuthRegisterRequestModel request) {
    return ApiClient.instance.post<Object?>(path: ApiEndpoints.adopterRegister, body: request.toJson());
  }

  Future<ApiResponseModel<Object?>> forgotPasswordAdopter(AuthForgotPasswordRequestModel request) {
    return ApiClient.instance.post<Object?>(path: ApiEndpoints.adopterForgotPassword, body: request.toJson());
  }

  Future<ApiResponseModel<Object?>> verifyOtpAdopter(AuthVerifyOtpRequestModel request) {
    return ApiClient.instance.post<Object?>(path: ApiEndpoints.adopterVerifyOtp, body: request.toJson());
  }

  Future<ApiResponseModel<Object?>> changePasswordAdopter(AuthChangePasswordRequestModel request) {
    return ApiClient.instance.post<Object?>(path: ApiEndpoints.adopterChangePassword, body: request.toJson());
  }

  Future<AuthSessionModel> loginAdopter({required AuthLoginRequestModel request, required bool rememberMe}) async {
    final response = await ApiClient.instance.post<AuthLoginDataModel>(
      path: ApiEndpoints.adopterLogin,
      body: request.toJson(),
      dataParser: (rawData) {
        if (rawData is Map<String, dynamic>) {
          return AuthLoginDataModel.fromJson(rawData);
        }
        if (rawData is Map) {
          return AuthLoginDataModel.fromJson(Map<String, dynamic>.from(rawData));
        }
        return null;
      },
    );

    final data = response.data;
    if (data == null || data.token.isEmpty) {
      throw const FormatException('Token login tidak ditemukan pada response API.');
    }

    final session = AuthSessionModel.fromLoginData(data: data, role: 'adopter', rememberMe: rememberMe);

    if (rememberMe) {
      await AuthSessionService.instance.saveSession(session);
    } else {
      await AuthSessionService.instance.setMemoryOnlySession(session);
    }

    return session;
  }

  Future<bool> validateAdopterSession() async {
    final response = await ApiClient.instance.get<Object?>(
      path: ApiEndpoints.adopterProfile,
      requiresAuth: true,
      dataParser: (rawData) => rawData,
    );

    return response.isSuccessful;
  }

  Future<void> logoutAdopter() async {
    final hasSession = AuthSessionService.instance.hasSession;
    if (hasSession) {
      try {
        await ApiClient.instance.post<Object?>(path: ApiEndpoints.adopterLogout, requiresAuth: true);
      } catch (_) {
        // Session lokal tetap harus dibersihkan walaupun logout API gagal.
      }
    }

    await AuthSessionService.instance.clearSession();
  }
}
