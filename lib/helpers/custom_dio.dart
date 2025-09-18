import 'package:dio/dio.dart';
import 'package:social_feed/helpers/hive.dart';

class ApiClient {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "http://10.0.2.2:8050",
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final tokensBox = await HiveService.getBox<String>('tokens');
          final accessToken = tokensBox.get('accessToken');
          if (accessToken != null) {
            options.headers['Authorization'] = "Bearer $accessToken";
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          if (error.response != null) {
            print("API Error: ${error.response?.data['message']}");
          } else {
            print("Network Error: ${error.message}");
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
