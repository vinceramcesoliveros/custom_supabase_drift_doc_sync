import 'package:flutter_test/flutter_test.dart';
import 'package:custom_supabase_drift_sync/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Can call rust function', (WidgetTester tester) async {
    expect(find.textContaining('Result: `Hello, Tom!`'), findsOneWidget);
  });
}
