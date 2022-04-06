import 'package:bloc_movie_my/src/blocs/authentication_blocs/authentication_bloc.dart';
import 'package:bloc_movie_my/src/blocs/authentication_blocs/authentication_event.dart';
import 'package:bloc_movie_my/src/blocs/authentication_blocs/authentication_state.dart';
import 'package:bloc_movie_my/src/blocs/google_authen_blocs/google_authen_bloc.dart';
import 'package:bloc_movie_my/src/ui/movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = context.read<AuthenticationBloc>();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: TextField(
              controller: usernameController,
              autocorrect: false,
              autofocus: true,
              onChanged: (text) {
                // _authenticationBloc.add(
                //   LoginPressed(
                //       username: usernameController.text,
                //       password: passwordController.text),
                // );
              },
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(Icons.people),
                ),
                // border: InputBorder.none,
                hintText: 'Enter username',
                labelText: 'Username',
              ),
            ),
          ),
          // const Padding(padding: EdgeInsets.all(12)),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: TextField(
              controller: passwordController,
              autocorrect: false,
              autofocus: true,
              onChanged: (text) {
                // _authenticationBloc.add(
                //   LoginPressed(
                //       username: usernameController.text,
                //       password: passwordController.text),
                // );
              },
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(Icons.password),
                ),
                // border: InputBorder.none,
                hintText: 'Enter password',

                labelText: 'Password',
              ),
              obscureText: true,
            ),
          ),
          const Padding(padding: EdgeInsets.all(12)),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticationStateEmpty) {
                return ElevatedButton(
                  child: Text('Login'),
                  onPressed: () {
                    _authenticationBloc.add(
                      LoginPressed(
                        username: usernameController.text,
                        password: passwordController.text,
                      ),
                    );
                  },
                );
              }
              if (state is AuthenticationStateLoading) {
                return CircularProgressIndicator();
              }
              if (state is AuthenticationStateError) {
                return ElevatedButton(
                  child: Text('Login'),
                  onPressed: () {
                    _authenticationBloc.add(
                      LoginPressed(
                          username: usernameController.text,
                          password: passwordController.text),
                    );
                  },
                );
              } else {
                return Container();
              }
              // return state is AuthenticationStateEmpty
              //     ? ElevatedButton(
              //         child: Text('Login'),
              //         onPressed: () {
              //           _authenticationBloc.add(
              //             LoginPressed(
              //                 username: usernameController.text,
              //                 password: passwordController.text),
              //           );
              //         },
              //       )
              //     : CircularProgressIndicator();
            },
          ),

          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is AuthenticationStateError) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Authentication Failure')),
                  );
              }
              if (state is AuthenticationStateSuccess) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MoviesPage(),
                  ),
                  (route) => false,
                );
              }
            },
            child: Container(),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: InkWell(
              onTap: () {
                BlocProvider.of<AuthBloc>(context).add(
                  GoogleSignInRequested(),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(
                          GoogleSignInRequested(),
                        );
                      },
                      icon: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png",
                        height: 30,
                        width: 30,
                      ),
                    ),
                    Text('Login with Google')
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
