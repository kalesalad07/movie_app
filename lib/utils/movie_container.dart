import 'package:flutter/material.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/services/firestore-services.dart';
import 'package:movie_app/utils/carousel_slider.dart';
import 'package:movie_app/utils/globals.dart';
import 'package:movie_app/utils/re_use_widgets.dart';
import 'package:movie_app/utils/stars.dart';
import 'package:movie_app/utils/youtube_launcher.dart';

import '../models/movies.dart';

// movieContainer(Movie movie) {
//   return Container(
//     decoration: BoxDecoration(border: Border.all()),
//     width: double.infinity,
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         GestureDetector(
//           child: Text('${movie.title}(${movie.year})'),
//           onTap: () {},
//         ),
//         IconButton(onPressed: () {}, icon: const Icon(Icons.favorite))
//       ],
//     ),
//   );
// }

// movieContainerList(List<QueryDocumentSnapshot<Map<String, dynamic>>> movies) {
//   List<Widget> movieContainers = [];
//   liked_movies = [];
//   for (final movieDoc in movies) {
//     Movie movie = Movie.fromJson(movieDoc.id, movieDoc.data());
//     movie.liked = true;
//     liked_movies.add(movie);
//     movieContainers.add(movieContainer(movie));
//   }
//   return movieContainers;
// }

movieItem(BuildContext context, Movie movie) {
  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('${movie.title}(${movie.year})'),
      ),
    ),
    onTap: () async {
      List likedResponse = isLiked(movie.id);
      if (likedResponse[0]) {
        movie = likedResponse[1];
        print('used firestore movie');
      } else {
        movie = await ApiService().getDetailsById(movie.id);
        await ApiService().getImageById(movie);
      }

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return movieDialog(context, movie);
        },
      );
    },
  );
}

Widget movieDialog(BuildContext context, Movie movie) {
  print(liked_movies);
  return Dialog(
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
                Navigator.of(context, rootNavigator: true).pop();
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
    ),
  );
}

ratings(Movie movie) {
  var starNum = (movie.imdbRating / 2).round();
  return Column(
    children: [
      showStars(starNum),
      Text(movie.ageRating),
    ],
  );
}
