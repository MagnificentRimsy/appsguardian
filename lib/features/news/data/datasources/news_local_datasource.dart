import 'package:appsguardian/features/news/domain/entitites/news.dart';
import 'package:hive/hive.dart';
import '../../../../core/services/network-client.dart';
import '../models/news_model.dart';

class NewsLocalDataSource {
  final Box<NewsModel> newsBox; // Corrected to NewsModel as it's stored in Hive
  final NewsApiClient newsApiClient;

  NewsLocalDataSource(this.newsBox, this.newsApiClient);

  List<NewsModel> getNews() {
    // Return NewsModel list, since that's what's stored in Hive
    return newsBox.values.toList();
  }

  Future<void> loadNewsFromApi() async {
    try {
      final newsList = await newsApiClient.fetchNews();
      for (var news in newsList) {
        // Convert NewsArticle to NewsModel before saving to Hive
        final newsModel = NewsModel.fromEntity(news as NewsArticle);
        addNews(newsModel); // Save to local database (Hive)
      }
    } catch (e) {
      print('Error loading news from API: $e');
    }
  }

  Future<void> addNews(NewsModel news) async{
    // Save the NewsModel to Hive
    await newsBox.add(news);
  }

  Future<void> deleteNews(int index) async {
    // Delete the news from Hive
   await newsBox.deleteAt(index);
  }
}
