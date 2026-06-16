import '../../models/api/api_response_model.dart';
import '../../models/review/adopter_animal_review_model.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

class AdopterReviewService {
  AdopterReviewService._();

  static final AdopterReviewService instance = AdopterReviewService._();

  Future<AdopterAnimalReviewModel> getAnimalReviews(int animalId) async {
    final response = await ApiClient.instance.get<AdopterAnimalReviewModel>(
      path: ApiEndpoints.adopterAnimalReviews(animalId),
      requiresAuth: true,
      dataParser: (rawData) {
        if (rawData is Map<String, dynamic>) {
          return AdopterAnimalReviewModel.fromJson(rawData);
        }
        if (rawData is Map) {
          return AdopterAnimalReviewModel.fromJson(Map<String, dynamic>.from(rawData));
        }
        return const AdopterAnimalReviewModel.empty();
      },
    );

    return response.data ?? const AdopterAnimalReviewModel.empty();
  }

  Future<ApiResponseModel<Object?>> createReview({required int animalId, required double rating, String? comment}) {
    return ApiClient.instance.post<Object?>(
      path: ApiEndpoints.adopterCreateReview(animalId),
      requiresAuth: true,
      body: <String, dynamic>{'komen': (comment ?? '').trim(), 'rating': rating},
      dataParser: (rawData) => rawData,
    );
  }
}
