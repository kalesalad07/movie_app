import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/utils/re_use_widgets.dart';
import 'package:movie_app/utils/youtube_launcher.dart';

import '../models/movies.dart';
import '../services/firestore-services.dart';
import 'globals.dart';
import 'movie_container.dart';

slider(List<String> images) {
  List<Widget> carouselItems = [];
  for (final image in images) {
    carouselItems.add(
      Container(
        margin: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  return CarouselSlider(
    items: carouselItems,
    //Slider Container properties
    options: CarouselOptions(
      height: 300,
      enlargeCenterPage: true,
      autoPlay: true,
      aspectRatio: 16 / 9,
      autoPlayCurve: Curves.fastOutSlowIn,
      enableInfiniteScroll: true,
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      viewportFraction: 1,
    ),
  );
}

likedMovieSlider(BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> movies) {
  liked_movies = [];
  for (final movieDoc in movies) {
    Movie movie = Movie.fromJson(movieDoc.id, movieDoc.data());
    movie.liked = true;
    liked_movies.add(movie);
  }

  List<Widget> carouselItems = [];
  for (final movie in liked_movies) {
    carouselItems.add(Container(
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: SizedBox(
          height: 2 * double.infinity / 3,
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Text('${movie.title}(${movie.year})'),
              IconButton(
                  onPressed: () {
                    if (movie.liked) {
                      FirestoreService().deleteMovie(movie);
                    } else {
                      FirestoreService().addMovie(movie);
                    }
                  },
                  icon: (movie.liked)
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border)),
              slider(movie.images),
              Text(movie.tagline),
              bigText(movie.description),
              ratings(movie),
              (movie.trailer != '')
                  ? CuteButton(context, "Watch Trailer", () {
                      launchYoutubeVideo('https://youtu.be/${movie.trailer}');
                    })
                  : const Text('Trailer not available')
            ],
          ),
        )));
  }

  return CarouselSlider(
    items: carouselItems,
    //Slider Container properties
    options: CarouselOptions(
      height: double.infinity,
      enlargeCenterPage: true,
      autoPlay: false,
      autoPlayCurve: Curves.fastOutSlowIn,
      enableInfiniteScroll: true,
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      viewportFraction: 0.8,
    ),
  );
}
