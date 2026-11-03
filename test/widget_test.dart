import 'package:flutter_test/flutter_test.dart';
import 'package:billai_app/app/app.dart';

void main() {
  testWidgets('login screen validates email', (tester) async {
    await tester.pumpWidget(const BillAiApp());
    await tester.tap(find.text('Войти'));
    await tester.pump();
    expect(find.text('Введите корректный email'), findsOneWidget);
  });
}
