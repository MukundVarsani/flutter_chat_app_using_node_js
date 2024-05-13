import 'dart:async';

import 'package:chat_app_with_backend/Bloc/Get_user_message/get_message_cubit.dart';
import 'package:chat_app_with_backend/Bloc/user_chat_cubit/user_chat_cubit.dart';
import 'package:chat_app_with_backend/Bloc/user_chat_cubit/user_chat_state.dart';
import 'package:chat_app_with_backend/Models/message_model.dart';
import 'package:chat_app_with_backend/Models/user_model.dart';
import 'package:chat_app_with_backend/Models/user_tile_model.dart';
import 'package:chat_app_with_backend/Screens/AuthScreen/login_screen.dart';
import 'package:chat_app_with_backend/Screens/ChatScreen/chat_screen.dart';
import 'package:chat_app_with_backend/Screens/HomeScreen/Common/user_chat_tile.dart';
import 'package:chat_app_with_backend/Services/message_service.dart';
import 'package:chat_app_with_backend/Socket%20connection/socket.dart';
import 'package:chat_app_with_backend/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.context,
  });
  final BuildContext context;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserChatCubit _chatCubit = UserChatCubit();
  final MessageService _messageService = MessageService();
  late final String userId;

  List<dynamic> onlineUsersList = [];
  bool isUserOnline = false;
  List<String> lastMessage = [];
  List<String> lastTime = [];
  List<UserTileModel> usersTiles = [];

  @override
  void initState() {
    addNewUser();
    setLastMessage();
    lastMesasgeUpdate();
    getUserId();
    super.initState();
  }

  Future getUserId() async {
    userId = await Utils.getUserId();
  }

  addNewUser() async {
    UserModel user = await Utils.getUser();
    Socket.socket.emit("addNewUsers", user.id);
    Socket.socket.on("getOnlineUsers", (res) {
      onlineUsersList = res;
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _logoutUser() {
    Socket.socket.disconnect();
    Socket.socket.dispose();
    Navigator.pushAndRemoveUntil(
        widget.context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false);
  }

  void lastMesasgeUpdate() async {
    Socket.socket.on('handleUpdatedLastMessage', (data) async {
      // Vx.log(data['recipientId'] == userId);
      if (data['recipientId'] == userId) {
        await setLastMessage();
      }
    });
  }

  @override
  void dispose() {
    _chatCubit.close();
    super.dispose();
  }

  Future<void> setLastMessage() async {
    lastMessage.clear();
    lastTime.clear();
    List<UserModel>? recipientUsers =
        await BlocProvider.of<UserChatCubit>(context).userChats();

    if (recipientUsers != null) {
     
      for (UserModel recipientUser in recipientUsers) {
        List<MessageModel>? messages =
            await _messageService.fetchMessages(recipientId: recipientUser.id!);
        if (messages != null && messages.isNotEmpty) {
          lastTime.add(messages.last.createdAt.toString());
          lastMessage.add(messages.last.text!.toString());
        } else {
          lastMessage = [];
          lastTime = [];
        }
      }
    }
    setState(() {});
  }

  setUserList(List<UserModel> users) {
    usersTiles.clear();

    // if (lastMessage.length == users.length) {
    if (lastMessage.isNotEmpty) {
      for (int index = 0; index < users.length; index++) {
        UserTileModel userT = UserTileModel(
            recipientId: users[index].id,
            lastMessage: lastMessage[index],
            lastMsgTime: lastTime[index],
            name: users[index].name,
            img: users[index].image);

        usersTiles.add(userT);
      }
    }
    usersTiles.sort((a, b) {
      return b.lastMsgTime!.compareTo(a.lastMsgTime!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton<int>(
            iconColor: Colors.white,
            onSelected: (th) {
              if (th == 0) {
                _logoutUser();
              }
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
        title: const Text(
          "Chats",
          style: TextStyle(color: Vx.white),
        ),
      ),
      body: BlocConsumer<UserChatCubit, UserChatState>(
        builder: (context, state) {
          if (state is UserChatLoadingState) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (state is UserChatLoadedState) {
            setUserList(state.users);

            if (usersTiles.isNotEmpty) {
              return LiquidPullToRefresh(
                onRefresh: () async {
                  await setLastMessage();
                },
                height: 50,
                child: ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    isUserOnline = onlineUsersList.any((user) =>
                        user['userId'] == usersTiles[index].recipientId);

                    String timeis = '';
                    DateTime givenTime =
                        DateTime.parse(usersTiles[index].lastMsgTime!);
                    DateTime currentTime = DateTime.now();
                    Duration difference = currentTime.difference(givenTime);

                    int hoursDifference = difference.inHours;
                    int daysDifference = difference.inDays;
                    int minuteDifference = difference.inMinutes;
                    int secondDifference = difference.inSeconds;

                    if (secondDifference < 60) {
                      timeis = 'Now';
                    } else if (minuteDifference < 60) {
                      timeis = '$minuteDifference min ago';
                    } else if (hoursDifference < 24) {
                      timeis = '$hoursDifference hr ago';
                    } else if (daysDifference < 2) {
                      timeis = '$daysDifference day ago';
                    } else {
                      timeis =
                          "${givenTime.day}/${givenTime.month}/${givenTime.year}";
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: InkWell(
                          onTap: () {
                            String recipientId = usersTiles[index].recipientId!;
                            BlocProvider.of<GetMessageCubit>(context)
                                .getMessages(recipientId: recipientId);

                            isUserOnline = onlineUsersList
                                .any((user) => user['userId'] == recipientId);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChatScreen(
                                          setMessage: setLastMessage,
                                          isActive: isUserOnline,
                                          recipientId: recipientId,
                                          name: usersTiles[index].name!,
                                        )));
                          },
                          child: UserChatTile(
                            lastTime: timeis,
                            index: index.toString(),
                            username: usersTiles[index].name,
                            lastMessage: usersTiles[index].lastMessage,
                            isUserChat: true,
                            img: usersTiles[index].img,
                            isOnline: isUserOnline,
                          )),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          }

          return Container();
        },
        listener: (BuildContext context, UserChatState state) {},
      ),
    );
  }
}
