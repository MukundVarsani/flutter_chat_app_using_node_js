// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:chat_app_with_backend/Models/user_model.dart';
import 'package:chat_app_with_backend/Services/auth_service.dart';
import 'package:chat_app_with_backend/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  static final AuthService _authService = AuthService();

  LoginCubit() : super(LoginInitialState());

  void loginStatus(
      {required String email,
      required String password,
      required BuildContext context}) async {
    emit(LoginLoadingState());

    try {
      UserModel? user = await _authService.loginUser(
          email: email, password: password, context: context);

      if (user != null) {




        Utils.saveToken(user.token!);
        Utils.saveUser(user);
        emit(LoginSuccessState(user.name!));
        VxToast.show(context, msg: "Welcome ${user.name}");
      } else {
        emit(LoginErrorState("Data not found"));
      }
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }
}
