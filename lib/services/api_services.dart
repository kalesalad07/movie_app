import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movies.dart';

class ApiService {
  static const apiKey = '991a1779demshbb49135bb161b12p1c24b7jsn50d6ba889c63';
  static const apiUrl = 'https://movies-tv-shows-database.p.rapidapi.com';

  getDetailsById(String id) async {
    var headers = {
      'Type': 'get-movie-details',
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
    };
    var request = http.Request('GET', Uri.parse('$apiUrl/?movieid=$id'));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    Movie ret_movie;

    if (response.statusCode == 200) {
      String vr = await response.stream.bytesToString();
      print(vr);
      var movie = jsonDecode(vr);
      print(movie);

      ret_movie = Movie(
          id: movie['imdb_id'],
          ageRating: movie['rated'] ?? '',
          description: movie['description'],
          images: [''],
          imdbRating: double.parse(movie['imdb_rating']).round(),
          tagline: movie['tagline'] ?? '',
          title: movie['title'],
          trailer: movie['youtube_trailer_key'],
          year: int.parse(movie['year']));
      return ret_movie;
    } else {
      print(response.reasonPhrase);
    }
  }

  getIdByName(String query) async {
    List<Movie> moviesList = [];
    var headers = {
      'Type': 'get-movies-by-title',
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
    };
    var request = http.Request('GET', Uri.parse('$apiUrl/?title=$query'));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String vr = await response.stream.bytesToString();

      Map data = jsonDecode(vr);

      for (final movie in data['movie_results']) {
        print(movie);
        moviesList.add(Movie.fromApi(movie));
      }
    } else {
      print(response.reasonPhrase);
    }
    moviesList.sort((movie1, movie2) => -movie1.year.compareTo(movie2.year));
    return moviesList;
  }

  getImageById(Movie movie) async {
    var headers = {
      'Type': 'get-movies-images-by-imdb',
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
    };
    var request =
        http.Request('GET', Uri.parse('$apiUrl/?movieid=${movie.id}'));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      movie.images = [data['poster'], data['fanart']];
    } else {
      print(response.reasonPhrase);
    }
  }
}
