import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/github_user.dart';
import '../models/github_repo.dart';

class GithubService {
  final String baseUrl = 'https://api.github.com';
  
  // You might want to add a headers map here for authentication if rate limited
  // Map<String, String> get headers => {'Authorization': 'Bearer YOUR_TOKEN'};

  Future<GithubUser> getUser(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$username'));
    
    if (response.statusCode == 200) {
      return GithubUser.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }

  Future<List<GithubRepo>> getRepos(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$username/repos?per_page=100'));
    
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => GithubRepo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load repositories: ${response.statusCode}');
    }
  }
}
