import 'package:bloc_movie_my/app_localozation.dart';
import 'package:bloc_movie_my/src/blocs/authentication_blocs/authentication_bloc.dart';
import 'package:bloc_movie_my/src/blocs/authentication_blocs/authentication_state.dart';
import 'package:bloc_movie_my/src/blocs/google_authen_blocs/google_authen_bloc.dart';
import 'package:bloc_movie_my/src/blocs/infinity_blocs/infinity_bloc.dart';
import 'package:bloc_movie_my/src/blocs/language_blocs/language_bloc.dart';
import 'package:bloc_movie_my/src/blocs/search_blocs/search_bloc.dart';
import 'package:bloc_movie_my/src/blocs/search_blocs/search_state.dart';
import 'package:bloc_movie_my/src/resources/authentication_repository.dart';
import 'package:bloc_movie_my/src/resources/user_repository.dart';
import 'package:bloc_movie_my/src/ui/login_page.dart';
import 'package:bloc_movie_my/src/ui/movies_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
            create: (_) => InfinityBloc()..add(MovieFetched()),
          ),
          BlocProvider(
            create: (_) => SearchBloc(
              SearchStateEmpty(),
            ),
          ),
          BlocProvider(
            create: (_) => AuthenticationBloc(
              AuthenticationStateEmpty(),
            ),
          ),
          BlocProvider(
            create: (_) => LanguageBloc(
              LanguageState.initial(),
            ),
          ),
          BlocProvider(
            create: (_) => AuthBloc(),
          ),
        ],
        child:
            BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
          return MaterialApp(
            locale: state.locale,
            localizationsDelegates: [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en', ''), // English, no country code
              Locale('vi', ''), // VietNam, no country code
            ],
            themeMode: ThemeMode.light,
            title: 'Flutter Demo',
            theme: ThemeData(
              // Define the default brightness and colors.
              brightness: Brightness.light,
              primaryColor: Colors.blue,
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
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
                if (snapshot.hasData) {
                  return MoviesPage();
                }
                // Otherwise, they're not signed in. Show the sign in page.
                return LoginPage();
              },
            ),
            // home: AppView(),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (_) => LoginPage.route(),
          );
        }),
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
