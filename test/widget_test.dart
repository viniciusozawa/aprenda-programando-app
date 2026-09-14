import 'package:flutter_test/flutter_test.dart';

import 'package:codeplay_br/main.dart';
import 'package:codeplay_br/screens/home_screen.dart';

void main() {
  testWidgets('App abre na tela inicial', (WidgetTester tester) async {
    await tester.pumpWidget(const CodePlayBRApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
