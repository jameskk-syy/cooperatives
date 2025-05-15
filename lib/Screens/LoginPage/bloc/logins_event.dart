part of 'logins_bloc.dart';

@immutable
sealed class LoginsEvent {}

final class LoginButtonClickEvent extends LoginsEvent {
  final String username;
  final String password;

  LoginButtonClickEvent({required this.username, required this.password});
}

final class LoginNavigateToResetPasswordEvent extends LoginsEvent {}

final class LoginTogglePasswordEvent extends LoginsEvent {}
class ResetLoginEvent extends LoginsEvent {}
