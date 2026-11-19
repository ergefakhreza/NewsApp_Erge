import 'article_model.dart';

class NewsResponseModel {
  final int totalArticles;
  final List<ArticleModel> articles;

  NewsResponseModel({required this.totalArticles, required this.articles});

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) {
    return NewsResponseModel(
      totalArticles: json['totalArticles'] ?? 0,
      articles: (json['articles'] as List? ?? [])
          .map((article) => ArticleModel.fromJson(article))
          .toList(),
    );
  }
}
