part of 'logins_bloc.dart';

@immutable
sealed class LoginsState {}

class LoginsInitial extends LoginsState {}
class LoginsActionState extends LoginsState {}
class LoginLoadingState extends LoginsState{}

class LoginTogglePasswordState extends LoginsActionState {
  final bool isPasswordVisible;

  LoginTogglePasswordState(this.isPasswordVisible);
}

class LoginSuccessful extends LoginsActionState {
  final LoginResponse loginResponse;

  LoginSuccessful({required this.loginResponse});
  
}
class LoginWrongCredentialsState extends LoginsState {
  final String error;

  LoginWrongCredentialsState({required this.error});
}

class LoginErrorState extends LoginsState {
  final String error;

  LoginErrorState({required this.error});
}
class LoginInternetSate extends LoginsState{
  final  String error;
  LoginInternetSate({required this.error});
}

class LoginNavigateToResetPasswordState extends LoginsActionState {}

