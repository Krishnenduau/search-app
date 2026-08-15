import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _searchesKey = 'recent_searches';

  Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchesKey) ?? [];
  }

  Future<void> saveSearch(String username) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> searches = prefs.getStringList(_searchesKey) ?? [];
    
    // Remove if exists to move to top
    searches.remove(username);
    searches.insert(0, username);
    
    // Keep only last 5
    if (searches.length > 5) {
      searches = searches.sublist(0, 5);
    }
    
    await prefs.setStringList(_searchesKey, searches);
  }
}
