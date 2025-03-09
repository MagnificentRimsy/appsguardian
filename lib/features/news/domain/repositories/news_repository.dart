import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entitites/news.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsArticle>>> getNewsArticles();
  Future<void> addNewsArticle(NewsArticle article);
  Future<void> deleteNewsArticle(int index);
}
