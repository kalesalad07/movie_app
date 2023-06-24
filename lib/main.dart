import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:go_router/go_router.dart';
import 'package:movie_app/routing/app_router.dart';
import 'package:movie_app/services/app_services.dart';
import 'package:movie_app/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  runApp(riverpod.ProviderScope(
      child: MyApp(
    sharedPreferences: sharedPreferences,
  )));
}

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late AppService appService;
  late AuthService _authService;
  late StreamSubscription<bool> authSubscription;

  late StreamSubscription<bool> langSubscription;

  AuthService get authService => _authService;

  @override
  void initState() {
    appService = AppService(widget.sharedPreferences);
    _authService = AuthService();

    authSubscription = _authService.onAuthStateChange.listen(onAuthStateChange);

    super.initState();
  }

  void onAuthStateChange(bool login) {
    appService.loginState = login;
    appService.uid = _authService.currentUser!.uid;
  }

  @override
  void dispose() {
    authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppService>(create: (_) => appService),
        Provider<AppRouter>(create: (_) => AppRouter(appService)),
        Provider<AuthService>(create: (_) => _authService),
      ],
      child: Builder(
        builder: (context) {
          final GoRouter goRouter =
              Provider.of<AppRouter>(context, listen: false).router;
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: "MovieApp",
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
          );
        },
      ),
    );
  }
}
