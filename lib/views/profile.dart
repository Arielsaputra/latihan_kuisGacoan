import 'package:flutter/material.dart';

import '../models/data.dart';

// Halaman profil menampilkan data user yang sedang login.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user, required this.onLogout});

  // Data user yang dikirim dari root aplikasi saat login berhasil.
  final User user;

  // Fungsi callback untuk logout dan mengembalikan ke halaman login.
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar awal nama user, diambil dari huruf pertama username.
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

            // Label untuk username.
            const Text('Username', style: TextStyle(color: Color(0xFF77716B))),
            const SizedBox(height: 5),

            // Menampilkan username lengkap user.
            Text(
              user.username,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 28),

            // Tombol logout untuk keluar dari akun dan kembali ke login page.
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
