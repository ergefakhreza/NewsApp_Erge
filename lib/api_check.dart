import 'package:flutter/material.dart';

import 'models/news_response_model.dart';
import 'services/news_api_service.dart';

void main() {
  runApp(const ApiCheckApp());
}

class ApiCheckApp extends StatelessWidget {
  const ApiCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Tes GNews API')),
        body: FutureBuilder<NewsResponseModel>(
          future: NewsApiService().getTopHeadlines(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Gagal mengambil berita:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              );
            }

            final berita = snapshot.data;

            if (berita == null || berita.articles.isEmpty) {
              return const Center(child: Text('Tidak ada berita ditemukan.'));
            }

            return ListView.builder(
              itemCount: berita.articles.length,
              itemBuilder: (context, index) {
                final article = berita.articles[index];

                return ListTile(
                  leading: article.urlToImage.isNotEmpty
                      ? Image.network(
                          article.urlToImage,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image);
                          },
                        )
                      : const Icon(Icons.image_not_supported),

                  title: Text(article.title),
                  subtitle: Text(article.author),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
