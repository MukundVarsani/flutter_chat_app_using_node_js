import 'package:chat_app_with_backend/Bloc/Get_user_message/get_message_state.dart';
import 'package:chat_app_with_backend/Models/message_model.dart';
import 'package:chat_app_with_backend/Services/message_service.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class GetMessageCubit extends Cubit<GetMessageState> {
  GetMessageCubit() : super(MessagesInitialState());

  static final MessageService _messageService = MessageService();

  Future<List<MessageModel>?> getMessages({required String recipientId}) async {
    try {
      emit(MessagesLoadingState());
      List<MessageModel>? messages =
          await _messageService.fetchMessages(recipientId: recipientId);

      if (messages != null) {
        emit(MessagesLoadedState(messages));
      } else {
        emit(MessagesErrorState("Messages Not found"));
      }
      return messages;
    } catch (e) {
      emit(MessagesErrorState(e.toString()));
      return null;
    }
  }
  

  void sendMessage({required String text, required String recipientId}) async {
    try {
      await _messageService.createMessage(text: text, recipientId: recipientId);
      getMessages(recipientId: recipientId);
    } catch (e) {
      emit(MessagesErrorState(e.toString()));
    }
  }
}
