import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitial()) {
   on<SplashScreenInitialEvent>(splashScreenInitialEvent);
  
}
  FutureOr<void> splashScreenInitialEvent(SplashScreenInitialEvent event, Emitter<SplashScreenState> emit) async{
    emit(SplashScreenLoading());
    try{
      await Future.delayed(const Duration(seconds: 3), () {
      emit(SplashScreenLoaded());
    });
    }catch(e){ 
      emit(SplashScreenError(e.toString()));
    }
  }
}
