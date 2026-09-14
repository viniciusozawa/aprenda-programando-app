import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

/// Um tema de barra de status: cor de fundo + brilho recomendado dos ícones.
class _TemaStatusBar {
  final String nome;
  final Color cor;
  final Brightness iconesRecomendados;

  const _TemaStatusBar(this.nome, this.cor, this.iconesRecomendados);

  bool get transparente => cor == Colors.transparent;
}

/// EXEMPLO 1 — Personalização do ESTILO da StatusBar (forma declarativa).
///
/// O estilo é descrito por um [SystemUiOverlayStyle] e entregue ao Flutter por
/// um [AnnotatedRegion]. O framework lê a região que está sob a barra de status
/// e aplica o estilo automaticamente a cada frame — ao sair da tela, o estilo
/// da tela anterior volta a valer, sem código extra.
class Exemplo1EstiloScreen extends StatefulWidget {
  const Exemplo1EstiloScreen({super.key});

  @override
  State<Exemplo1EstiloScreen> createState() => _Exemplo1EstiloScreenState();
}

class _Exemplo1EstiloScreenState extends State<Exemplo1EstiloScreen> {
  static const _temas = [
    _TemaStatusBar('Transparente', Colors.transparent, Brightness.light),
    _TemaStatusBar('Neon Rosa', AppColors.red, Brightness.light),
    _TemaStatusBar('Índigo', AppColors.indigoDark, Brightness.light),
    _TemaStatusBar('Amarelo', AppColors.yellow, Brightness.dark),
    _TemaStatusBar('Verde', AppColors.green, Brightness.dark),
    _TemaStatusBar('Claro', AppColors.white, Brightness.dark),
  ];

  _TemaStatusBar _tema = _temas[1];
  Brightness _icones = Brightness.light;

  // Monta o estilo a partir das escolhas do usuário.
  SystemUiOverlayStyle get _estilo => SystemUiOverlayStyle(
    statusBarColor: _tema.cor,                 // Android: cor de fundo da barra
    statusBarIconBrightness: _icones,          // Android: ícones claros ou escuros
    statusBarBrightness: _icones == Brightness.light
        ? Brightness.dark                      // iOS: informa o brilho do FUNDO,
        : Brightness.light,                    // por isso o valor é invertido
  );

  void _selecionarTema(_TemaStatusBar tema) {
    setState(() {
      _tema = tema;
      _icones = tema.iconesRecomendados;
    });
  }

  @override
  Widget build(BuildContext context) {
    final alturaStatusBar = MediaQuery.viewPaddingOf(context).top;
    final corCabecalho = _tema.transparente ? AppColors.bg : _tema.cor;
    final textoCabecalho = ThemeData.estimateBrightnessForColor(corCabecalho) == Brightness.dark
        ? AppColors.white
        : AppColors.bg;
    final contrasteRuim = ThemeData.estimateBrightnessForColor(corCabecalho) == _icones;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _estilo,
      child: Scaffold(
        body: Column(
          children: [
            // Faixa pintada ATRÁS da barra de status. No Android 15+ (edge-to-edge
            // obrigatório) o statusBarColor é ignorado, então o app desenha a cor.
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: corCabecalho,
              padding: EdgeInsets.fromLTRB(14, alturaStatusBar + 16, 16, 16),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, color: textoCabecalho, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Exemplo 1 · Estilo',
                    style: TextStyle(color: textoCabecalho, fontSize: 20, fontWeight: FontWeight.w900)),
                ),
              ]),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text('👆 Observe a barra de status no topo do aparelho enquanto altera as opções.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13, height: 1.4)),

                  const SizedBox(height: 24),
                  const _Titulo('1. Cor de fundo (statusBarColor)'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _temas.map((t) => _ChipTema(
                      tema: t,
                      selecionado: t == _tema,
                      onTap: () => _selecionarTema(t),
                    )).toList(),
                  ),

                  const SizedBox(height: 24),
                  const _Titulo('2. Cor dos ícones (statusBarIconBrightness)'),
                  const SizedBox(height: 10),
                  SegmentedButton<Brightness>(
                    segments: const [
                      ButtonSegment(value: Brightness.light, icon: Icon(Icons.light_mode), label: Text('Claros')),
                      ButtonSegment(value: Brightness.dark, icon: Icon(Icons.dark_mode), label: Text('Escuros')),
                    ],
                    selected: {_icones},
                    onSelectionChanged: (s) => setState(() => _icones = s.first),
                  ),
                  const SizedBox(height: 10),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: contrasteRuim
                        ? const _Aviso(
                            key: ValueKey('ruim'),
                            icone: '⚠️',
                            texto: 'Contraste baixo: os ícones ficam difíceis de ler sobre este fundo.',
                            cor: AppColors.orange,
                          )
                        : const _Aviso(
                            key: ValueKey('bom'),
                            icone: '✅',
                            texto: 'Bom contraste: hora e bateria legíveis.',
                            cor: AppColors.green,
                          ),
                  ),

                  const SizedBox(height: 24),
                  const _Titulo('Código aplicado agora'),
                  const SizedBox(height: 10),
                  _CodigoAtual(estilo: _estilo, tema: _tema),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  final String texto;
  const _Titulo(this.texto);

  @override
  Widget build(BuildContext context) => Text(texto,
    style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w700));
}

class _ChipTema extends StatelessWidget {
  final _TemaStatusBar tema;
  final bool selecionado;
  final VoidCallback onTap;

  const _ChipTema({required this.tema, required this.selecionado, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selecionado ? AppColors.surface2 : AppColors.surface,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: selecionado ? AppColors.yellow : AppColors.surface2, width: 1.5),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 16, height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tema.transparente ? AppColors.bg : tema.cor,
              border: Border.all(color: AppColors.textSub),
            ),
          ),
          const SizedBox(width: 8),
          Text(tema.nome, style: TextStyle(
            color: selecionado ? AppColors.white : AppColors.textMuted,
            fontSize: 12,
            fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
          )),
        ]),
      ),
    );
  }
}

class _Aviso extends StatelessWidget {
  final String icone;
  final String texto;
  final Color cor;

  const _Aviso({super.key, required this.icone, required this.texto, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cor.withValues(alpha: 0.5)),
      ),
      child: Row(children: [
        Text(icone, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(child: Text(texto, style: TextStyle(color: cor, fontSize: 12))),
      ]),
    );
  }
}

/// Mostra, em forma de código, o SystemUiOverlayStyle que está em uso.
class _CodigoAtual extends StatelessWidget {
  final SystemUiOverlayStyle estilo;
  final _TemaStatusBar tema;

  const _CodigoAtual({required this.estilo, required this.tema});

  String get _corEmCodigo => tema.transparente
      ? 'Colors.transparent'
      : 'Color(0x${tema.cor.toARGB32().toRadixString(16).toUpperCase()})';

  @override
  Widget build(BuildContext context) {
    final codigo = 'AnnotatedRegion<SystemUiOverlayStyle>(\n'
        '  value: SystemUiOverlayStyle(\n'
        '    statusBarColor: $_corEmCodigo,\n'
        '    statusBarIconBrightness: ${estilo.statusBarIconBrightness},\n'
        '    statusBarBrightness: ${estilo.statusBarBrightness},\n'
        '  ),\n'
        '  child: Scaffold(...),\n'
        ')';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surface2),
      ),
      child: Text(codigo, style: const TextStyle(
        color: AppColors.green, fontFamily: 'monospace', fontSize: 11.5, height: 1.5,
      )),
    );
  }
}
