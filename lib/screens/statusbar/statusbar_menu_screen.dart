import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import 'exemplo1_estilo_screen.dart';
import 'exemplo2_visibilidade_screen.dart';

/// Estilo padrão da barra de status do CodePlay BR: fundo transparente e
/// ícones claros, combinando com o tema escuro "Neon Arcade".
const SystemUiOverlayStyle estiloStatusBarPadrao = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light, // Android: ícones claros
  statusBarBrightness: Brightness.dark,      // iOS: fundo escuro → ícones claros
);

/// Tela de entrada dos estudos sobre a StatusBar (barra de status).
///
/// O [AnnotatedRegion] desta tela reaplica o estilo padrão sempre que o
/// usuário volta de um dos exemplos, desfazendo as personalizações.
class StatusBarMenuScreen extends StatelessWidget {
  const StatusBarMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: estiloStatusBarPadrao,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.fromLTRB(14, 16, 16, 16),
                child: Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: const Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text('Estudo: StatusBar',
                    style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                ]),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      'A StatusBar é a faixa no topo da tela onde o sistema mostra hora, bateria, '
                      'sinal e notificações. No Flutter ela é controlada pela classe SystemUiOverlayStyle '
                      '(aparência) e pelo SystemChrome (visibilidade).',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    _ExemploCard(
                      numero: '1',
                      titulo: 'Estilo por tela',
                      descricao: 'Troca a cor de fundo e a cor dos ícones da barra de status '
                          'de forma declarativa, com AnnotatedRegion<SystemUiOverlayStyle>.',
                      cor: AppColors.red,
                      onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const Exemplo1EstiloScreen())),
                    ),
                    const SizedBox(height: 14),
                    _ExemploCard(
                      numero: '2',
                      titulo: 'Visibilidade e modo imersivo',
                      descricao: 'Esconde e mostra a barra de status de forma imperativa, '
                          'com SystemChrome.setEnabledSystemUIMode — ideal para um "modo foco" no jogo.',
                      cor: AppColors.indigo,
                      onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const Exemplo2VisibilidadeScreen())),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExemploCard extends StatelessWidget {
  final String numero;
  final String titulo;
  final String descricao;
  final Color cor;
  final VoidCallback onTap;

  const _ExemploCard({
    required this.numero,
    required this.titulo,
    required this.descricao,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border(left: BorderSide(color: cor, width: 4)),
          ),
          child: Row(children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: cor.withValues(alpha: 0.18),
              child: Text(numero, style: TextStyle(color: cor, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Exemplo $numero · $titulo',
                  style: const TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(descricao,
                  style: const TextStyle(color: AppColors.textSub, fontSize: 12, height: 1.4)),
              ]),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSub),
          ]),
        ),
      ),
    );
  }
}
