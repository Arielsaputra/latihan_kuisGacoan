import 'package:flutter/material.dart';

import 'models/data.dart';
import 'views/home_page.dart';
import 'views/login_page.dart';

class GacoanApp extends StatefulWidget {
  const GacoanApp({super.key});

  @override
  State<GacoanApp> createState() => _GacoanAppState();
}

class _GacoanAppState extends State<GacoanApp> {
  User? _user;

  void _handleLogin(User user) {
    setState(() => _user = user);
  }

  void _handleLogout() {
    setState(() => _user = null);
  }

  @override
  Widget build(BuildContext context) {
    const brandRed = Color(0xFFC92836);

    return MaterialApp(
      title: 'Gacoan Menu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandRed,
          primary: brandRed,
          surface: const Color(0xFFFFFBF7),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFBF7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFBF7),
          foregroundColor: Color(0xFF292522),
          centerTitle: false,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE8E1DA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE8E1DA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: brandRed, width: 1.5),
          ),
        ),
      ),
      home: _user == null
          ? LoginPage(onLogin: _handleLogin)
          : HomeShell(user: _user!, onLogout: _handleLogout),
    );
  }
}
