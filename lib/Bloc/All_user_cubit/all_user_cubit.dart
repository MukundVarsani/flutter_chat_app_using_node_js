import 'package:chat_app_with_backend/Bloc/all_user_cubit/all_user_state.dart';
import 'package:chat_app_with_backend/Models/user_model.dart';
import 'package:chat_app_with_backend/Services/user_service.dart';
import 'package:chat_app_with_backend/Utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllUserCubit extends Cubit<AllUserState> {
  static final UserService _service = UserService();

  AllUserCubit() : super(AllUserInitialState()) {
    allUsers();
  }

  void allUsers() async {
    String userId = await Utils.getUserId();
    try {
      emit(AllUserLoadingState());
      List<UserModel> users = await _service.showAllUser();

      List<UserModel> otherUsers =
          users.where((element) => userId != element.id).toList();

          
      emit(AllUserLoadedState(otherUsers));
    } catch (e) {
      emit(AllUserErrorState(e.toString()));
    }
  }
}
