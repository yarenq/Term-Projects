import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:restaurant_app/screens/table_selection_screen.dart';
import 'package:restaurant_app/services/table_service.dart';

void main() {
  testWidgets('Masa numarası boş girildiğinde hata mesajı gösteriliyor mu?',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TableService()),
        ],
        child: const MaterialApp(
          home: TableSelectionScreen(),
        ),
      ),
    );

    // "Enter" butonunu bul ve tıkla
    final enterButton = find.widgetWithText(ElevatedButton, 'Enter');
    expect(enterButton, findsOneWidget);

    await tester.tap(enterButton);
    await tester.pumpAndSettle();

    // Hata mesajı var mı?
    expect(
        find.textContaining('Lütfen masa numarasını giriniz'), findsOneWidget);
  });
}
