import 'package:chat_app_with_backend/Models/chat_model.dart';
import 'package:chat_app_with_backend/Models/message_model.dart';
import 'package:chat_app_with_backend/Models/user_model.dart';
import 'package:chat_app_with_backend/Remote/api_client.dart';
import 'package:chat_app_with_backend/Remote/api_endpoints.dart';
import 'package:chat_app_with_backend/Services/chat_service.dart';
import 'package:chat_app_with_backend/Utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageService extends ApiClient {
  late ChatServices _chatServices;
  late String chatId;
  String? senderId;
  MessageService() {
    _chatServices = ChatServices();
  }

  Future<void> assignChatId(String recipientId) async {
    ChatModel? chat =
        await _chatServices.createChatId(recipientId: recipientId);
    chatId = chat?.sId ?? "1";
  }

  Future<List<MessageModel>?> fetchMessages(
      {required String recipientId}) async {
    try {
      ChatModel? chat = await _chatServices.getChatId(recipientId: recipientId);

      String chatId = chat?.sId ?? 'none';

      // Vx.log(chatId);

      Response response =
          await getRequest(path: "${ApiEndPoints.getMessage}$chatId");

      if (response.statusCode == 200) {
        List<dynamic> messages = response.data;
        return messages
            .map((message) => MessageModel.fromJson(message))
            .toList();
      }
    } catch (e) {
      Vx.log("fetch message-------------> ${e.toString()}");
    }

    return null;
  }

  Future<String?> lastMessages(String chatId) async {
    try {
      Response response =
          await getRequest(path: "${ApiEndPoints.getMessage}$chatId");
      if (response.statusCode == 200) {
        List<dynamic> messages = response.data;
        return messages
            .map((message) => MessageModel.fromJson(message))
            .toList()
            .last
            .text;
      }
    } catch (e) {
      Vx.log("Last Message : $e");
    }
    return null;
  }

  Future<MessageModel?> createMessage(
      {required String text, required String recipientId}) async {
    await assignChatId(recipientId);
    UserModel user = await Utils.getUser();
    senderId = user.id!;

    // Vx.log("chatId----------------------> $chatId");
    try {
      Map<String, dynamic> body = {
        "senderId": senderId,
        "chatId": chatId,
        "text": text
      };
      Response response =
          await postRequest(path: ApiEndPoints.createMesssage, body: body);

      dynamic data = response.data;

      if (response.statusCode == 200) {
        MessageModel messgage = MessageModel.fromJson(data);
        return messgage;
      }
    } catch (e) {
      Vx.log("Send Message : ${e.toString()}");
    }

    return null;
  }
}
