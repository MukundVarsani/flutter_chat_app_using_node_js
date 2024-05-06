import 'package:bloc/bloc.dart';
import 'package:chat_app_with_backend/Services/auth_service.dart';
import 'package:chat_app_with_backend/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  static final AuthService _authService = AuthService();
  RegisterCubit() : super(RegisterInitial());

  void registerStatus(
      {required String name,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      emit(RegisterLoadingState());
      dynamic response = await _authService.registerUser(
          name: name, email: email, password: password, context: context);

      if (response == 'error') {
        emit(RegisterFailedState());
        return;
      }
      Map res = response;
      String token = res['token'];
      Utils.saveToken(token);
      emit(RegisterSuccesfullState(res['name']));
    } catch (e) {
      emit(RegisterErrorState(e.toString()));
    }
  }
}
