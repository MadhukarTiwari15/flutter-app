import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apppoc/main.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialLocale: Locale('en')));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
