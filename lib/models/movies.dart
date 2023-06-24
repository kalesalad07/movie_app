import 'dart:convert';

Movie movieFromJson(String id, String str) =>
    Movie.fromJson(id, json.decode(str));

String movieToJson(Movie data) => json.encode(data.toJson());

class Movie {
  String id;
  String ageRating;
  String description;
  List<String> images;
  int imdbRating;
  String tagline;
  String title;
  String trailer;
  int year;
  bool liked;

  Movie(
      {required this.id,
      required this.ageRating,
      required this.description,
      required this.images,
      required this.imdbRating,
      required this.tagline,
      required this.title,
      required this.trailer,
      required this.year,
      this.liked = false});

  factory Movie.fromApi(Map movie) => Movie(
      id: movie['imdb_id'],
      ageRating: '',
      description: '',
      images: [],
      imdbRating: 0,
      tagline: '',
      title: movie['title'],
      trailer: '',
      year: movie['year']);

  factory Movie.fromJson(String id, Map<String, dynamic> json) => Movie(
        id: id,
        ageRating: json["age_rating"],
        description: json["description"],
        images: List<String>.from(json["images"].map((x) => x)),
        imdbRating: json["imdb_rating"],
        tagline: json["tagline"],
        title: json["title"],
        trailer: json["trailer"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "age_rating": ageRating,
        "description": description,
        "images": List<dynamic>.from(images.map((x) => x)),
        "imdb_rating": imdbRating,
        "tagline": tagline,
        "title": title,
        "trailer": trailer,
        "year": year,
      };
}
