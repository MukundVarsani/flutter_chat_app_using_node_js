import 'package:chat_app_with_backend/Bloc/Register_Cubit/register_cubit.dart';
import 'package:chat_app_with_backend/Common_widgets/input_form_field.dart';
import 'package:chat_app_with_backend/Common_widgets/primary_button.dart';
import 'package:chat_app_with_backend/Screens/AuthScreen/login_screen.dart';
import 'package:chat_app_with_backend/Screens/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisible = false;

  void clearController() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xff030304),
          appBar: AppBar(
            backgroundColor: const Color(0xff030304),
            leading: const BackButton(
              style: ButtonStyle(iconSize: MaterialStatePropertyAll(30)),
              color: Colors.white,
            ),
          ),
          body: SingleChildScrollView(
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
                    "Influence your\nfamily smartly",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7), fontSize: 20),
                  ),
                  const HeightBox(50),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InputFormField(
                            hintText: "Name",
                            controller: _nameController,
                            validator: (name) {
                              if (name == null || name.isEmpty) {
                                return "Name field required";
                              }
                              return null;
                            },
                          ),
                          const HeightBox(10),
                          InputFormField(
                            controller: _emailController,
                            hintText: "Email",
                            validator: (email) {
                              if (email == null || email.isEmpty) {
                                return "Email field required";
                              }
                              if (!email.validateEmail()) {
                                return "Enter valid email";
                              }
                              return null;
                            },
                          ),
                          const HeightBox(10),
                          const HeightBox(10),
                          InputFormField(
                              hintText: "Password",
                              icon: true,
                              controller: _passwordController,
                              validator: (password) {
                                if (password == null || password.isEmpty) {
                                  return "password field required";
                                }
                                if (password.length < 8) {
                                  return "Password must contain 8 character";
                                }
                                return null;
                              }),
                          const HeightBox(50),
                          BlocConsumer<RegisterCubit, RegisterState>(
                            listener: (context, state) {
                              if (state is RegisterSuccesfullState) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            BottomNavbar()),
                                    (route) => false);
                              }
                            },
                            builder: (context, state) {
                              bool isLoading = state is RegisterLoadingState;
                        
                              if (state is RegisterErrorState) {
                                return Center(
                                  child: Text(state.error),
                                );
                              }
                              return PrimaryButton(
                                  title: "Sign up",
                                  isLoading: isLoading,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<RegisterCubit>(context)
                                          .registerStatus(
                                        context: context,
                                        name: _nameController.text,
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                      );
                                    }
                                  },
                                  titleColor: Colors.white,
                                  color: const Color(0xff080bff));
                            },
                          ),
                          const HeightBox(20),
                          PrimaryButton(
                              title: "Sign up with google",
                              onPressed: () {},
                              color: Colors.white)
                        ],
                      )),
                  const HeightBox(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style:
                            TextStyle(color: Color(0xffa09f9f), fontSize: 13),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()));
                        },
                        child: const Text(
                          "Login",
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
