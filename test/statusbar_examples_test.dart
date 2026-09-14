import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codeplay_br/main_statusbar.dart';

void main() {
  // Registra as chamadas enviadas ao canal de plataforma do SystemChrome.
  final chamadas = <MethodCall>[];

  setUp(() {
    chamadas.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      chamadas.add(call);
      return null;
    });
  });

  testWidgets('Exemplo 1 aplica o estilo escolhido via AnnotatedRegion', (tester) async {
    await tester.pumpWidget(const StatusBarExemplosApp());
    await tester.tap(find.textContaining('Exemplo 1'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Amarelo'));
    await tester.pumpAndSettle();

    final regiao = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
      find.byType(AnnotatedRegion<SystemUiOverlayStyle>).last);
    expect(regiao.value.statusBarIconBrightness, Brightness.dark);
    expect(find.textContaining('Bom contraste'), findsOneWidget);

    // Ícones claros sobre amarelo = contraste ruim
    await tester.tap(find.text('Claros'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Contraste baixo'), findsOneWidget);
  });

  testWidgets('Exemplo 2 muda o SystemUiMode e restaura ao sair', (tester) async {
    await tester.pumpWidget(const StatusBarExemplosApp());
    await tester.tap(find.textContaining('Exemplo 2'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Imersivo Sticky'));
    await tester.pumpAndSettle();
    expect(chamadas.any((c) => c.method == 'SystemChrome.setEnabledSystemUIMode'
        && c.arguments == 'SystemUiMode.immersiveSticky'), isTrue);

    chamadas.clear();
    Navigator.of(tester.element(find.textContaining('Exemplo 2 ·'))).pop();
    await tester.pumpAndSettle();
    expect(chamadas.any((c) => c.method == 'SystemChrome.setEnabledSystemUIMode'
        && c.arguments == 'SystemUiMode.edgeToEdge'), isTrue);
  });
}
