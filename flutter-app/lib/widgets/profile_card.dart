import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/github_user.dart';

class ProfileCard extends StatelessWidget {
  final GithubUser user;
  final VoidCallback onTap;

  const ProfileCard({Key? key, required this.user, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: CachedNetworkImageProvider(user.avatarUrl),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name ?? user.login,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (user.name != null)
                          Text(
                            '@${user.login}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                          ),
                      ],
                    ),
                  )
                ],
              ),
              if (user.bio != null) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.bio!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn(context, 'Repos', user.publicRepos),
                  _buildStatColumn(context, 'Followers', user.followers),
                  _buildStatColumn(context, 'Following', user.following),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
