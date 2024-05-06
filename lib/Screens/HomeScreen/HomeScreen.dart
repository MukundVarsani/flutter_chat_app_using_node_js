import 'package:chat_app_with_backend/Bloc/Get_user_message/get_message_cubit.dart';
import 'package:chat_app_with_backend/Bloc/user_chat_cubit/user_chat_cubit.dart';
import 'package:chat_app_with_backend/Bloc/user_chat_cubit/user_chat_state.dart';
import 'package:chat_app_with_backend/Models/message_model.dart';
import 'package:chat_app_with_backend/Models/user_model.dart';
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

  List<dynamic> onlineUsersList = [];
  bool isUserOnline = false;
  List<String> lastMessage = [];
  List<String> lastTime = [];


  @override
  void initState() {
    Socket.socket.connect();
    addNewUser();
    super.initState();
    setLastMessage();
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
    Navigator.pushAndRemoveUntil(
        widget.context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false);
  }

  @override
  void dispose() {
    _chatCubit.close();
    addNewUser();
    super.dispose();
  }

  Future<void> setLastMessage() async {
    List<UserModel>? recipientUsers =
        await BlocProvider.of<UserChatCubit>(context).userChats();

    if (recipientUsers != null) {
      lastMessage = [];
      lastTime = [];

      for (UserModel recipientUser in recipientUsers) {
        List<MessageModel>? messages =
            await _messageService.fetchMessages(recipientId: recipientUser.id!);

        if (messages != null && messages.isNotEmpty) {
          setLastTime(messages.last.createdAt.toString());
          lastMessage.add(messages.last.text!.toString());
        } else {
          lastMessage.add("Start");
          setLastTime(" - - ");
        }
      }
      setState(() {});
    }
  }

  void setLastTime(String time) {
    String timeis = '';
    String timeString = time;
    DateTime givenTime = DateTime.parse(timeString);
    DateTime currentTime = DateTime.now();

    Duration difference = currentTime.difference(givenTime);

    int hoursDifference = difference.inHours;
    int daysDifference = difference.inDays;
    int minuteDifference = difference.inMinutes;

    if (minuteDifference < 60) {
      timeis = ' $minuteDifference min ago';
    } else if (hoursDifference < 24) {
      timeis = '$hoursDifference hr ago';
    } else if (daysDifference < 2) {
      timeis = '$daysDifference day ago';
    } else {
      timeis = "${givenTime.day}/${givenTime.month}/${givenTime.year}";
    }

    lastTime.add(timeis);
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
           
            return LiquidPullToRefresh(
              onRefresh: () async {
                BlocProvider.of<UserChatCubit>(context).userChats();
                await setLastMessage();
              },
              height: 50,
              child: ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  isUserOnline = onlineUsersList
                      .any((user) => user['userId'] == state.users[index].id);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: InkWell(
                      onTap: () {
                        String recipientId = state.users[index].id!;
                        BlocProvider.of<GetMessageCubit>(context)
                            .getMessages(recipientId: recipientId);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                      isActive: isUserOnline,
                                      recipientId: recipientId,
                                      name: state.users[index].name!,
                                    )));
                      },
                      child: UserChatTile(
                        lastTime: lastTime.isNotEmpty ? lastTime[index] : "",
                        index: index.toString(),
                        username: state.users[index].name,
                        lastMessage: (lastMessage.isNotEmpty)
                            ? lastMessage[index]
                            : "...",
                        isUserChat: true,
                        img: state.users[index].image,
                        isOnline: isUserOnline,
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
        listener: (BuildContext context, UserChatState state) {},
      ),
    );
  }
}
