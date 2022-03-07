import 'package:bloc_movie_my/src/blocs/search_blocs/search_bloc.dart';
import 'package:bloc_movie_my/src/blocs/search_blocs/search_event.dart';
import 'package:bloc_movie_my/src/blocs/search_blocs/search_state.dart';
import 'package:bloc_movie_my/src/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  GlobalKey<ScaffoldState> searchPage = GlobalKey<ScaffoldState>();
  TextEditingController editingController = TextEditingController();
  late SearchBloc _searchBloc;

  @override
  void initState() {
    /// Interact with the `bloc` to trigger `state` changes.
    super.initState();
    _searchBloc = context.read<SearchBloc>();
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: searchPage,
      // appBar: AppBar(
      //   title: Text('Search Page'),
      //   leading: new IconButton(
      //     icon: new Icon(Icons.arrow_back),
      //     onPressed: () {
      //       editingController.text = '';
      //       _searchBloc.add(const TextChanged(text: ''));
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: Column(
        children: [
          _searchbar(),
          BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
            return _searchBody(state);
          })
        ],
      ),
    );
  }

  Widget _searchBody(state) {
    if (state is SearchStateLoading) {
      return const CircularProgressIndicator();
    }
    if (state is SearchStateError) {
      return Text(state.error);
    }
    if (state is SearchStateSuccess) {
      return state.items.isEmpty
          ? const Text('No Results')
          : Expanded(child: _SearchResults(items: state.items));
    } else {
      return Container();
    }
  }

  Widget _searchbar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: editingController,
        autocorrect: false,
        autofocus: true,
        onChanged: (text) {
          _searchBloc.add(
            TextChanged(text: text),
          );
        },
        decoration: InputDecoration(
          prefixIcon: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              editingController.text = '';
              _searchBloc.add(const TextChanged(text: ''));
              Navigator.pop(context);
            },
          ),
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

  void _onClearTapped() {
    editingController.text = '';
    _searchBloc.add(const TextChanged(text: ''));
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({Key? key, required this.items}) : super(key: key);

  final List<MovieModel> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return _SearchResultItem(item: items[index]);
        },
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  const _SearchResultItem({Key? key, required this.item}) : super(key: key);

  final MovieModel item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      leading: CircleAvatar(
        backgroundImage:
            NetworkImage('https://image.tmdb.org/t/p/w185${item.urlImage}'),
      ),
    );
  }
}
