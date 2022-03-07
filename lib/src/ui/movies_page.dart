import 'package:bloc_movie_my/src/blocs/infinity_blocs/infinity_bloc.dart';
import 'package:bloc_movie_my/src/blocs/search_blocs/search_bloc.dart';
import 'package:bloc_movie_my/src/blocs/search_blocs/search_event.dart';
import 'package:bloc_movie_my/src/ui/search_page.dart';
import 'package:bloc_movie_my/src/widgets/movie_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  // List<MovieModel> _movie = [];
  final _scrollController = ScrollController();
  TextEditingController editingController = TextEditingController();
  late SearchBloc _searchBloc;
  @override
  void initState() {
    /// Interact with the `bloc` to trigger `state` changes.
    // BlocProvider.of<MovieBloc>(context).add(GetMovieEvent());
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchBloc = context.read<SearchBloc>();
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trending Movies'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          children: [
            _searchbar(),
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
                    // if (state is LoadedState) {
                    //   return _handleUserResponseList(state);
                    // } else {
                    //   return CircularProgressIndicator();
                    // }
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
                              // _movie = [];
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
      ),
    );
  }

  Widget _searchbar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        showCursor: false,
        focusNode: FocusNode(
          canRequestFocus: false,
        ),
        autofocus: false,
        controller: editingController,
        autocorrect: false,
        onTap: () async {
          FocusScope.of(context).unfocus();
          editingController.clear();

          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => SearchPage(),
          //   ),
          // );

          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.bottomToTop,
                child: SearchPage(),
                inheritTheme: true,
                opaque: true,
                duration: Duration(milliseconds: 300),
                ctx: context),
          );
        },
        onChanged: (text) {
          _searchBloc.add(
            TextChanged(text: text),
          );
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          suffixIcon: GestureDetector(
            onTap: _onClearTapped,
            child: const Icon(Icons.clear),
          ),
          border: InputBorder.none,
          hintText: 'Enter a search',
        ),
      ),
    );
  }

  // Widget _handleUserResponseList(state) {
  //   // var _movieState = state as GetMovieState;

  //   if (state is LoadingState) {
  //     return const CircularProgressIndicator();
  //   }
  //   if (state is ErrorState) {
  //     return Text(state.error);
  //   }
  //   if (state is LoadedState) {
  //     return state.items.isEmpty
  //         ? const Text('No Results')
  //         : Expanded(
  //             child: ListView.builder(
  //               itemCount: state.items.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 MovieModel res = state.items[index];
  //                 return ListTile(
  //                   title: Text(res.title),
  //                   subtitle: Text((index + 1).toString()),
  //                   leading: CircleAvatar(
  //                     backgroundImage: NetworkImage(
  //                         'https://image.tmdb.org/t/p/w185${res.urlImage}'),
  //                   ),
  //                 );
  //               },
  //             ),
  //           );
  //   } else {
  //     return Container();
  //   }
  // }

  void _onClearTapped() {
    editingController.text = '';
    _searchBloc.add(const TextChanged(text: ''));
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
