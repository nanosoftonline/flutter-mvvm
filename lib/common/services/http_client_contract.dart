class HttpResponse {
  final dynamic data;
  final int statusCode;
  final String message;

  HttpResponse({
    required this.data,
    required this.statusCode,
    required this.message,
  });
}

abstract class IHttpClient {
  Future<HttpResponse> get(String path, {Map<String, dynamic>? queryParameters});
  Future<HttpResponse> post(String path, dynamic data);
  Future<HttpResponse> put(String path, dynamic data);
  Future<HttpResponse> delete(String path);
}
