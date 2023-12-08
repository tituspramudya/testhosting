import 'package:flutter_test/flutter_test.dart';
import 'package:example/view/home.dart';
import 'package:example/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Login Success Test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginView(),
      ),
    );

    final usernameField = find.byKey(const Key('username'));
    final passwordField = find.byKey(const Key('password'));
    final loginButton = find.byKey(const Key('login'));

    await tester.enterText(usernameField, 'memet');
    await tester.enterText(passwordField, '12345');
    
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verify that HomeView is present.
    expect(find.byType(HomeView), findsOneWidget);
  });
}
