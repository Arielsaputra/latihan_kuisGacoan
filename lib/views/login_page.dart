import 'package:flutter/material.dart';

import '../models/data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLogin});

  // Fungsi callback yang dipanggil saat login berhasil.
  final ValueChanged<User> onLogin;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Kredensial yang valid untuk aplikasi ini.
  static const String _validUsername = 'Ariel saputra';
  static const String _validPassword = '124240010';

  // Key form untuk validasi input.
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengambil isi teks dari field username dan password.
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Menyembunyikan password saat awal masuk.
  bool _obscurePassword = true;

  @override
  void dispose() {
    // Membersihkan controller agar tidak terjadi memory leak.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // Cek apakah form sudah valid, misalnya username/password tidak kosong.
    if (!_formKey.currentState!.validate()) return;

    // Ambil data dari input lalu trim username agar spasi di awal/akhir tidak masalah.
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // Jika username/password tidak cocok dengan yang sudah ditentukan, tampilkan pesan.
    if (username != _validUsername || password != _validPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau password salah')),
      );
      return;
    }

    // Jika cocok, kirim data user ke parent widget agar masuk ke halaman utama.
    widget.onLogin(
      User(
        username: username,
        password: password,
        name: username,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(26),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                // Form ini mengelola validasi username dan password.
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Kotak logo/brand di bagian atas halaman login.
                    Container(
                      height: 170,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE9E4),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.restaurant_menu_rounded,
                              color: Color(0xFFC92836),
                              size: 58,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'MIE GACOAN',
                              style: TextStyle(
                                color: Color(0xFFC92836),
                                fontWeight: FontWeight.w900,
                                fontSize: 24,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Selamat datang',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Masuk untuk menjelajahi menu favoritmu.',
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(color: const Color(0xFF77716B)),
                    ),
                    const SizedBox(height: 24),
                    // Input untuk username.
                    TextFormField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      // Validasi: username tidak boleh kosong.
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Username wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    // Input untuk password dengan fitur show/hide.
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'Tampilkan password'
                              : 'Sembunyikan password',
                          // Toggle untuk menampilkan atau menyembunyikan password.
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      // Validasi: password tidak boleh kosong.
                      validator: (value) => value == null || value.isEmpty
                          ? 'Password wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 22),
                    // Tombol login yang memanggil method _login saat ditekan.
                    FilledButton(
                      onPressed: _login,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Masuk'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
