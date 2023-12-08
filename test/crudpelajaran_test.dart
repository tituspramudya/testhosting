import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/view/InputPage.dart';
import 'package:example/view/listAdd.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Dropdown and TextFields Test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    await tester.pumpWidget(
      const MaterialApp(
        home: InputPage(
          title: 'INPUT',
          id: null,
          name: null,
          guru: null,
          deskripsi: null,
        ),
      ),
    );

    // Find the dropdown button using the key
    final dropdownButtonFinder = find.byKey(const Key('dropdown'));
    final guruTextFieldFinder = find.byKey(const Key('guru'));
    final deskripsiTextFieldFinder = find.byKey(const Key('deskripsi'));
    final saveButtonFinder = find.byKey(const Key('save'));

    await tester.tap(dropdownButtonFinder);
    await tester.pumpAndSettle();

    final dropdownItemFinder = find.text('Ilmu Pengetahuan Alam');
    await tester.tap(dropdownButtonFinder);
    await tester.pumpAndSettle();

    await tester.enterText(guruTextFieldFinder, 'Joko');
    await tester.enterText(deskripsiTextFieldFinder, 'Santusa');
    await tester.pumpAndSettle();

    // Hide the keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.tap(saveButtonFinder);
    await tester.pumpAndSettle();

    await tester.pumpAndSettle();

    expect(find.byType(listAdd), findsOneWidget);
  });
}
