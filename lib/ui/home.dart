import 'package:flutter/material.dart';
import 'package:movie_app/ui/search.dart';

import '../services/firestore-services.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search())),
              icon: const Icon(Icons.search))
        ],
      ),
      body: FirestoreService().getMovies(),
    );
  }
}
