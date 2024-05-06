import 'package:chat_app_with_backend/Models/user_model.dart';
import 'package:chat_app_with_backend/Remote/api_client.dart';
import 'package:chat_app_with_backend/Remote/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:velocity_x/velocity_x.dart';

class UserService extends ApiClient {
  Future<List<UserModel>> showAllUser() async {
    try {
      Response response = await getRequest(path: ApiEndPoints.allUser);

      List<dynamic> data = response.data;

      List<UserModel> users = data.map((e) => UserModel.fromJson(e)).toList();
      return users;
    } catch (e) {
      Vx.log(e.toString());
      rethrow;
    }
  }

  Future<List<UserModel>?> getUserChats(String id) async {
    try {
      Response response =
          await getRequest(path: "${ApiEndPoints.getUserChat}$id");

      List<String> allmembers = [];
      List<String> recipientUserId = [];

      if (response.statusCode == 200) {
        List<dynamic> dataList = response.data;

        for (var data in dataList) {
          List<String> members = List<String>.from(data['members']);
          allmembers.addAll(members);
        }
        recipientUserId =
            allmembers.where((memberId) => memberId != id).toList();

        List<UserModel>? recipientUsers =
            await getRecipientUser(recipientUserId);

        return recipientUsers;
      }
      return null;
    } catch (e) {
      Vx.log("getUserChats");
      Vx.log(e.toString());
      rethrow;
    }
  }

  Future<List<UserModel>?> getRecipientUser(
      List<String> recipientUserId) async {
    List<UserModel> recipientUsers = [];
    try {
      for (var recipientId in recipientUserId) {
        Response response =
            await getRequest(path: "${ApiEndPoints.findUser}/$recipientId");

        if (response.statusCode == 200) {
          Map<String, dynamic> userData = response.data;
          UserModel user = UserModel.fromJson(userData);
          recipientUsers.add(user);
        } else {
          Vx.log("Failed to fetch Recipient User");
        }
      }
      return recipientUsers.isNotEmpty ? recipientUsers : [];
    } catch (e) {
      Vx.log("getRecipientUser");
      Vx.log(e.toString());
      return null;
    }
  }

  Future<UserModel?> getUser(String id) async {
    UserModel? user;
    try {
      Response response =
          await getRequest(path: "${ApiEndPoints.findUser}/$id");

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = response.data;
         user = UserModel.fromJson(userData);
      } else {
        Vx.log("Failed to fetch Recipient User");
      }

      return user ?? UserModel();
    } catch (e) {
      Vx.log("getRecipientUser");
      Vx.log(e.toString());
      return null;
    }
  }
}
