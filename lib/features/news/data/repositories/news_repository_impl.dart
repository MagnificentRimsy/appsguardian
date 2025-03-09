import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network-client.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_datasource.dart';
import '../models/news_model.dart';
import '../../domain/entitites/news.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsLocalDataSource localDataSource;
  final NewsApiClient apiClient;

  NewsRepositoryImpl(this.localDataSource, this.apiClient);

  @override
  Future<void> addNewsArticle(NewsArticle news) async {
    final newsModel = NewsModel.fromEntity(news);
    await localDataSource.addNews(newsModel);
  }

  @override
  Future<void> deleteNewsArticle(int index) async {
    await localDataSource.deleteNews(index);
  }

  @override
  Future<Either<Failure, List<NewsArticle>>> getNewsArticles() async {
    try {
      final List<NewsModel> newsModels = await apiClient.fetchNews();

      final List<NewsArticle> newsArticles = newsModels.map((newsModel) {
        return NewsArticle(
          title: newsModel.title,
          images: newsModel.images,
          content: newsModel.contents,
          date: newsModel.date,
          source: newsModel.source,
          author: newsModel.author,
          description: newsModel.description,
          url: newsModel.url,
        );
      }).toList();

      return Right(newsArticles);
    } catch (error) {
      print("Error: $error");
      // Return Left with the custom ServerFailure
      return Left(ServerFailure( error.toString()));  // Ensure this works as expected
    }
  }
}
