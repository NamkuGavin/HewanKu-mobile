import '../../models/api/api_response_model.dart';
import '../../models/home/adopter_home_animals_model.dart';
import '../../modules/adopter/favorit/model/favorit_item.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

class AdopterFavoriteService {
  AdopterFavoriteService._();

  static final AdopterFavoriteService instance = AdopterFavoriteService._();

  Future<List<FavoritItem>> getFavorites() async {
    final response = await ApiClient.instance.get<List<FavoritItem>>(
      path: ApiEndpoints.adopterHomeAnimals,
      requiresAuth: true,
      dataParser: _favoriteListParser,
    );

    return response.data ?? const <FavoritItem>[];
  }

  Future<ApiResponseModel<Object?>> addFavorite(int animalId) {
    return ApiClient.instance.patch<Object?>(
      path: ApiEndpoints.adopterAddFavorite(animalId),
      requiresAuth: true,
      dataParser: (rawData) => rawData,
    );
  }

  Future<ApiResponseModel<Object?>> removeFavorite(int animalId) {
    return ApiClient.instance.patch<Object?>(
      path: ApiEndpoints.adopterDeleteFavorite(animalId),
      requiresAuth: true,
      dataParser: (rawData) => rawData,
    );
  }

  List<FavoritItem>? _favoriteListParser(Object? rawData) {
    if (rawData is! Map && rawData is! Map<String, dynamic>) {
      return const <FavoritItem>[];
    }

    final json = rawData is Map<String, dynamic> ? rawData : Map<String, dynamic>.from(rawData as Map);
    final items = parseAdopterAnimalList(json['daftarFavorit']);
    return items.map((item) => FavoritItem.fromHewanModel(item.toHewanModel())).toList(growable: false);
  }
}
