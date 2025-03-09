import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/news_model.dart';
import '../../domain/entitites/news.dart';
import '../../domain/usecases/add_news.dart';
import '../../domain/usecases/delete_news.dart';
import '../../domain/usecases/get_news.dart';
import 'news_provider.dart';

class NewsListNotifier extends StateNotifier<AsyncValue<List<NewsModel>>> {
  final Ref ref;
  final GetNews _getNews;
  final AddNews _addNews;
  final DeleteNews _deleteNews;

  NewsListNotifier(this.ref)
      : _getNews = ref.read(getNewsProvider),
        _addNews = ref.read(addNewsProvider),
        _deleteNews = ref.read(deleteNewsProvider),
        super(const AsyncValue.loading());

  Future<void> loadNewsArticles() async {
    try {
      // Wait for the local data source to be available
      final newsLocalDataSourceAsync = ref.watch(newsLocalDataSourceProvider);

      final newsLocalDataSource = newsLocalDataSourceAsync.when(
        data: (data) => data,
        loading: () => throw Exception("Loading local data source..."),
        error: (error, stack) => throw Exception("Failed to load local data source: $error"),
      );

      await newsLocalDataSource.loadNewsFromApi(); // ✅ Properly accessing method
      final fetchedNews = newsLocalDataSource.getNews() ?? []; // ✅ Properly accessing method

      print("Fetched news: $fetchedNews");
      state = AsyncValue.data(fetchedNews);
    } catch (e, stack) {
      state = AsyncValue.error(e.toString(), stack);
    }
  }

  Future<void> addNewsArticle(NewsArticle news) async {
    try {
      await _addNews(news);
      await loadNewsArticles(); // Reload news after adding a new article
    } catch (e, stack) {
      state = AsyncValue.error(e.toString(), stack);
      print('Error adding news: ${e.toString()}');
    }
  }

  Future<void> removeNews(int newsId) async {
    try {
      await _deleteNews(newsId);
      await loadNewsArticles(); // Reload news after deletion
    } catch (e, stack) {
      state = AsyncValue.error(e.toString(), stack);
      print('Error removing news: ${e.toString()}');
    }
  }
}
