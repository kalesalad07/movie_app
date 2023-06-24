import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppService with ChangeNotifier {
  late final SharedPreferences sharedPreferences;
  final StreamController<bool> _loginStateChange =
      StreamController<bool>.broadcast();
  bool _loginState = false;
  String _uid = '';
  bool _initialized = false;
  // bool _onboarding = false;

  AppService(this.sharedPreferences);

  bool get loginState => _loginState;
  bool get initialized => _initialized;
  //bool get onboarding => _onboarding;
  Stream<bool> get loginStateChange => _loginStateChange.stream;

  set loginState(bool state) {
    sharedPreferences.setBool('Login', state);
    _loginState = state;
    _loginStateChange.add(state);
    notifyListeners();
  }

  String get uid => _uid;

  set uid(String user) {
    sharedPreferences.setString('uid', user);
    _uid = user;
  }

  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }

  // set onboarding(bool value) {
  //   sharedPreferences.setBool(ONBOARD_KEY, value);
  //   _onboarding = value;
  //   notifyListeners();
  // }

  Future<void> onAppStart() async {
    //_onboarding = sharedPreferences.getBool(ONBOARD_KEY) ?? false;
    _loginState = sharedPreferences.getBool('Login') ?? false;
    _uid = sharedPreferences.getString('uid') ?? '';
    // This is just to demonstrate the splash screen is working.
    // In real-life applications, it is not recommended to interrupt the user experience by doing such things.
    await Future.delayed(const Duration(seconds: 2));

    _initialized = true;
    notifyListeners();
  }
}
