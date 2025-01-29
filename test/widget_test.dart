import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qk/main.dart';

void main() {
  testWidgets('Verify app renders correctly', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify the presence of a title or specific text in your app.
    expect(find.text('Quark'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    // Optionally, you can test for specific buttons or widgets.
    expect(find.byType(ElevatedButton), findsWidgets); // For multiple buttons
  });
}
