import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/news/data/models/news_model.dart';
import '../../features/news/domain/entitites/news.dart';

class NewsApiClient {
  final String apiKey = '2228c1ef987f47ad8b1d73b594ccdd00';
  final String apiUrl = 'https://newsapi.org/v2/everything?q=bitcoin&apiKey=';

  Future<List<NewsModel>> fetchNews() async {
    final response = await http.get(Uri.parse('$apiUrl$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articles = data['articles'] ?? []; // Ensure it's not null

      // Use fromApiResponse, not fromEntity
      return articles.map((json) => NewsModel.fromApiResponse(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }



}
