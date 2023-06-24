import 'package:flutter/material.dart';
import 'package:movie_app/ui/search.dart';
import 'package:provider/provider.dart';

import '../services/auth_services.dart';
import '../services/firestore-services.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search())),
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                authService.signOut();
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: FirestoreService().getMovies(),
    );
  }
}
