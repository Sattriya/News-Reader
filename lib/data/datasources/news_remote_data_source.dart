import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_reader/core/constants/api_constants.dart';
import '../../core/exceptions/news_exceptions.dart';
import '../models/news_model.dart';

class NewsRemoteDataSource {
  final http.Client client;

  NewsRemoteDataSource({required this.client});

  // Method menggunakan Inshorts API (No API key required)
  Future<List<NewsModel>> getNewsByCategory(String category) async {
    try {
      late Uri uri;
      if (category == 'all') {
        uri = Uri.parse(
            '${ApiConstants.newsDataBaseUrl}/news'
                '?apikey=${ApiConstants.newsDataApiKey}'
                '&language=en'
        );
      } else {
        uri = Uri.parse(
            '${ApiConstants.newsDataBaseUrl}/news'
                '?apikey=${ApiConstants.newsDataApiKey}'
                '&category=$category'
                '&language=en'
        );
      }

      final response = await client.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['results'] ?? [];

        return articles.map((article) => NewsModel(
          author: article['creator']?.first ?? 'Unknown',
          title: article['title'] ?? 'No Title',
          description: article['description'] ?? 'No Description',
          url: article['link'] ?? '',
          urlToImage: article['image_url'],
          publishedAt: DateTime.tryParse(article['pubDate'] ?? '') ?? DateTime.now(),
          content: article['content'] ?? '',
          source: article['source_id'] ?? 'Unknown',
        )).toList();
      } else {
        throw NewsException('Failed to fetch news: ${response.statusCode}', response.statusCode);
      }
    } catch (e) {
      throw NewsException('Network error: $e');
    }
  }

  // Method untuk search news (menggunakan NewsData.io)
  Future<List<NewsModel>> searchNews(String query) async {
    try {
      final uri = Uri.parse('${ApiConstants.newsDataBaseUrl}/news?apikey=${ApiConstants.newsDataApiKey}&q=$query&language=en');

      final response = await client.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['results'] ?? [];

        return articles.map((article) => NewsModel(
          author: article['creator']?.first ?? 'Unknown',
          title: article['title'] ?? 'No Title',
          description: article['description'] ?? 'No Description',
          url: article['link'] ?? '',
          urlToImage: article['image_url'],
          publishedAt: DateTime.parse(article['pubDate']),
          content: article['content'] ?? '',
          source: article['source_id'] ?? 'Unknown',
        )).toList();
      } else {
        throw NewsException('Failed to search news: ${response.statusCode}', response.statusCode);
      }
    } catch (e) {
      throw NewsException('Search error: $e');
    }
  }

  /*DateTime _parseDate(String dateString) {
    try {
      // Format: "01 Jan 2024, Monday"
      final parts = dateString.split(' ');
      if (parts.length >= 3) {
        final day = int.parse(parts[0]);
        final month = _parseMonth(parts[1]);
        final year = int.parse(parts[2].replaceAll(',', ''));
        return DateTime(year, month, day);
      }
    } catch (e) {
      print('Date parsing error: $e');
    }
    return DateTime.now();
  }*/

  /*int _parseMonth(String month) {
    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
    };
    return months[month] ?? 1;
  }*/
}