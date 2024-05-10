// ignore_for_file: prefer_const_constructors

import 'package:chat_app_with_backend/Bloc/Get_user_message/get_message_cubit.dart';
import 'package:chat_app_with_backend/Bloc/Get_user_message/get_message_state.dart';
import 'package:chat_app_with_backend/Models/message_model.dart';
import 'package:chat_app_with_backend/Models/text_messages.dart';
import 'package:chat_app_with_backend/Socket%20connection/socket.dart';
import 'package:chat_app_with_backend/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.recipientId,
    required this.name,
    this.isActive,
    required this.setMessage,
  });
  final bool? isActive;
  final String recipientId;
  final String name;
  final VoidCallback setMessage;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  List<TextMessages> messages = [];
  bool hasType = false;
  String userId = "";

  @override
  void initState() {
    getId();
    fetchMessage();
    getMessageFromSocket();

    super.initState();
  }

  getMessageFromSocket() {
    Socket.socket.on('getMessageEvent', (res) {
      Map<String, dynamic> data = res;
      if (data.isNotEmpty && data['senderId'] == widget.recipientId) {
        if (mounted) {
          widget.setMessage();
          messages.add(TextMessages.fromJson(data));
          setState(() {});
          scrollToLastItem();
        }
      }
    });
  }

  void getId() async {
    userId = await Utils.getUserId();
  }

  void sendMessage(String text) {
    widget.setMessage();
    if (text.isNotEmpty) {
      Map data = {
        "message": text,
        "senderId": userId,
        "recipientId": widget.recipientId
      };

      TextMessages txt = TextMessages(text: text, senderId: userId);

      if (mounted) {
        messages.add(txt);
        setState(() {});
        scrollToLastItem();
      }

      Socket.socket.emit('sendMessageEvent', data);
      Socket.socket.emit('sendLastMessageEvent' ,"updateUserDetail");
    }
  }

  void scrollToLastItem() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });
  }

  void fetchMessage() async {
    List<MessageModel>? msgs = await BlocProvider.of<GetMessageCubit>(context)
        .getMessages(recipientId: widget.recipientId);

    if (msgs != null) {
      for (MessageModel msg in msgs) {
        Map<String, dynamic> mswg = {
          "text": msg.text,
          "senderId": msg.senderId
        };
        TextMessages message = TextMessages.fromJson(mswg);
        if (message.text.isNotEmptyAndNotNull) {
          messages.add(message);
          scrollToLastItem();
        }
      }
    }
  }

  @override
  void dispose() {
    _messageController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              widget.name,
              style: TextStyle(color: Colors.white),
            ),
            (widget.isActive!)
                ? Text(
                    "Online",
                    style: TextStyle(color: Colors.green, fontSize: 14),
                  )
                : Text(
                    "Offline",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
          ],
        ),
        actions: [
          PopupMenuButton<int>(
            iconColor: Colors.white,
            onSelected: (th) {
              if (th == 0) {}
            },
            color: Colors.white,
            itemBuilder: (context) => const [
              PopupMenuItem<int>(
                value: 0,
                enabled: true,
                child: Text('Logout'),
              ),
              PopupMenuItem<int>(value: 1, child: Text('Settings')),
            ],
          ),
        ],
      ),
      body: BlocBuilder<GetMessageCubit, GetMessageState>(
        builder: (context, state) {
          if (state is MessagesLoadedState) {
            return Hero(
              tag: "567890",
              child: Stack(
                children: [
                  (messages.isNotEmpty)
                      ? ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.only(bottom: 90),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            String message = messages[index].text;
                            bool isSender = userId == messages[index].senderId;

                            return MessageBubble(
                                isSender: isSender, message: message);
                          },
                        )
                      : Center(
                          child: Text(
                            "Start Conversation",
                            style: TextStyle(color: Vx.white, fontSize: 18),
                          ),
                        ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.only(top: 8),
                      color: Vx.black,
                      height: 60,
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(28))),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        margin: EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.camera_alt_outlined,
                                    color: Colors.white)),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextField(
                                  controller: _messageController,
                                  decoration: InputDecoration(
                                    hintText: 'Type something...',
                                    hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.7)),
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (_messageController.text
                                    .trim()
                                    .isNotEmptyAndNotNull) {
                                  BlocProvider.of<GetMessageCubit>(context)
                                      .sendMessage(
                                          text: _messageController.text,
                                          recipientId: widget.recipientId);
                                  sendMessage(
                                    _messageController.text.trim(),
                                  );
                                  _messageController.clear();
                                }
                                FocusScope.of(context).unfocus();
                              },
                              icon: Icon(Icons.send, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is MessagesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(child: Text("error"));
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final bool isSender;
  final String message;

  const MessageBubble(
      {super.key, required this.isSender, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 300),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue : Colors.grey,
          borderRadius: isSender
              ? BorderRadius.circular(10).copyWith(topRight: Radius.circular(0))
              : BorderRadius.circular(10).copyWith(topLeft: Radius.circular(0)),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
