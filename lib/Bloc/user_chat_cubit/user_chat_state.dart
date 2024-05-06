import 'package:chat_app_with_backend/Models/user_model.dart';

abstract class UserChatState {}

class UserChatInitialState extends UserChatState {}

class UserChatLoadingState extends UserChatState {}

class UserChatLoadedState extends UserChatState {
  final List<UserModel> users;
  UserChatLoadedState(this.users);
  
}

class UserChatErrorState extends UserChatState {
  UserChatErrorState(this.error);
  final String error;
}
