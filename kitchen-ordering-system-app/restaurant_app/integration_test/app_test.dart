import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('User can select table, add menu item to cart and see cart updated', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // 1. Table Selection Screen'de 'Table 1' seç
    final tableInput = find.byType(TextField);
    expect(tableInput, findsOneWidget);
    await tester.enterText(tableInput, 'Table 1');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // 2. MenuScreen açıldı mı kontrol et
    expect(find.textContaining('Menu'), findsOneWidget);

    // 3. İlk menü kartına tıkla (Add to Cart)
    final addToCartButtons = find.widgetWithText(ElevatedButton, 'Add to Cart');
    expect(addToCartButtons, findsWidgets);
    await tester.tap(addToCartButtons.first);
    await tester.pumpAndSettle();

    // 4. Add to Cart dialogunda 'Add to Cart' butonuna tıkla
    final dialogAddButton = find.widgetWithText(ElevatedButton, 'Add to Cart');
    expect(dialogAddButton, findsOneWidget);
    await tester.tap(dialogAddButton);
    await tester.pumpAndSettle();

    // 5. Sepette bir öğe var mı kontrol et (FloatingActionButton üzerinde yazı)
    final cartButton = find.byType(FloatingActionButton);
    expect(cartButton, findsOneWidget);
    expect(find.textContaining('Cart'), findsOneWidget);
  });
}

