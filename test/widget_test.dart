import 'package:brew_boracay/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CoffeeBreak app renders converted home screen', (tester) async {
    await tester.pumpWidget(const CoffeeBreakApp(useWebView: false));

    expect(find.text('CoffeeBreak Boracay'), findsOneWidget);
  });
}
