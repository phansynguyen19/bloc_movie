class MovieModel {
  const MovieModel({
    required this.title,
    required this.urlImage,
    required this.backdrop_path,
    required this.overview,
  });

  final String title;
  final String urlImage;
  final String backdrop_path;
  final String overview;
}
