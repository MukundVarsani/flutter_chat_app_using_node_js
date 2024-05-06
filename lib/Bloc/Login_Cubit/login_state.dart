part of 'login_cubit.dart';

sealed class LoginState {}

final class LoginInitialState extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginFailedState extends LoginState {}

final class LoginSuccessState extends LoginState {
  LoginSuccessState(this.name);
  final String name;
}

final class LoginErrorState extends LoginState {
  LoginErrorState(this.error);
  final String error;
}
