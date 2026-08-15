class GithubRepo {
  final String name;
  final String? description;
  final int stargazersCount;
  final String? language;
  final DateTime? updatedAt;

  GithubRepo({
    required this.name,
    this.description,
    required this.stargazersCount,
    this.language,
    this.updatedAt,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) {
    return GithubRepo(
      name: json['name'] ?? '',
      description: json['description'],
      stargazersCount: json['stargazers_count'] ?? 0,
      language: json['language'],
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }
}
