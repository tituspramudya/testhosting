import 'package:flutter_test/flutter_test.dart';
import 'package:example/view/register_page.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:example/view/login_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Register Success Test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterView(),
      ),
    );
  
    final usernameField = find.byKey(const Key('usernames'));
    final emailField = find.byKey(const Key('email'));
    final passwordField = find.byKey(const Key('passwords'));
    final teleponField = find.byKey(const Key('telepon'));
    final tanggalField = find.byKey(const Key('tanggal'));
    final usiaField = find.byKey(const Key('usia'));
    final registerButton = find.byKey(const Key('register'));
    
    await tester.ensureVisible(registerButton);
    await tester.enterText(usernameField, 'AlGhazali');
    await tester.enterText(emailField, 'Ghazali@yahdaoo.com');
    await tester.enterText(passwordField, 'GhazaliGanz');
    await tester.enterText(teleponField, '13120412913121');
    await tester.enterText(tanggalField, '12/01/2001');
    await tester.enterText(usiaField, '22');
    // Hide the keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.tap(registerButton);
    await Future.delayed(const Duration(seconds: 15));
    await tester.pumpAndSettle();

    expect(find.byType(LoginView), findsOneWidget);
  });
}

