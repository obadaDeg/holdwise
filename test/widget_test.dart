import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdwise/app/holdwise_app.dart';
import 'package:holdwise/main.dart'; // Make sure this path is correct

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(HoldWiseApp()); // Ensure MyApp exists in main.dart
    expect(find.byType(HoldWiseApp), findsOneWidget);
  });
}
