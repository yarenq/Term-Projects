import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/screens/login_screen.dart';

void main() {
  testWidgets('Login ekranı doğru şekilde render ediliyor',
      (WidgetTester tester) async {
    // Uygulamayı başlat
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Başlık kontrolü
    expect(find.text('Restaurant\nManagement'), findsOneWidget);

    // Alt başlık kontrolü
    expect(find.text('Choose your role to continue'), findsOneWidget);

    // Customer butonu
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Access menu and place orders'), findsOneWidget);

    // Kitchen Staff butonu
    expect(find.text('Kitchen Staff'), findsOneWidget);
    expect(find.text('Manage orders and kitchen'), findsOneWidget);

    // Admin butonu
    expect(find.text('Admin'), findsOneWidget);
    expect(find.text('System administration'), findsOneWidget);
  });
}
