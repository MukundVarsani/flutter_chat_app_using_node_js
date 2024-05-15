// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:chat_app_with_backend/Bloc/Get_user_message/get_message_cubit.dart';
import 'package:chat_app_with_backend/Bloc/all_user_cubit/all_user_cubit.dart';
import 'package:chat_app_with_backend/Bloc/all_user_cubit/all_user_state.dart';
import 'package:chat_app_with_backend/Screens/ChatScreen/chat_screen.dart';
import 'package:chat_app_with_backend/Screens/HomeScreen/Common/user_chat_tile.dart';
import 'package:chat_app_with_backend/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String userId = '';

  @override
  void initState() {
    getId();

    super.initState();
  }

  getId() async {
    userId = await Utils.getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.94),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "All Users",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<AllUserCubit, AllUserState>(
        builder: (context, state) {
          if (state is AllUserErrorState) {
            return Center(
              child: Text(state.error),
            );
          }
          if (state is AllUserLoadingState) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is AllUserLoadedState) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
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
                                    setMessage: () => {},
                                    recipientId: recipientId,
                                    name: state.users[index].name!,
                                  )));
                    },
                    child: UserChatTile(
                      isRead: false,
                      lastTime: "Sep 3",
                      index: index.toString(),
                      isUserChat: false,
                      username: state.users[index].name,
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
