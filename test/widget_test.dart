import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_tracker/main.dart';

void main() {
  testWidgets('HydroFlow app renders title test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const HydroFlowApp());
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('HydroFlow'), findsOneWidget);
  });
}
