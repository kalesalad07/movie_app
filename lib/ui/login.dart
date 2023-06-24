import 'package:flutter/material.dart';
import 'package:movie_app/services/auth_services.dart';
import 'package:movie_app/utils/re_use_widgets.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          googleSignIn(context, () {
            authService.signInWithGoogle();
          })
        ],
      ),
    );
  }
}
