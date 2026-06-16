import '../../models/home/adopter_animal_filter_request_model.dart';
import '../../models/home/adopter_home_animals_model.dart';
import '../../modules/adopter/adopsi/widgets/hewan_model.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

class AdopterHomeService {
  AdopterHomeService._();

  static final AdopterHomeService instance = AdopterHomeService._();

  Future<AdopterHomeAnimalsModel> getAnimalSections() async {
    final response = await ApiClient.instance.get<AdopterHomeAnimalsModel>(
      path: ApiEndpoints.adopterHomeAnimals,
      requiresAuth: true,
      dataParser: (rawData) {
        if (rawData is Map<String, dynamic>) {
          return AdopterHomeAnimalsModel.fromJson(rawData);
        }
        if (rawData is Map) {
          return AdopterHomeAnimalsModel.fromJson(Map<String, dynamic>.from(rawData));
        }
        return const AdopterHomeAnimalsModel(
          hewanUnggulan: <AdopterFeaturedAnimalModel>[],
          rekomendasiUntukmu: <AdopterFeaturedAnimalModel>[],
          ratingTertinggi: <AdopterFeaturedAnimalModel>[],
        );
      },
    );

    return response.data ??
        const AdopterHomeAnimalsModel(
          hewanUnggulan: <AdopterFeaturedAnimalModel>[],
          rekomendasiUntukmu: <AdopterFeaturedAnimalModel>[],
          ratingTertinggi: <AdopterFeaturedAnimalModel>[],
        );
  }

  Future<List<HewanModel>> getFeaturedAnimals() async {
    final sections = await getAnimalSections();
    return sections.featuredAnimals;
  }

  Future<List<HewanModel>> getRecommendedAnimals() async {
    final sections = await getAnimalSections();
    return sections.recommendedAnimals;
  }

  Future<List<HewanModel>> getTopRatedAnimals() async {
    final sections = await getAnimalSections();
    return sections.topRatedAnimals;
  }

  Future<HewanModel> getAnimalDetail(int id) async {
    final response = await ApiClient.instance.get<HewanModel>(
      path: ApiEndpoints.adopterAnimalDetail(id),
      requiresAuth: true,
      dataParser: (rawData) {
        final item = parseAdopterAnimal(rawData);
        return item?.toHewanModel();
      },
    );

    final animal = response.data;
    if (animal == null) {
      throw const FormatException('Data detail hewan tidak ditemukan pada response API.');
    }

    return animal;
  }

  Future<List<HewanModel>> filterAnimals(AdopterAnimalFilterRequestModel request) async {
    final response = await ApiClient.instance.get<List<HewanModel>>(
      path: ApiEndpoints.adopterFilterAnimals,
      body: request.toJson(),
      requiresAuth: true,
      dataParser: (rawData) {
        final items = parseAdopterAnimalList(rawData);
        return items.map((item) => item.toHewanModel()).toList(growable: false);
      },
    );

    return response.data ?? const <HewanModel>[];
  }
}
