import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/repos_viewmodel.dart';
import '../services/github_service.dart';
import '../widgets/repo_card.dart';
import '../widgets/state_views.dart';

class ReposScreen extends StatelessWidget {
  final String username;

  const ReposScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReposViewModel(context.read<GithubService>())..fetchRepos(username),
      child: _ReposScreenContent(username: username),
    );
  }
}

class _ReposScreenContent extends StatelessWidget {
  final String username;

  const _ReposScreenContent({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReposViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositories'),
        actions: [
          Row(
            children: [
              Text(
                viewModel.sortOption == SortOption.stars ? 'Stars' : 'Recent',
                style: const TextStyle(fontSize: 14),
              ),
              IconButton(
                icon: const Icon(Icons.sort),
                tooltip: 'Toggle Sort',
                onPressed: viewModel.toggleSort,
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(viewModel),
    );
  }

  Widget _buildBody(ReposViewModel viewModel) {
    switch (viewModel.state) {
      case ReposState.loading:
        return const LoadingView();
      case ReposState.error:
        return ErrorView(
          message: viewModel.errorMessage,
          onRetry: () => viewModel.fetchRepos(username),
        );
      case ReposState.data:
        if (viewModel.repos.isEmpty) {
          return const Center(child: Text('No repositories found.'));
        }
        return ListView.builder(
          itemCount: viewModel.repos.length,
          itemBuilder: (context, index) {
            return RepoCard(repo: viewModel.repos[index]);
          },
        );
    }
  }
}
