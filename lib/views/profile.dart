import 'package:flutter/material.dart';

import '../models/data.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user, required this.onLogout});

  final User user;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: const Color(0xFFFFE9E4),
              child: Text(
                user.username[0].toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFC92836),
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Username', style: TextStyle(color: Color(0xFF77716B))),
            const SizedBox(height: 5),
            Text(
              user.username,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 28),
            OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFC92836),
                minimumSize: const Size(160, 48),
                side: const BorderSide(color: Color(0xFFC92836)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
