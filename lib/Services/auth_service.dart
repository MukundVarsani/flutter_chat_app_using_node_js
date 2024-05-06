// ignore_for_file: use_build_context_synchronously

import 'package:chat_app_with_backend/Models/user_model.dart';
import 'package:chat_app_with_backend/Remote/api_client.dart';
import 'package:chat_app_with_backend/Remote/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthService extends ApiClient {
  Future registerUser(
      {required String name,
      required String email,
      required String password,
      required BuildContext context}) async {
    Map<String, dynamic> body = {
      'name': name,
      'email': email,
      'password': password,
    };

    try {
      Response response =
          await postRequest(path: ApiEndPoints.register, body: body);

      if (response.statusCode == 200) {
        Map<String, dynamic>? res = response.data;
        if (res != null) {
          return res;
        }
      }

      VxToast.show(context, msg: response.data['message']);

      return "error";
    } catch (e) {
      Vx.log(e);
      rethrow;
    }
  }

  Future<UserModel?> loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };
    try {
      Response response =
          await postRequest(path: ApiEndPoints.login, body: body);

      dynamic data = response.data;
      if (response.statusCode == 200) {
        return UserModel.fromJson(data);
      }

      VxToast.show(context, msg: data['message']);
      return null;
    } catch (e) {
      Vx.log(e);
      rethrow;
    }
  }
}
