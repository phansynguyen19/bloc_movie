import 'package:bloc_movie_my/app_localozation.dart';
import 'package:bloc_movie_my/fake_data.dart';
import 'package:bloc_movie_my/src/blocs/authentication_blocs/authentication_bloc.dart';
import 'package:bloc_movie_my/src/blocs/authentication_blocs/authentication_event.dart';
import 'package:bloc_movie_my/src/blocs/authentication_blocs/authentication_state.dart';
import 'package:bloc_movie_my/src/blocs/google_authen_blocs/google_authen_bloc.dart';
import 'package:bloc_movie_my/src/blocs/infinity_blocs/infinity_bloc.dart';
import 'package:bloc_movie_my/src/blocs/language_blocs/language_bloc.dart';
import 'package:bloc_movie_my/src/blocs/search_blocs/search_bloc.dart';
import 'package:bloc_movie_my/src/blocs/search_blocs/search_event.dart';
import 'package:bloc_movie_my/src/ui/login_page.dart';
import 'package:bloc_movie_my/src/ui/search_page.dart';
import 'package:bloc_movie_my/src/widgets/movie_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class MoviesPage extends StatefulWidget {
  MoviesPage({Key? key}) : super(key: key);
  // List languages = ["English", "VietNam"];
  // String lang = "English";

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  // List<MovieModel> _movie = [];
  final _scrollController = ScrollController();
  TextEditingController editingController = TextEditingController();
  late SearchBloc _searchBloc;
  late AuthenticationBloc _authenticationBloc;
  late LanguageBloc _language;
  final user_gg = FirebaseAuth.instance.currentUser;

  String? username;
  @override
  void initState() {
    /// Interact with the `bloc` to trigger `state` changes.
    // BlocProvider.of<MovieBloc>(context).add(GetMovieEvent());
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchBloc = context.read<SearchBloc>();
    _authenticationBloc = context.read<AuthenticationBloc>();
    _language = context.read<LanguageBloc>();
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title =
        AppLocalization.of(context).getTranslatedValues('title_movie_page');
    String search_text =
        AppLocalization.of(context).getTranslatedValues('Search_text');
    String logout_text =
        AppLocalization.of(context).getTranslatedValues('logout_text');
    GlobalKey<ScaffoldState> secondScreenKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: user_gg != null
                    ? Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Row(
                          children: [
                            user_gg?.photoURL != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage("${user_gg?.photoURL}"),
                                    radius: 20,
                                    // child: Image.network("${user_gg.photoURL}"),
                                  )
                                : Container(),
                            user_gg?.displayName != null
                                ? Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text("${user_gg?.displayName}",
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    : BlocBuilder<AuthenticationBloc, AuthenticationState>(
                        builder: (context, state) {
                          if (state is AuthenticationStateSuccess) {
                            return Row(
                              children: [
                                state.user.avatar_path != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            "${state.user.avatar_path}"),
                                        radius: 20,
                                        // child: Image.network("${user_gg.photoURL}"),
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            "https://www.seekpng.com/png/detail/428-4287240_no-avatar-user-circle-icon-png.png"),
                                        radius: 20,
                                        // child: Image.network("${user_gg.photoURL}"),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    state.user.username,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.blue,
                ),
                title: Text(logout_text),
                onTap: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.language,
                  color: Colors.blue,
                ),
                title: Text('English'),
                onTap: () {
                  _language..add(LoadLanguage(locale: Locale('en', 'EN')));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.language,
                  color: Colors.blue,
                ),
                title: Text('VietNam'),
                onTap: () {
                  _language..add(LoadLanguage(locale: Locale('vi', '')));
                },
              ),
            ],
          ),
        ),
        key: secondScreenKey,
        appBar: AppBar(
          title: TextButton(
            onPressed: () {
              _scrollController.jumpTo(0);
            },
            child: Text(
              title,
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: DropdownButton(
                dropdownColor: Colors.deepPurpleAccent[100],
                underline: SizedBox(),
                value: Language.lang,
                onChanged: (value) {
                  setState(() {
                    if (value == 'VietNam') {
                      _language..add(LoadLanguage(locale: Locale('vi', '')));
                    } else
                      _language..add(LoadLanguage(locale: Locale('en', 'EN')));

                    Language.lang = value.toString();
                  });
                },
                items: Language.languages.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ),
            // IconButton(
            //   onPressed: () {
            //     _authenticationBloc.add(LogoutPressed());
            //     Navigator.of(context).pushAndRemoveUntil(
            //       MaterialPageRoute(
            //         builder: (context) => LoginPage(),
            //       ),
            //       (route) => false,
            //     );
            //   },
            //   icon: Icon(Icons.logout),
            // )
          ],
        ),
        body: Column(
          children: [
            _searchbar(search_text, context),
            Container(
              child: BlocListener<InfinityBloc, InfinityState>(
                listener: (context, state) {
                  // if (state.status == MovieStatus.success) {
                  //   if (_movie.length == 0) {
                  //     _movie.addAll(state.movieModel);
                  //   } else if (_movie.length > 0) {
                  //     _movie.clear();
                  //     _movie.addAll(state.movieModel);
                  //   }
                  // }
                  // print(state.status.toString());
                },
                child: BlocBuilder<InfinityBloc, InfinityState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case MovieStatus.failure:
                        return const Center(
                            child: Text('failed to fetch movie'));
                      case MovieStatus.success:
                        if (state.movieModel.isEmpty) {
                          return const Center(child: Text('no movie'));
                        }
                        return Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              context.read<InfinityBloc>().add(Initial());
                              context
                                  .read<InfinityBloc>()
                                  .state
                                  .movieModel
                                  .clear();
                              context.read<InfinityBloc>().add(MovieFetched());
                            },
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return index >= state.movieModel.length
                                    ? Center(
                                        child: SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 1.5),
                                        ),
                                      )
                                    : MovieListItem(
                                        movie: state.movieModel[index],
                                        index: index,
                                      );
                              },
                              itemCount: state.hasReachedMax
                                  ? state.movieModel.length
                                  : state.movieModel.length + 1,
                              controller: _scrollController,
                            ),
                          ),
                        );
                      default:
                        return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton:
            BlocBuilder<InfinityBloc, InfinityState>(builder: (context, state) {
          return state.movieModel.length > 20
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_circle_up,
                    color: Colors.blue,
                    size: 40,
                  ),
                  onPressed: () {
                    _scrollController.jumpTo(0);
                  })
              : Container();
        }));
  }

  Widget _searchbar(String search_text, BuildContext seachContext) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        showCursor: false,
        controller: editingController,
        autocorrect: false,
        onTap: () async {
          // FocusScope.of(seachContext).unfocus();

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (seachContext) => SearchPage(),
            ),
          );

          // Navigator.push(
          //   context,
          //   PageTransition(
          //       type: PageTransitionType.bottomToTop,
          //       child: SearchPage(),
          //       inheritTheme: true,
          //       opaque: true,
          //       duration: Duration(milliseconds: 300),
          //       ctx: context),
          // );
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          hintText: '${search_text}',
        ),
      ),
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<InfinityBloc>().add(MovieFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
