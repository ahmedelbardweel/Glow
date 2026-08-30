import 'package:flutter_test/flutter_test.dart';
import 'package:glow/main.dart';

void main() {
  testWidgets('PortApp basic smoke test', (WidgetTester tester) async {
    // Tests that PortApp builds without throwing
    expect(const PortApp(), isNotNull);
  });
}
