import 'package:chat_app_with_backend/Models/message_model.dart';

abstract class GetMessageState {}

class MessagesInitialState extends GetMessageState {}

class MessagesLoadingState extends GetMessageState {}

class MessagesLoadedState extends GetMessageState {  

MessagesLoadedState(this.messages);
  final List<MessageModel> messages;

}

class MessagesErrorState extends GetMessageState {
  MessagesErrorState(this.error);
  final String error;
}
