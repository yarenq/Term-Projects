import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/main.dart'; // Proje adın pubspec.yaml'da 'restaurant_app' olarak tanımlıysa

void main() {
  testWidgets('Login ekranı açılıyor mu?', (WidgetTester tester) async {
    await tester.pumpWidget(const RestaurantApp());

    // Login ekranında "Giriş Yap" metni ya da butonu var mı?
    expect(find.text('Giriş Yap'), findsOneWidget);
  });
}

