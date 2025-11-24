import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_reader/presentation/providers/news_provider.dart';
import 'package:news_reader/presentation/widgets/news_item.dart';
import 'package:news_reader/presentation/screens/news_detail_screen.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          final bookmarks = newsProvider.bookmarks;
          
          if (bookmarks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No bookmarks yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the bookmark icon to save articles',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final news = bookmarks[index];
              
              return NewsItem(
                news: news,
                isBookmarked: true,
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
          );
        },
      ),
    );
  }
}