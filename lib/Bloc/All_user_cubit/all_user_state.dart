import 'package:chat_app_with_backend/Models/user_model.dart';

 class AllUserState {}

class AllUserInitialState extends AllUserState {}

class AllUserLoadingState extends AllUserState {}

class AllUserLoadedState extends AllUserState {
  final List<UserModel> users;
  AllUserLoadedState(this.users);
}

class AllUserErrorState extends AllUserState {
  AllUserErrorState(this.error);
  final String error;
}
