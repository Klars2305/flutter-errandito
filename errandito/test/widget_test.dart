import 'package:flutter_test/flutter_test.dart';

import 'package:errandito/main.dart';

void main() {
  testWidgets('shows splash screen call to action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ErrandditoApp());

    expect(find.text('WELCOME'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
