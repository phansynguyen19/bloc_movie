import 'package:bloc_movie_my/src/models/movie_model.dart';
import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  final MovieModel movie;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Hero(
              tag: 2,
              child: Image.network(
                movie.backdrop_path,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: 200,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            // Image.network(
            //   movie.backdrop_path,
            //   fit: BoxFit.fitHeight,
            //   width: MediaQuery.of(context).size.width,
            // ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    movie.overview,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                  // Wrap(
                  //   children: <Widget>[
                  //     for (var genre in genresBy(movie.genreIds))
                  //       Chip(
                  //         label: Text(genre.name),
                  //       )
                  //   ],
                  // ),
                  // Text(
                  //   'Release Date: ' +
                  //       DateUtils.formatDate(movie., 'dd MMMM yyyy'),
                  //   textAlign: TextAlign.left,
                  //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  // ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
