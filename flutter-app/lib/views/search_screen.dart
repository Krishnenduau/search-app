import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/search_viewmodel.dart';
import '../widgets/custom_search_field.dart';
import '../widgets/profile_card.dart';
import '../widgets/state_views.dart';
import 'repos_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    _focusNode.unfocus();
    context.read<SearchViewModel>().searchUser(query);
  }

  @override
  Widget build(BuildContext context) {
    final searchViewModel = context.watch<SearchViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Search'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchField(
              controller: _searchController,
              focusNode: _focusNode,
              onSubmitted: _onSearch,
            ),
          ),
          
          if (_focusNode.hasFocus && searchViewModel.recentSearches.isNotEmpty)
            _buildRecentSearches(searchViewModel.recentSearches),
            
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _focusNode.unfocus(),
              child: _buildBody(searchViewModel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches(List<String> searches) {
    return Material(
      elevation: 2,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: searches.length,
        itemBuilder: (context, index) {
          final term = searches[index];
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(term),
            onTap: () {
              _searchController.text = term;
              _onSearch(term);
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(SearchViewModel viewModel) {
    if (_focusNode.hasFocus) {
      return Container(color: Colors.transparent);
    }
    
    switch (viewModel.state) {
      case SearchState.initial:
        return const Center(child: Text('Search for a GitHub user'));
      case SearchState.loading:
        return const LoadingView();
      case SearchState.error:
        return ErrorView(
          message: viewModel.errorMessage,
          onRetry: () => _onSearch(_searchController.text),
        );
      case SearchState.data:
        if (viewModel.user != null) {
          return Align(
            alignment: Alignment.topCenter,
            child: ProfileCard(
              user: viewModel.user!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReposScreen(username: viewModel.user!.login),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
    }
  }
}
