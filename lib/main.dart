// ignore_for_file: must_be_immutable
import 'package:chat_app_with_backend/Bloc/Get_user_message/get_message_cubit.dart';
import 'package:chat_app_with_backend/Bloc/Login_Cubit/login_cubit.dart';
import 'package:chat_app_with_backend/Bloc/Register_Cubit/register_cubit.dart';
import 'package:chat_app_with_backend/Bloc/all_user_cubit/all_user_cubit.dart';
import 'package:chat_app_with_backend/Bloc/user_chat_cubit/user_chat_cubit.dart';
import 'package:chat_app_with_backend/Screens/AuthScreen/login_screen.dart';
import 'package:chat_app_with_backend/Screens/bottom_navbar.dart';
import 'package:chat_app_with_backend/Socket%20connection/socket.dart';
import 'package:chat_app_with_backend/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyAPYQak1VKUd9rXmoEfQGC7blWpWzy1Pw8",
    appId: "1:744763380035:android:3a64a43eb9285c645b9ff6",
    messagingSenderId: "744763380035",
    projectId: "flutter-chat-app-using-node-js",
  ));

  String? token = await Utils.getToken();

  Socket.socket.on('error', (error) {
    Vx.log("Error occurred in socket connection: $error");
  });
  Socket.socket.on('disconnect', (rsn) {
    Vx.log("Dis connected : $rsn");
  });
  Socket.socket.on('heartbeat', (data) {
    Socket.socket.emit('heartbeatResponse', "pong");
  });

  runApp(MyApp(
    token: token,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.token});

  final String? token;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => UserChatCubit(),
        ),
        BlocProvider(
          create: (context) => AllUserCubit(),
        ),
        BlocProvider(
          create: (context) => GetMessageCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: (widget.token.isNotEmptyAndNotNull)
            ? const BottomNavbar()
            : const LoginScreen(),
      ),
    );
  }
}
