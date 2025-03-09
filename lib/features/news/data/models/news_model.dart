import 'package:hive/hive.dart';
import '../../domain/entitites/news.dart';

@HiveType(typeId: 0)
class NewsModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final List<String> images;

  @HiveField(2)
  final String contents;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String source;

  @HiveField(5)
  final String author;

  @HiveField(6)
  final String description;

  @HiveField(7)
  final String url;

  NewsModel({
    required this.title,
    required this.images,
    required this.contents,
    required this.date,
    required this.source,
    required this.author,
    required this.description,
    required this.url,
  });

  // Conversion from API response to Model
  factory NewsModel.fromApiResponse(Map<String, dynamic> apiResponse) {
    return NewsModel(
      title: apiResponse['title'] ?? 'No Title',
      images: apiResponse['urlToImage'] != null ? [apiResponse['urlToImage']] : [],
      contents: apiResponse['content'] ?? 'No content available',
      date: apiResponse['publishedAt'] != null ? DateTime.parse(apiResponse['publishedAt']) : DateTime.now(),
      source: apiResponse['source'] != null ? apiResponse['source']['name'] ?? 'Unknown Source' : 'Unknown Source',
      author: apiResponse['author'] ?? 'Unknown Author',
      description: apiResponse['description'] ?? 'No description available',
      url: apiResponse['url'] ?? '',
    );
  }

  // Conversion from Entity to Model
  factory NewsModel.fromEntity(NewsArticle news) {
    return NewsModel(
      title: news.title,
      images: news.images.isNotEmpty ? news.images : [],
      contents: news.content,
      date: news.date,
      source: news.source.isNotEmpty ? news.source : 'Unknown Source',
      author: news.author ?? 'Unknown Author',
      description: news.description ?? 'No description available',
      url: news.url ?? '',
    );
  }

  // Conversion from Model to Entity
  NewsArticle toEntity() {
    return NewsArticle(
      title: title,
      images: images,
      content: contents,
      date: date,
      source: source,
      author: author,
      description: description,
      url: url,
    );
  }
}
