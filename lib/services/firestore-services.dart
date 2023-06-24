import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/utils/carousel_slider.dart';

import '../models/movies.dart';

class FirestoreService {
  addMovie(Movie movie) async {
    FirebaseFirestore.instance
        .collection('liked_movies')
        .doc(movie.id)
        .set(movie.toJson());
  }

  deleteMovie(Movie movie) async {
    FirebaseFirestore.instance
        .collection('liked_movies')
        .doc(movie.id)
        .delete();
  }

  getMovies() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('liked_movies').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading....");
        }
        // return Column(children: movieContainerList(snapshot.data!.docs));
        return likedMovieSlider(context, snapshot.data!.docs);
      },
    );
  }

  isLiked(String id) async {
    var a = await FirebaseFirestore.instance
        .collection('liked_movies')
        .doc(id)
        .get();
    if (a.exists) {
      Map<String, dynamic>? movieData = a.data();
      return movieData;
    }
    if (!a.exists) {
      print('Not exists');
      return null;
    }
  }
}
