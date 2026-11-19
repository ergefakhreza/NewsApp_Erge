class ArticleModel {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String author;
  final String content;

  ArticleModel({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.author,
    required this.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['image'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      author: json['source']?['name'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
