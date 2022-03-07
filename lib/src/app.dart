import 'package:bloc_movie_my/src/blocs/infinity_blocs/infinity_bloc.dart';
import 'package:bloc_movie_my/src/blocs/search_blocs/search_bloc.dart';
import 'package:bloc_movie_my/src/blocs/search_blocs/search_state.dart';
import 'package:bloc_movie_my/src/ui/movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Movie App',
    //   theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
    //   home: MultiBlocProvider(
    //     providers: [
    //       BlocProvider(
    //         create: (context) => MovieBloc(
    //           MovieInitialState(),
    //         ),
    //       ),
    //     ],
    //     child: const MoviesPage(),
    //   ),
    // );
    return MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (context) => MovieBloc(
        //     InitialState(),
        //   ),
        // ),
        BlocProvider(
          create: (context) => InfinityBloc()..add(MovieFetched()),
        ),
        BlocProvider(
          create: (context) => SearchBloc(
            SearchStateEmpty(),
          ),
        ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        title: 'Flutter Demo',
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.red,
          appBarTheme: Theme.of(context).appBarTheme,

          // Define the default font family.
          fontFamily: 'Monotype Coursiva',

          // Define the TextTheme that specifies the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 20.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontFamily: 'Hind'),
          ),
        ),
        home: const MoviesPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
