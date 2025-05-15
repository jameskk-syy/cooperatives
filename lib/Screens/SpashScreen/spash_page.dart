import 'package:cooperativeapp/Screens/LoginPage/login_page.dart';
import 'package:cooperativeapp/Screens/SpashScreen/bloc/splash_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashScreenBloc splashScreenBloc = SplashScreenBloc();

  @override
  void initState() {
    splashScreenBloc.add(SplashScreenInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashScreenBloc, SplashScreenState>(
        bloc: splashScreenBloc,
        buildWhen: (previous, current) => current is! SplashScreenActionState,
        listenWhen: (previous, current) => current is SplashScreenActionState,
        listener: (context, state) {
          if (state is SplashScreenLoaded) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          } else if (state is SplashScreenError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SplashScreenLoading) {
            return Center(
              child: SpinKitFadingCube(color: Color(0xFF2EBF70), size: 80.0),
            );
          } else if (state is SplashScreenLoaded) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
          return Container();
        },
      ),
    );
  }
}
