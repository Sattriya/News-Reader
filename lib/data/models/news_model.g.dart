// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsModel _$NewsModelFromJson(Map<String, dynamic> json) => NewsModel(
  author: json['author'] as String?,
  title: json['title'] as String,
  description: json['description'] as String,
  url: json['url'] as String,
  urlToImage: json['urlToImage'] as String?,
  publishedAt: DateTime.parse(json['publishedAt'] as String),
  content: json['content'] as String,
  source: json['source'] as String?,
);

Map<String, dynamic> _$NewsModelToJson(NewsModel instance) => <String, dynamic>{
  'author': instance.author,
  'title': instance.title,
  'description': instance.description,
  'url': instance.url,
  'urlToImage': instance.urlToImage,
  'publishedAt': instance.publishedAt.toIso8601String(),
  'content': instance.content,
  'source': instance.source,
};
