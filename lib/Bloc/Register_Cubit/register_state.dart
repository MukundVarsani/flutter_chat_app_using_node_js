part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoadingState extends RegisterState {}
final class RegisterFailedState extends RegisterState {}

final class RegisterSuccesfullState extends RegisterState {
  RegisterSuccesfullState(this.name);
  final String name;
}

final class RegisterErrorState extends RegisterState {
  RegisterErrorState(this.error);
  final String error;
}
