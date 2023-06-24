import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/models/movie_provider.dart';

import '../models/movies.dart';

final moviesChangeNotifierProvider =
    ChangeNotifierProvider<MoviesChangeNotifier>(
  (ref) => MoviesChangeNotifier(),
);

List<Movie> liked_movies = [];

isLiked(String movieid) {
  for (final movie in liked_movies) {
    if (movie.id == movieid) {
      return [true, movie];
    }
  }
  return [false, null];
}
