import 'package:chat_app_with_backend/Models/chat_model.dart';
import 'package:chat_app_with_backend/Models/user_model.dart';
import 'package:chat_app_with_backend/Remote/api_client.dart';
import 'package:chat_app_with_backend/Remote/api_endpoints.dart';
import 'package:chat_app_with_backend/Utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatServices extends ApiClient {
  Future<ChatModel?> getChatId({required String recipientId}) async {
    try {
      UserModel user = await Utils.getUser();
      String userId = user.id!;

      Response response = await getRequest(
          path: "${ApiEndPoints.findChat}$userId/$recipientId");

      dynamic data = response.data;

      if (response.statusCode == 200) {
        ChatModel chat = ChatModel.fromJson(data);

        if (chat.members != null) {
          // Vx.log("Got chat id: ${chat.sId}");
          return chat;
        }
      }
      return null;
    } catch (e) {
      Vx.log("getChatId : ${e.toString()}");
      return null;
    }
  }

  Future<ChatModel?> createChatId({required String recipientId}) async {
    try {
      UserModel user = await Utils.getUser();
      String userId = user.id!;

      Map<String, dynamic> body = {"firstId": userId, "secondId": recipientId};

      Response response =
          await postRequest(path: ApiEndPoints.createChat, body: body);

      dynamic data = response.data;
      if (response.statusCode == 200) {
        ChatModel chat = ChatModel.fromJson(data);
        // Vx.log("chat created ${chat.sId} ");
        return chat;
      }
      return null;
    } catch (e) {
      Vx.log("createId : ${e.toString()}");
      return null;
    }
  }
}
