import 'package:flutter/foundation.dart';
import '../models/github_repo.dart';
import '../services/github_service.dart';

enum ReposState { loading, data, error }
enum SortOption { stars, recent }

class ReposViewModel extends ChangeNotifier {
  final GithubService _githubService;

  ReposViewModel(this._githubService);

  ReposState _state = ReposState.loading;
  ReposState get state => _state;

  List<GithubRepo> _repos = [];
  List<GithubRepo> get repos {
    List<GithubRepo> sorted = List.from(_repos);
    if (_sortOption == SortOption.stars) {
      sorted.sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));
    } else {
      sorted.sort((a, b) {
        if (a.updatedAt == null && b.updatedAt == null) return 0;
        if (a.updatedAt == null) return 1;
        if (b.updatedAt == null) return -1;
        return b.updatedAt!.compareTo(a.updatedAt!);
      });
    }
    return sorted;
  }

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  SortOption _sortOption = SortOption.stars;
  SortOption get sortOption => _sortOption;

  void toggleSort() {
    _sortOption = _sortOption == SortOption.stars ? SortOption.recent : SortOption.stars;
    notifyListeners();
  }

  Future<void> fetchRepos(String username) async {
    _state = ReposState.loading;
    notifyListeners();

    try {
      _repos = await _githubService.getRepos(username);
      _state = ReposState.data;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = ReposState.error;
    }
    notifyListeners();
  }
}
