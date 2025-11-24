import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_reader/presentation/providers/news_provider.dart';
import 'package:news_reader/presentation/screens/bookmark_screen.dart';
import 'package:news_reader/presentation/widgets/news_item.dart';
import 'package:news_reader/presentation/screens/news_detail_screen.dart';
import 'package:news_reader/core/constants/api_constants.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({Key? key}) : super(key: key);

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().loadTopHeadlines();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookmarkScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<NewsProvider>().resetSearch();
                  },
                ),
              ),
              onChanged: (value) {
                if (value.length >= 3) {
                  context.read<NewsProvider>().searchNews(value);
                } else if (value.isEmpty) {
                  context.read<NewsProvider>().resetSearch();
                }
              },
            ),
          ),

          // Category Chips
          _buildCategoryChips(),

          // News List
          Expanded(
            child: _buildNewsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = AppConstants.categories;
    
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = newsProvider.selectedCategory == category;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(
                    category[0].toUpperCase() + category.substring(1),
                    style: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      newsProvider.loadNewsByCategory(category);
                    }
                  },
                  backgroundColor: Colors.grey[300],
                  selectedColor: Colors.blue,
                  checkmarkColor: Colors.white,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNewsList() {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        // Loading State
        if (newsProvider.isLoading && newsProvider.news.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error State
        if (newsProvider.hasError && newsProvider.news.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  newsProvider.errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: newsProvider.loadTopHeadlines,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        // Empty State
        if (newsProvider.news.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No news found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Success State
        return RefreshIndicator(
          onRefresh: () => newsProvider.loadTopHeadlines(),
          child: ListView.builder(
            itemCount: newsProvider.news.length,
            itemBuilder: (context, index) {
              final news = newsProvider.news[index];
              final isBookmarked = newsProvider.isBookmarked(news);
              
              return NewsItem(
                news: news,
                isBookmarked: isBookmarked,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailScreen(news: news),
                    ),
                  );
                },
                onBookmark: () {
                  newsProvider.toggleBookmark(news);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}