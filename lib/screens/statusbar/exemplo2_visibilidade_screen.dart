import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

/// Uma opção de exibição das barras do sistema.
class _ModoBarra {
  final String nome;
  final String descricao;
  final String codigo;
  final Future<void> Function() aplicar;

  const _ModoBarra({
    required this.nome,
    required this.descricao,
    required this.codigo,
    required this.aplicar,
  });
}

/// EXEMPLO 2 — Controle da VISIBILIDADE da StatusBar (forma imperativa).
///
/// Aqui não existe widget na árvore: a tela chama diretamente o
/// [SystemChrome.setEnabledSystemUIMode], que vale para o app inteiro até
/// alguém mudar de novo. Por isso a tela precisa RESTAURAR o modo normal no
/// [dispose], senão as outras telas continuariam sem barra de status.
class Exemplo2VisibilidadeScreen extends StatefulWidget {
  const Exemplo2VisibilidadeScreen({super.key});

  @override
  State<Exemplo2VisibilidadeScreen> createState() => _Exemplo2VisibilidadeScreenState();
}

class _Exemplo2VisibilidadeScreenState extends State<Exemplo2VisibilidadeScreen> {
  static final _modos = [
    _ModoBarra(
      nome: 'Normal',
      descricao: 'Barras visíveis; o app desenha por trás delas (edge-to-edge).',
      codigo: 'SystemChrome.setEnabledSystemUIMode(\n  SystemUiMode.edgeToEdge,\n);',
      aplicar: () => SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
    ),
    _ModoBarra(
      nome: 'Só sem StatusBar',
      descricao: 'Esconde apenas a barra de status e mantém a barra de navegação.',
      codigo: 'SystemChrome.setEnabledSystemUIMode(\n  SystemUiMode.manual,\n  overlays: [SystemUiOverlay.bottom],\n);',
      aplicar: () => SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]),
    ),
    _ModoBarra(
      nome: 'Lean Back',
      descricao: 'Esconde tudo. Um toque em qualquer lugar da tela traz as barras de volta.',
      codigo: 'SystemChrome.setEnabledSystemUIMode(\n  SystemUiMode.leanBack,\n);',
      aplicar: () => SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack),
    ),
    _ModoBarra(
      nome: 'Imersivo',
      descricao: 'Esconde tudo. Deslizar a partir da borda traz as barras de volta.',
      codigo: 'SystemChrome.setEnabledSystemUIMode(\n  SystemUiMode.immersive,\n);',
      aplicar: () => SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive),
    ),
    _ModoBarra(
      nome: 'Imersivo Sticky',
      descricao: 'Modo foco do jogo: deslizar mostra as barras por alguns segundos e elas somem sozinhas.',
      codigo: 'SystemChrome.setEnabledSystemUIMode(\n  SystemUiMode.immersiveSticky,\n);',
      aplicar: () => SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky),
    ),
  ];

  late _ModoBarra _modo = _modos.first;
  bool? _barrasVisiveis;
  final List<String> _eventos = [];

  @override
  void initState() {
    super.initState();
    // Avisa o app sempre que o sistema mostrar ou esconder as barras
    // (usado nos modos leanBack, immersive e immersiveSticky).
    SystemChrome.setSystemUIChangeCallback((visiveis) async {
      if (!mounted) return;
      setState(() {
        _barrasVisiveis = visiveis;
        _registrar(visiveis ? 'Sistema MOSTROU as barras' : 'Sistema ESCONDEU as barras');
      });
    });
  }

  @override
  void dispose() {
    // Restaura o comportamento padrão para as demais telas do app.
    SystemChrome.setSystemUIChangeCallback(null);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _registrar(String texto) {
    final agora = TimeOfDay.now();
    final segundos = DateTime.now().second.toString().padLeft(2, '0');
    _eventos.insert(0, '${agora.hour.toString().padLeft(2, '0')}:'
        '${agora.minute.toString().padLeft(2, '0')}:$segundos  $texto');
    if (_eventos.length > 5) _eventos.removeLast();
  }

  Future<void> _selecionarModo(_ModoBarra modo) async {
    await modo.aplicar();
    if (!mounted) return;
    setState(() {
      _modo = modo;
      _registrar('Modo alterado para "${modo.nome}"');
    });
  }

  @override
  Widget build(BuildContext context) {
    // viewPadding.top é a altura ocupada pela barra de status. Quando ela é
    // escondida, o valor cai e o cabeçalho sobe — o layout reage sozinho.
    final alturaStatusBar = MediaQuery.viewPaddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              color: AppColors.indigoDark,
              padding: EdgeInsets.fromLTRB(14, alturaStatusBar + 16, 16, 16),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Exemplo 2 · Visibilidade',
                    style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                ),
              ]),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Painel com os valores lidos em tempo real
                  Row(children: [
                    Expanded(child: _Indicador(
                      rotulo: 'Altura da StatusBar',
                      valor: '${alturaStatusBar.toStringAsFixed(1)} dp',
                      cor: AppColors.yellow,
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: _Indicador(
                      rotulo: 'Callback do sistema',
                      valor: switch (_barrasVisiveis) {
                        null => 'aguardando',
                        true => 'visíveis',
                        false => 'ocultas',
                      },
                      cor: _barrasVisiveis == false ? AppColors.red : AppColors.green,
                    )),
                  ]),

                  const SizedBox(height: 24),
                  const Text('Escolha o modo (SystemUiMode)',
                    style: TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  RadioGroup<_ModoBarra>(
                    groupValue: _modo,
                    onChanged: (m) { if (m != null) _selecionarModo(m); },
                    child: Column(
                      children: _modos.map((m) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: m == _modo ? AppColors.indigo : AppColors.surface2, width: 1.5),
                          ),
                          child: RadioListTile<_ModoBarra>(
                            value: m,
                            activeColor: AppColors.indigo,
                            title: Text(m.nome, style: const TextStyle(
                              color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                            subtitle: Text(m.descricao, style: const TextStyle(
                              color: AppColors.textSub, fontSize: 11.5)),
                          ),
                        ),
                      )).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text('Código aplicado agora',
                    style: TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.surface2),
                    ),
                    child: Text(_modo.codigo, style: const TextStyle(
                      color: AppColors.indigo, fontFamily: 'monospace', fontSize: 11.5, height: 1.5)),
                  ),

                  const SizedBox(height: 24),
                  const Text('Eventos',
                    style: TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  if (_eventos.isEmpty)
                    const Text('Nenhum evento ainda.', style: TextStyle(color: AppColors.textSub, fontSize: 12))
                  else
                    ..._eventos.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(e, style: const TextStyle(
                        color: AppColors.textMuted, fontFamily: 'monospace', fontSize: 11)),
                    )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Indicador extends StatelessWidget {
  final String rotulo;
  final String valor;
  final Color cor;

  const _Indicador({required this.rotulo, required this.valor, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(rotulo, style: const TextStyle(color: AppColors.textSub, fontSize: 11)),
        const SizedBox(height: 6),
        Text(valor, style: TextStyle(color: cor, fontSize: 18, fontWeight: FontWeight.w900)),
      ]),
    );
  }
}
