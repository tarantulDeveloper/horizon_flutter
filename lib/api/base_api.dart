import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BaseApi extends ChangeNotifier {
  Dio dio = Dio(BaseOptions(baseUrl: 'http://3.34.2.208:5000/api'));
  String? accessToken;
  bool isAuth = false;

  final _storage = const FlutterSecureStorage();

  BaseApi() {
    Future<void> refreshToken() async {
      final refreshToken = await _storage.read(key: 'refreshToken');
      final response = await dio
          .post('/refresh-token', data: {'refreshToken': refreshToken});
      if (response.statusCode == 200) {
        accessToken = response.data.refreshToken;
        isAuth = true;
      } else {
        accessToken = null;
        _storage.deleteAll();
        isAuth = false;
      }
      notifyListeners();
    }

    Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
      final options = Options(
          method: requestOptions.method, headers: requestOptions.headers);

      return dio.request<dynamic>(requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: options);
    }

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.headers['Authorization'] = 'Bearer $accessToken';
      return handler.next(options);
    }, onError: (DioError error, handler) async {
      if (error.response?.statusCode == 401
          /*&&
              error.response?.data['message'] == 'Refresh Token Expired!'*/
          ) {
        if (await _storage.containsKey(key: 'refreshToken')) {
          await refreshToken();
          return handler.resolve(await _retry(error.requestOptions));
        }
      }
      return handler.next(error);
    }));

    Future<Response<dynamic>> sendRequest(String path,
        {dynamic data,
        Map<String, dynamic>? queryParameters,
        bool isMultipart = false}) async {
      RequestOptions requestOptions = RequestOptions(
          path: path, data: data, queryParameters: queryParameters);
      if (isMultipart) {
        requestOptions.headers['content-type'] = 'multipart/form-data';
      } else {
        requestOptions.headers['content-type'] = 'application/json';
      }

      try {
        final response = await dio.request(requestOptions.path,
            data: requestOptions.data,
            options: Options(
                method: requestOptions.method,
                headers: requestOptions.headers));
        return response;
      } on DioError catch (error) {
        print(error.response?.data);
        if (error.response?.statusCode == 401) {
          if (await _storage.containsKey(key: 'refreshToken')) {
            await refreshToken();
            return await _retry(error.requestOptions);
          }
        }
        throw Error();
      }
    }
  }

  String getBaseUrl() {
    return dio.options.baseUrl;
  }
}
