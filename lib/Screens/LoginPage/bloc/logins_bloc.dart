import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cooperativeapp/repository/repo.dart';
import 'package:cooperativeapp/response/login_response.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'logins_event.dart';
part 'logins_state.dart';

class LoginsBloc extends Bloc<LoginsEvent, LoginsState> {
  bool isPasswordVisible = false; 
  LoginsBloc() : super(LoginsInitial()) {
    on<LoginButtonClickEvent>(loginButtonClickEvent);
    on<LoginNavigateToResetPasswordEvent>(loginNavigateToResetPasswordEvent);
    on<LoginTogglePasswordEvent>(loginTogglePasswordEvent);
    on<ResetLoginEvent>((event, emit) {
     emit(LoginsInitial());
});

  }

Future<void> loginButtonClickEvent(
    LoginButtonClickEvent event, Emitter<LoginsState> emit) async {
  emit(LoginLoadingState());
  try {
    final username = event.username;
    final password = event.password;

    final loginResponse = await LoginRepository.login(username, password);
    print(loginResponse.entity); // debug print

    // Extract roles from entity
    final roles = loginResponse.entity['roles'] as List;
    final isSuperUser = roles.any((role) => role['name'] == 'ROLE_SUPERUSER');

    if (isSuperUser) {
      // Extract and store data
      final token = loginResponse.entity['token'];
      final storedUsername = loginResponse.entity['username'];
      final entityId = loginResponse.entity['entityId'];

      print("entityId: $entityId");

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('username', storedUsername);
      await prefs.setString('entityId', entityId);

      emit(LoginSuccessful(loginResponse: loginResponse));
    } else {
      emit(LoginErrorState(error: "Access restricted, please contact admin"));
    }
  } catch (e) {
    emit(LoginErrorState(error: "An error occurred"));
  }
}
  FutureOr<void> loginNavigateToResetPasswordEvent(LoginNavigateToResetPasswordEvent event, Emitter<LoginsState> emit) {
  }

  FutureOr<void> loginTogglePasswordEvent(LoginTogglePasswordEvent event, Emitter<LoginsState> emit) {
    isPasswordVisible = !isPasswordVisible;
    emit(LoginTogglePasswordState(isPasswordVisible));
  }
}
