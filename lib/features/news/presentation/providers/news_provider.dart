import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:dartz/dartz.dart';  // For Either type
import '../../data/datasources/news_local_datasource.dart';
import '../../data/models/news_model.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/entitites/news.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/usecases/add_news.dart';
import '../../domain/usecases/delete_news.dart';
import '../../domain/usecases/get_news.dart';
import '../../../../core/services/network-client.dart';
import 'news_notifier.dart'; // Assuming NewsApiClient is here

// Providers for local data source, repository, and use cases
final newsApiClientProvider = Provider<NewsApiClient>((ref) {
  return NewsApiClient();  // Initialize your API client here
});

final newsLocalDataSourceProvider = FutureProvider<NewsLocalDataSource>((ref) async {
  final Box<NewsModel> newsBox = await Hive.openBox<NewsModel>('news');
  final newsApiClient = ref.read(newsApiClientProvider);
  return NewsLocalDataSource(newsBox, newsApiClient);
});




final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final localDataSourceAsync = ref.watch(newsLocalDataSourceProvider);
  final apiClient = ref.watch(newsApiClientProvider);

  return localDataSourceAsync.when(
    data: (localDataSource) {
      return NewsRepositoryImpl(localDataSource, apiClient);
    },
    loading: () {
      throw Exception("Loading local data source...");
    },
    error: (error, stack) {
      throw Exception("Failed to load local data source: $error");
    },
  );
});




final getNewsProvider = Provider<GetNews>((ref) {
  final repository = ref.read(newsRepositoryProvider);
  return GetNews(repository);
});

final addNewsProvider = Provider<AddNews>((ref) {
  final repository = ref.read(newsRepositoryProvider);
  return AddNews(repository);
});

final deleteNewsProvider = Provider<DeleteNews>((ref) {
  final repository = ref.read(newsRepositoryProvider);
  return DeleteNews(repository);
});

// Provider to manage loading state
final newsLoadingProvider = StateProvider<bool>((ref) => false);

// This provider will manage fetching news from the repository and handle the loading state.
final newsListNotifierProvider = StateNotifierProvider<NewsListNotifier, AsyncValue<List<NewsModel>>>(
      (ref) => NewsListNotifier(ref),
);
