import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:latihan_kuis/main.dart';

void main() {
  testWidgets('login, browse menu, view profile, and logout', (tester) async {
    await tester.pumpWidget(const GacoanApp());

    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Username wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Ariel saputra');
    await tester.enterText(find.byType(TextFormField).at(1), '124240010');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Mie Gacoan'), findsOneWidget);

    await tester.tap(find.text('Mie Gacoan'));
    await tester.pumpAndSettle();
    expect(find.text('Tentang menu'), findsOneWidget);
    expect(
      find.text('Mie pedas dengan pilihan level dan cita rasa khas Gacoan.'),
      findsOneWidget,
    );

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    expect(find.text('Ariel saputra'), findsOneWidget);

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang'), findsOneWidget);
  });

  testWidgets('rejects invalid credentials', (tester) async {
    await tester.pumpWidget(const GacoanApp());
    await tester.enterText(find.byType(TextFormField).at(0), 'Ariel');
    await tester.enterText(find.byType(TextFormField).at(1), '123');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Username atau password salah'), findsOneWidget);
    expect(find.text('Selamat datang'), findsOneWidget);
  });

  testWidgets('category filter narrows the catalog', (tester) async {
    await tester.pumpWidget(const GacoanApp());
    await tester.enterText(find.byType(TextFormField).at(0), 'Ariel saputra');
    await tester.enterText(find.byType(TextFormField).at(1), '124240010');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dimsum'));
    await tester.pumpAndSettle();
    expect(find.text('Udang Keju'), findsOneWidget);
    expect(find.text('Mie Gacoan'), findsNothing);
  });
}
