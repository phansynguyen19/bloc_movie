import 'package:bloc_movie_my/src/models/movie_model.dart';
import 'package:flutter/material.dart';

class MovieListItem extends StatelessWidget {
  const MovieListItem({Key? key, required this.movie, required this.index})
      : super(key: key);

  final MovieModel movie;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('${movie.urlImage}'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 20),
                child: Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
            ),
          ],
        ),
        // subtitle: Row(
        //   children: [
        //     CircleAvatar(
        //       backgroundImage: NetworkImage(
        //           'https://image.tmdb.org/t/p/w185${movie.urlImage}'),
        //     ),
        //   ],
        // ),
        leading: Text(
          (index + 1).toString(),
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
