import 'package:flutter/foundation.dart';
import '../models/github_user.dart';
import '../services/github_service.dart';
import '../services/local_storage_service.dart';

enum SearchState { initial, loading, data, error }

class SearchViewModel extends ChangeNotifier {
  final GithubService _githubService;
  final LocalStorageService _localStorageService;

  SearchViewModel(
    this._githubService,
    this._localStorageService,
  ) {
    _loadRecentSearches();
  }

  SearchState _state = SearchState.initial;
  SearchState get state => _state;

  GithubUser? _user;
  GithubUser? get user => _user;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _lastSearch = '';
  String get lastSearch => _lastSearch;

  List<String> _recentSearches = [];
  List<String> get recentSearches => _recentSearches;

  Future<void> _loadRecentSearches() async {
    _recentSearches =
        await _localStorageService.getRecentSearches();
    notifyListeners();
  }

  Future<void> searchUser(String username) async {
    final query = username.trim();

    if (query.isEmpty) return;

    _lastSearch = query;
    _state = SearchState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _user = await _githubService.getUser(query);

      await _localStorageService.saveSearch(query);
      _recentSearches =
          await _localStorageService.getRecentSearches();

      _state = SearchState.data;
    } catch (e) {
      _errorMessage =
          e.toString().replaceFirst('Exception: ', '');
      _state = SearchState.error;
    }

    notifyListeners();
  }
}