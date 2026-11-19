import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/article_model.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ArticleModel article = Get.arguments as ArticleModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Berita',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar berita
              if (article.urlToImage.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    article.urlToImage,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 220,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported, size: 50),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),

              // Judul berita
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Sumber berita
              Row(
                children: [
                  const Icon(Icons.newspaper, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      article.author.isEmpty
                          ? 'Sumber tidak diketahui'
                          : article.author,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Tanggal publikasi
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    article.publishedAt,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),

              const Divider(height: 32),

              // Deskripsi berita
              const Text(
                'Deskripsi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                article.description.isEmpty
                    ? 'Tidak ada deskripsi berita.'
                    : article.description,
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              // Isi berita
              const Text(
                'Isi Berita',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                article.content.isEmpty
                    ? 'Isi berita tidak tersedia.'
                    : article.content,
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
