import 'package:chat_app_with_backend/Remote/api_client.dart';
import 'package:chat_app_with_backend/Remote/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:velocity_x/velocity_x.dart';

class ImageService extends ApiClient {
  Future<String> updateProfile(
      {required String img, required String userId}) async {
    Map<String, dynamic> body = {"image": img, "userID": userId};
    try {
      Response response = await postRequest(
        path: ApiEndPoints.updateImage,
        body: body,
      );

      dynamic data = response.data;
      return data['message'].toString();
    } catch (e) {
      Vx.log(e.toString());
      rethrow;
    }
  }
}
