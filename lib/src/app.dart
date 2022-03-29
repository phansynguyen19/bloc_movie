import 'package:bloc_movie_my/src/blocs/authentication_blocs/authentication_bloc.dart';
import 'package:bloc_movie_my/src/blocs/authentication_blocs/authentication_state.dart';
import 'package:bloc_movie_my/src/blocs/infinity_blocs/infinity_bloc.dart';
import 'package:bloc_movie_my/src/blocs/login_blocs/login_bloc.dart';
import 'package:bloc_movie_my/src/blocs/search_blocs/search_bloc.dart';
import 'package:bloc_movie_my/src/blocs/search_blocs/search_state.dart';
import 'package:bloc_movie_my/src/resources/authentication_repository.dart';
import 'package:bloc_movie_my/src/resources/user_repository.dart';
import 'package:bloc_movie_my/src/ui/login_page.dart';
import 'package:bloc_movie_my/src/ui/movies_page.dart';
import 'package:bloc_movie_my/src/ui/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
    required this.userRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => InfinityBloc()..add(MovieFetched()),
          ),
          BlocProvider(
            create: (context) => SearchBloc(
              SearchStateEmpty(),
            ),
          ),
          BlocProvider(
            create: (_) => AuthenticationBloc(
              AuthenticationStateEmpty(),
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
          // home: AppView(),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (_) => LoginPage.route(),
        ),
      ),
    );
  }
}

// class AppView extends StatefulWidget {
//   @override
//   _AppViewState createState() => _AppViewState();
// }

// class _AppViewState extends State<AppView> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       onGenerateRoute: (_) => LoginPage.route(),
//     );
//     // return MaterialApp(
//     //   builder: (context, child) {
//     //     return BlocListener<AuthenticationBloc, AuthenticationState>(
//     //       listener: (context, state) {
//     //         switch (state.status) {
//     //           case AuthenticationStatus.authenticated:
//     //             Navigator.of(context).push(
//     //               MaterialPageRoute(
//     //                 builder: (context) => MoviesPage(),
//     //               ),
//     //             );
//     //             break;
//     //           case AuthenticationStatus.unauthenticated:
//     //             Navigator.of(context).push(
//     //               MaterialPageRoute(
//     //                 builder: (context) => LoginPage(),
//     //               ),
//     //             );
//     //             break;
//     //           default:
//     //             break;
//     //         }
//     //       },
//     //       child: child,
//     //     );
//     //   },
//     //   onGenerateRoute: (_) => SplashPage.route(),
//     // );
//   }
// }
