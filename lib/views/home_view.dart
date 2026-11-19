import 'package:get/get.dart';

import '../routes/app_routes.dart';

import 'package:flutter/material.dart';

import '../models/news_response_model.dart';
import '../services/news_api_service.dart';
import '../widgets/article_card.dart';
import '../widgets/error_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<NewsResponseModel> _newsFuture;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Mengambil berita utama
  void _loadNews() {
    _newsFuture = NewsApiService().getTopHeadlines();
  }

  // Mencari berita berdasarkan kata kunci
  void _searchNews(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _loadNews();
      } else {
        _newsFuture = NewsApiService().searchNews(query.trim());
      }
    });
  }

  // Memuat ulang berita
  void _retry() {
    setState(() {
      if (_searchController.text.trim().isEmpty) {
        _loadNews();
      } else {
        _newsFuture = NewsApiService().searchNews(
          _searchController.text.trim(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Kolom pencarian
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari berita...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchNews('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: _searchNews,
            ),
          ),

          // Menampilkan data berita
          Expanded(
            child: FutureBuilder<NewsResponseModel>(
              future: _newsFuture,
              builder: (context, snapshot) {
                // Kondisi loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Kondisi error
                if (snapshot.hasError) {
                  return ErrorView(
                    message: snapshot.error.toString(),
                    onRetry: _retry,
                  );
                }

                // Kondisi data berhasil diterima
                final news = snapshot.data;

                if (news == null || news.articles.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada berita ditemukan.'),
                  );
                }

                // Daftar berita
                return RefreshIndicator(
                  onRefresh: () async {
                    _retry();
                    await _newsFuture;
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: news.articles.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.detail,
                            arguments: news.articles[index],
                          );
                        },
                        child: ArticleCard(article: news.articles[index]),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
