import 'package:news_reader/data/models/news_model.dart';
import '../../core/exceptions/news_exceptions.dart';
import '../../data/datasources/news_remote_data_source.dart';

abstract class NewsRepository {
  Future<List<NewsModel>> getTopHeadlines();
  Future<List<NewsModel>> getNewsByCategory(String category);
  Future<List<NewsModel>> searchNews(String query);
  Future<List<NewsModel>> getBookmarkedNews();
  Future<void> bookmarkNews(NewsModel news);
  Future<void> removeBookmark(NewsModel news);
  bool isBookmarked(NewsModel news);
}

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final List<NewsModel> _bookmarks = [];

  NewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NewsModel>> getTopHeadlines() async {
    try {
      return await remoteDataSource.getNewsByCategory('all');
    } catch (e) {
      throw NewsException('Failed to get top headlines: $e');
    }
  }

  @override
  Future<List<NewsModel>> getNewsByCategory(String category) async {
    try {
      return await remoteDataSource.getNewsByCategory(category);
    } catch (e) {
      throw NewsException('Failed to get news by category: $e');
    }
  }

  @override
  Future<List<NewsModel>> searchNews(String query) async {
    try {
      if (query.isEmpty) return await getTopHeadlines();
      return await remoteDataSource.searchNews(query);
    } catch (e) {
      throw NewsException('Failed to search news: $e');
    }
  }

  @override
  Future<List<NewsModel>> getBookmarkedNews() async {
    // Dalam implementasi real, ini akan membaca dari shared_preferences
    return _bookmarks;
  }

  @override
  Future<void> bookmarkNews(NewsModel news) async {
    if (!_bookmarks.any((item) => item.url == news.url)) {
      _bookmarks.add(news);
    }
  }

  @override
  Future<void> removeBookmark(NewsModel news) async {
    _bookmarks.removeWhere((item) => item.url == news.url);
  }

  @override
  bool isBookmarked(NewsModel news) {
    return _bookmarks.any((item) => item.url == news.url);
  }
}