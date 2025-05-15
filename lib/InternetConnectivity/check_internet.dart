import 'package:internet_connection_checker/internet_connection_checker.dart';

class CheckInternetCon {
  static Future<bool> checkConnection() async {
    return await InternetConnectionChecker.createInstance().hasConnection;
  }
}

