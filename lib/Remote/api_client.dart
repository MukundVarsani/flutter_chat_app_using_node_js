
import 'package:chat_app_with_backend/Remote/api_constant.dart';
import 'package:chat_app_with_backend/Remote/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:velocity_x/velocity_x.dart';

class ApiClient {
  late Dio _dio;
  Options options = Options();
  ApiClient() {
    final baseOptions = BaseOptions(baseUrl: ApiConstant.mainUrl);
    _dio = Dio(baseOptions);
  }

  // ========================GET REQUEST===============================

  Future<Response> getRequest({required String path, String? token}) async {
    options = Options(
      headers: {
        // "Authorization": "Bearer $token",
        Headers.acceptHeader: "application/json",
        Headers.contentTypeHeader: "application/json"
      },
    );

    if (token.isNotEmptyAndNotNull) {
      options.headers!.addAll({
        "Authorization": "Bearer $token",
      });
    }
    try {
      Response response = await _dio.get(path, options: options);

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers.toString());
        print(e.response!.requestOptions);
        return e.response!;
      } else {
        print(e.requestOptions);
        print(e.message);

        throw ApiException(message: e.message);
      }
    }
  }
  // ========================POST REQUEST===============================

  Future<Response> postRequest({
    required String path,
    required Map body,
    String? token,
  }) async {
    options = Options(
      headers: {
        // "Authorization": "Bearer $token",
        Headers.acceptHeader: "application/json",
        Headers.contentTypeHeader: "application/json"
      },
    );

    if (token.isNotEmptyAndNotNull) {
      options.headers!.addAll({
        "Authorization": "Bearer $token",
      });
    }

    try {
      Response response = await _dio.post(path, data: body, options: options);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers.toString());
        print(e.response!.requestOptions);
        return e.response!;
      } else {
        print(e.requestOptions);
        print(e.message);

        throw ApiException(message: e.message);
      }
    }
  }
}
