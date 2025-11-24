import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:news_reader/presentation/providers/news_provider.dart';
import 'package:news_reader/presentation/screens/news_list_screen.dart';

import 'core/constants/api_constants.dart';
import 'data/datasources/news_remote_data_source.dart';
import 'domain/repositories/news_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NewsRemoteDataSource>(
          create: (_) => NewsRemoteDataSource(client: http.Client()),
        ),
        Provider<NewsRepository>(
          create: (context) => NewsRepositoryImpl(
            remoteDataSource: context.read<NewsRemoteDataSource>(),
          ),
        ),
        ChangeNotifierProvider<NewsProvider>(
          create: (context) => NewsProvider(
            newsRepository: context.read<NewsRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        home: const NewsListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}