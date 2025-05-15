part of 'splash_screen_bloc.dart';

@immutable
sealed class SplashScreenState {}
sealed class SplashScreenActionState extends SplashScreenState {}

final class SplashScreenInitial extends SplashScreenState {}

final  class SplashScreenLoading extends SplashScreenState {}

final class SplashScreenLoaded extends SplashScreenActionState {}

final  class SplashScreenError extends SplashScreenActionState {
  final String error;
  SplashScreenError(this.error);
}
