import '../../models/home/adopter_news_model.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';

class AdopterNewsService {
  AdopterNewsService._();

  static final AdopterNewsService instance = AdopterNewsService._();

  Future<List<AdopterNewsArticleModel>> getRandomNews() async {
    final response = await ApiClient.instance.get<AdopterNewsModel>(
      path: ApiEndpoints.adopterRandomNews,
      requiresAuth: true,
      dataParser: (rawData) => AdopterNewsModel.fromJson(rawData),
    );

    final data = response.data;
    if (data == null) {
      return const <AdopterNewsArticleModel>[];
    }

    final sortedArticles = [...data.articles]..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return sortedArticles;
  }
}
