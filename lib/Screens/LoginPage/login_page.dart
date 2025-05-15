import 'package:cooperativeapp/InternetConnectivity/check_internet.dart';
import 'package:cooperativeapp/Screens/Dashboard/dashboard.dart';
import 'package:cooperativeapp/Screens/LoginPage/bloc/logins_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginsBloc loginsBloc = LoginsBloc();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  void _loginUser() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    bool isConnected = await CheckInternetCon.checkConnection();

    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No internet connection"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    loginsBloc.add(
      LoginButtonClickEvent(
        username: usernameController.text,
        password: passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginsBloc, LoginsState>(
      bloc: loginsBloc,

      // Only rebuild UI for UI-related states
      buildWhen:
          (previous, current) =>
              current is! LoginsActionState &&
              current is! LoginErrorState &&
              current is! LoginWrongCredentialsState,

      // Listener for one-time actions like navigation or snackbars
      listenWhen:
          (previous, current) =>
              current is LoginsActionState ||
              current is LoginErrorState ||
              current is LoginWrongCredentialsState,

      listener: (context, state) {
        if (state is LoginSuccessful) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
        } else if (state is LoginTogglePasswordState) {
          setState(() {
            isPasswordVisible = state.isPasswordVisible;
          });
        } else if (state is LoginErrorState ||
            state is LoginWrongCredentialsState) {
          final errorMessage =
              (state is LoginErrorState)
                  ? state.error
                  : (state as LoginWrongCredentialsState).error;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
          loginsBloc.add(ResetLoginEvent());
        }
      },

      builder: (context, state) {
        if (state is LoginLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return buildLoginForm(); // Always show form otherwise
      },
    );
  }

  Widget buildLoginForm() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2EBF70), 
                Color(0xFF2E7D32),
                Color(0xFF388E3C),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    SizedBox(height: 100),
                    Text(
                      'Login Here',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 30,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
                        Form(
                          key: globalKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Enter username',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 40),
                              TextFormField(
                                controller: passwordController,
                                obscureText: !isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Enter password',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      loginsBloc.add(
                                        LoginTogglePasswordEvent(),
                                      );
                                    },
                                    child: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                              SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _loginUser();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2EBF70),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
