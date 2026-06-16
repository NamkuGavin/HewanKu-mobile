import '../../models/profile/adopter_profile_model.dart';
import '../../models/profile/adopter_profile_update_request_model.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../session/auth_session_service.dart';

class AdopterProfileService {
  AdopterProfileService._();

  static final AdopterProfileService instance = AdopterProfileService._();

  Future<AdopterProfileModel> getProfile() async {
    final response = await ApiClient.instance.get<AdopterProfileModel>(
      path: ApiEndpoints.adopterProfile,
      requiresAuth: true,
      dataParser: _profileParser,
    );

    final profile = response.data;
    if (profile == null) {
      throw const FormatException('Data profil tidak ditemukan pada response API.');
    }

    return profile;
  }

  Future<AdopterProfileModel> updateProfile(AdopterProfileUpdateRequestModel request) async {
    await ApiClient.instance.patch<Object?>(
      path: ApiEndpoints.adopterEditProfile,
      body: request.toJson(),
      requiresAuth: true,
      dataParser: (rawData) => rawData,
    );

    final profile = await getProfile();
    await AuthSessionService.instance.updateSessionEmail(profile.email);
    return profile;
  }

  AdopterProfileModel? _profileParser(Object? rawData) {
    if (rawData is Map<String, dynamic>) {
      return AdopterProfileModel.fromJson(rawData);
    }

    if (rawData is Map) {
      return AdopterProfileModel.fromJson(Map<String, dynamic>.from(rawData));
    }

    return null;
  }
}
