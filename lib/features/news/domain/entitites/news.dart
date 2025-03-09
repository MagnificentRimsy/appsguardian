class NewsArticle {
  final String title;
  final List<String> images;
  final String content;
  final DateTime date;
  final String source;
  final String? description;
  final String? author;
  final String? url;

  NewsArticle({
    required this.title,
    required this.images,
    required this.content,
    required this.date,
    required this.source,
    this.description,
    this.author,
    this.url,
  });

  // Factory constructor to create a NewsArticle object from JSON (Map<String, dynamic>)
  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] as String? ?? 'Untitled',
      images: (json['images'] as List?)?.map((e) => e as String).toList() ?? [],
      content: json['content'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      source: json['source'] as String? ?? 'Unknown',
      description: json['description'] as String?,
      author: json['author'] as String?,
      url: json['url'] as String?,
    );
  }

  // Method to convert the object to JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'images': images,
      'content': content,
      'date': date.toIso8601String(),
      'source': source,
      'description': description,
      'author': author,
      'url': url,
    };
  }
}
