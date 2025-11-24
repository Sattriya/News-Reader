import 'package:flutter/material.dart';
import 'package:news_reader/data/models/news_model.dart';
import '../../domain/repositories/news_repository.dart';
import '../../core/exceptions/news_exceptions.dart';

class NewsProvider with ChangeNotifier {
  final NewsRepository newsRepository;

  NewsProvider({required this.newsRepository});

  // State variables
  List<NewsModel> _news = [];
  List<NewsModel> _bookmarks = [];
  String _selectedCategory = 'all';
  String _searchQuery = '';
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isSearching = false;

  // Getters
  List<NewsModel> get news => _news;
  List<NewsModel> get bookmarks => _bookmarks;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get isSearching => _isSearching;

  // Load top headlines
  Future<void> loadTopHeadlines() async {
    _isLoading = true;
    _errorMessage = '';
    _isSearching = false;
    notifyListeners();

    try {
      _news = await newsRepository.getTopHeadlines();
    } on NewsException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load news by category
  Future<void> loadNewsByCategory(String category) async {
    _isLoading = true;
    _errorMessage = '';
    _selectedCategory = category;
    _isSearching = false;
    notifyListeners();

    try {
      _news = await newsRepository.getNewsByCategory(category);
    } on NewsException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search news
  Future<void> searchNews(String query) async {
    _isLoading = true;
    _errorMessage = '';
    _searchQuery = query;
    _isSearching = query.isNotEmpty;
    notifyListeners();

    try {
      _news = await newsRepository.searchNews(query);
    } on NewsException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Bookmark management
  Future<void> loadBookmarks() async {
    _bookmarks = await newsRepository.getBookmarkedNews();
    notifyListeners();
  }

  Future<void> toggleBookmark(NewsModel news) async {
    if (newsRepository.isBookmarked(news)) {
      await newsRepository.removeBookmark(news);
    } else {
      await newsRepository.bookmarkNews(news);
    }
    await loadBookmarks();
    notifyListeners();
  }

  bool isBookmarked(NewsModel news) {
    return newsRepository.isBookmarked(news);
  }

  // Clear error
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Reset search
  void resetSearch() {
    _searchQuery = '';
    _isSearching = false;
    loadTopHeadlines();
  }
}