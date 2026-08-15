import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/github_repo.dart';

class RepoCard extends StatelessWidget {
  final GithubRepo repo;

  const RepoCard({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              repo.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (repo.description != null) ...[
              const SizedBox(height: 8),
              Text(
                repo.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black87),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                if (repo.language != null) ...[
                  const Icon(Icons.code, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(repo.language!, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(width: 16),
                ],
                const Icon(Icons.star, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Text(repo.stargazersCount.toString(), style: const TextStyle(color: Colors.grey)),
                const Spacer(),
                if (repo.updatedAt != null)
                  Text(
                    'Updated: ${DateFormat.yMMMd().format(repo.updatedAt!)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
