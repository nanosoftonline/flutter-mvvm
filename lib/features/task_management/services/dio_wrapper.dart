import 'package:dio/dio.dart';
import 'package:mvvm/features/task_management/services/http_client.dart';

class DioWrapper implements HttpClient {
  final Dio _dio = Dio();

  @override
  Future<HttpResponse> get(String path, {Map<String, dynamic>? queryParameters}) async {
    var res = await _dio.get(path, queryParameters: queryParameters);
    return HttpResponse(data: res.data, statusCode: res.statusCode!, message: res.statusMessage!);
  }

  @override
  Future<HttpResponse> post(String path, {dynamic data}) async {
    var res = await _dio.post(path, data: data);
    return HttpResponse(data: res.data, statusCode: res.statusCode!, message: res.statusMessage!);
  }

  @override
  Future<HttpResponse> put(String path, {dynamic data}) async {
    var res = await _dio.put(path, data: data);
    return HttpResponse(data: res.data, statusCode: res.statusCode!, message: res.statusMessage!);
  }

  @override
  Future<HttpResponse> delete(String path) async {
    var res = await _dio.delete(path);
    return HttpResponse(data: res.data, statusCode: res.statusCode!, message: res.statusMessage!);
  }
}
