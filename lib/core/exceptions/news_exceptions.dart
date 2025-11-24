class NewsException implements Exception {
  final String message;
  final int? statusCode;

  NewsException(this.message, [this.statusCode]);

  @override
  String toString() => 'NewsException: $message${statusCode != null ? ' ($statusCode)' : ''}';
}

class NetworkException extends NewsException {
  NetworkException(String message) : super(message);
}

class ApiKeyException extends NewsException {
  ApiKeyException() : super('API key is invalid or missing');
}

class NoInternetException extends NewsException {
  NoInternetException() : super('No internet connection');
}