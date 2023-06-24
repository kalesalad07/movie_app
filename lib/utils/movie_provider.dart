import 'dart:collection';

import 'package:flutter/widgets.dart';

import '../models/movies.dart';

class MoviesChangeNotifier extends ChangeNotifier {
  final List<Movie> _movies = [];

  UnmodifiableListView<Movie> get movies => UnmodifiableListView(_movies);

  void add(List<Movie> movie) {
    _movies.addAll(movie);
    notifyListeners();
  }

  void empty() {
    _movies.removeWhere((element) => true);
    notifyListeners();
  }
}
