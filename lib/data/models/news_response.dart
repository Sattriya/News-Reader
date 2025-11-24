import 'package:json_annotation/json_annotation.dart';
import 'news_model.dart';

part 'news_response.g.dart';

@JsonSerializable()
class NewsResponse {
  final String status;
  final int totalResults;
  final List<NewsModel> articles;

  NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) => 
      _$NewsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NewsResponseToJson(this);
}