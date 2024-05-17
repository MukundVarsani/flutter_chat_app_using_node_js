import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserChatTile extends StatelessWidget {
  const UserChatTile({
    super.key,
    this.isUserChat = false,
    this.username,
    this.lastMessage,
    this.isOnline = false,
    required this.index,
    required this.lastTime,
    this.img,
    required this.isRead,
  });
  final bool isUserChat;
  final String? username;
  final String? lastMessage;
  final bool isOnline;
  final String index;
  final String lastTime;
  final String? img;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isRead ? null : Colors.white.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: 20),
      height: 80,
      child: Row(
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: isOnline
                          ? const Color.fromARGB(255, 30, 183, 91)
                          : Colors.transparent,
                      blurRadius: 8,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: (img != null)
                      ? Image.memory(
                          base64Decode(img!),
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                                child: Container(
                              color: Colors.black,
                            ));
                          },
                          "https://img.freepik.com/free-photo/freedom-concept-with-hiker-mountain_23-2148107064.jpg",
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 0.3, color: Colors.white.withOpacity(0.3)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        username ?? "User name",
                        style: GoogleFonts.ubuntu(
                          textStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.purple,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(lastMessage ?? "Start Conversation",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.7))),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: isUserChat
                        ? [
                            Text(
                              lastTime,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.7)),
                            ),
                            const SizedBox(
                              height: 0,
                            )
                          ]
                        : [const SizedBox()],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
