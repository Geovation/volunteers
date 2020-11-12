// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:volunteers/main.dart';

void main() {
  testWidgets('VolunteerApp has a map and tile layer',
      (WidgetTester tester) async {
    // Build volunteer app and trigger a frame.
    await tester.pumpWidget(VolunteerApp());

    // Verify that flutter map and tile layer exist.
    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.byType(TileLayer), findsOneWidget);
  });
}
