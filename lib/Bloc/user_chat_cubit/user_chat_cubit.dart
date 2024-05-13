import 'package:chat_app_with_backend/Bloc/user_chat_cubit/user_chat_state.dart';
import 'package:chat_app_with_backend/Models/user_model.dart';
import 'package:chat_app_with_backend/Services/user_service.dart';
import 'package:chat_app_with_backend/Utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserChatCubit extends Cubit<UserChatState> {
  static final UserService _service = UserService();
  String userId = '';
  List<dynamic>? members;
  UserChatCubit() : super(UserChatLoadingState()) {
    userChats();
  }

  Future<List<UserModel>?> userChats() async {
    UserModel user = await Utils.getUser();
    userId = user.id!;
    try {
      List<UserModel>? recipientUsers = await _service.getUserChats(userId);
      if (recipientUsers != null) {
        emit(UserChatLoadedState(recipientUsers));
        return recipientUsers;
      }
    } catch (e) {
      // print(e);
      emit(UserChatErrorState(e.toString()));
    }
    return null;
  }
}
