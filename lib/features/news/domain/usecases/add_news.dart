import '../entitites/news.dart';
import '../repositories/news_repository.dart';

class AddNews {
  final NewsRepository repository;

  AddNews(this.repository);

  Future<void> call(NewsArticle news) {
    return repository.addNewsArticle(news);
  }
}
