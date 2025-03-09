import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entitites/news.dart';
import '../repositories/news_repository.dart';

class GetNews {
  final NewsRepository repository;

  GetNews(this.repository);

  Future<Either<Failure, List<NewsArticle>>> call() {
    return repository.getNewsArticles();
  }
}
