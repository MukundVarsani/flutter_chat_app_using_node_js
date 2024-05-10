import 'package:chat_app_with_backend/Bloc/Login_Cubit/login_cubit.dart';
import 'package:chat_app_with_backend/Common_widgets/input_form_field.dart';
import 'package:chat_app_with_backend/Common_widgets/primary_button.dart';
import 'package:chat_app_with_backend/Screens/AuthScreen/register_screen.dart';
import 'package:chat_app_with_backend/Screens/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  bool isVisible = false;
  bool isSending = false;

  void scroll() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void handleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xff030304),
         
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Join us for free",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Influence your\nfollowers smartly",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7), fontSize: 20),
                  ),
                  const HeightBox(260),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const HeightBox(10),
                          InputFormField(
                              hintText: "Email",
                              controller: _emailController,
                              validator: (email) {
                                if (email == null || email.isEmpty) {
                                  return "Email field required";
                                }
                                if (!email.validateEmail()) {
                                  return "Enter valid email";
                                }
                                return null;
                              }),
                          const HeightBox(10),
                          const HeightBox(10),
                          InputFormField(
                            icon: true,
                            hintText: "Password",
                            controller: _passwordController,
                            validator: (password) {
                              if (password == null || password.isEmpty) {
                                return "Email field required";
                              }
                              if (password.length < 8) {
                                return "Password must contain 8 character";
                              }
                              return null;
                            },
                          ),
                          const HeightBox(30),
                          BlocConsumer<LoginCubit, LoginState>(
                            listener: (context, state) {
                              if (state is LoginSuccessState) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BottomNavbar()),
                                    (route) => false);
                              }

                          
                            },
                            builder: (context, state) {
                              bool isLoading = state is LoginLoadingState;

                              return PrimaryButton(
                                  isLoading: isLoading,
                                  title: "Login",
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<LoginCubit>(context)
                                          .loginStatus(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                              context: context);
                                    }
                                  },
                                  titleColor: Colors.white,
                                  color: const Color(0xff080bff));
                            },
                          ),
                          const HeightBox(20),
                          PrimaryButton(
                              title: "Login with google",
                              onPressed: () {},
                              color: Colors.white)
                        ],
                      )),
                  const HeightBox(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: const Text(
                          "Forget Password ",
                          style:
                              TextStyle(color: Color(0xff080bff), fontSize: 13),
                        ),
                      ),
                      const Text(
                        "..Don't have an account? ",
                        style:
                            TextStyle(color: Color(0xffa09f9f), fontSize: 13),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()));
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(color: Color(0xff080bff)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
