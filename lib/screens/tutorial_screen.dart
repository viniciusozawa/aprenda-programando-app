import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_models.dart';
import '../models/progress.dart';
import '../widgets/app_widgets.dart';
import 'phase_map_screen.dart';

class TutorialScreen extends StatefulWidget {
  final World world;
  const TutorialScreen({super.key, required this.world});
  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> with TickerProviderStateMixin {
  final PageController _pageCtrl = PageController();
  int _page = 0;

  late final AnimationController _orbCtrl;
  late final Animation<double> _orbScale;

  static const _pages = [
    _TutorialPage(
      emoji: '🤖',
      title: 'Bem-vindo ao CodePlay BR!',
      body: 'Aqui você vai aprender lógica de programação resolvendo puzzles divertidos.\n\nO robô precisa da sua ajuda para chegar até a bandeira!',
      accent: AppColors.red,
    ),
    _TutorialPage(
      emoji: '📦',
      title: 'Blocos de Comando',
      body: 'Arraste blocos como  andar,  virar  e  repetir  para programar o robô.\n\nA ordem dos blocos importa — pense como um programador!',
      accent: AppColors.indigo,
    ),
    _TutorialPage(
      emoji: '⭐',
      title: 'Ganhe Estrelas',
      body: 'Leve o robô 🤖 até a bandeira 🚩 usando o menor número de blocos possível.\n\nMenos blocos = mais estrelas!\n3 blocos → ⭐⭐⭐',
      accent: AppColors.yellow,
    ),
    _TutorialPage(
      emoji: '🎯',
      title: 'Pronto para Jogar?',
      body: 'Toque em uma fase no mapa, monte sua sequência de blocos e pressione  Executar.\n\nBoa sorte, programador!',
      accent: AppColors.green,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _orbCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800))
      ..repeat(reverse: true);
    _orbScale = Tween(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(parent: _orbCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _orbCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _pages.length - 1) {
      _pageCtrl.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
    } else {
      _finish();
    }
  }

  void _finish() {
    GameProgress.markTutorialSeen(widget.world.id);
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (_, a, __) => PhaseMapScreen(world: widget.world),
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: FadeTransition(opacity: animation, child: child),
      ),
      transitionDuration: const Duration(milliseconds: 380),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final current = _pages[_page];

    return Scaffold(
      body: Stack(
        children: [
          // Orbs de fundo
          AnimatedBuilder(
            animation: _orbScale,
            builder: (_, __) => Stack(children: [
              Positioned(top: -40, left: -40,
                child: Transform.scale(scale: _orbScale.value,
                  child: _orb(240, current.accent, 0.1))),
              Positioned(bottom: 80, right: -60,
                child: Transform.scale(scale: 2.0 - _orbScale.value,
                  child: _orb(200, AppColors.indigo, 0.07))),
            ]),
          ),

          SafeArea(
            child: Column(
              children: [
                // Barra de progresso do tutorial
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    children: List.generate(_pages.length, (i) => Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: i <= _page ? current.accent : AppColors.surface2,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    )),
                  ),
                ),

                // Conteúdo das páginas
                Expanded(
                  child: PageView.builder(
                    controller: _pageCtrl,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemCount: _pages.length,
                    itemBuilder: (_, i) => _PageContent(page: _pages[i]),
                  ),
                ),

                // Botão
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                  child: NeonButton(
                    label: _page < _pages.length - 1 ? 'Próximo  ▶' : '🎮  Começar a Jogar!',
                    onTap: _next,
                    color: current.accent == AppColors.yellow ? AppColors.orange : current.accent,
                  ),
                ),

                // Pular
                if (_page < _pages.length - 1)
                  GestureDetector(
                    onTap: _finish,
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text('Pular tutorial',
                        style: TextStyle(color: AppColors.textSub, fontSize: 13)),
                    ),
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orb(double size, Color color, double opacity) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(opacity)),
  );
}

class _PageContent extends StatefulWidget {
  final _TutorialPage page;
  const _PageContent({required this.page});
  @override
  State<_PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scale = Tween(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fade = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)));
    _slide = Tween(begin: const Offset(0, 0.1), end: Offset.zero).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji principal
          ScaleTransition(
            scale: _scale,
            child: FadeTransition(
              opacity: _fade,
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.page.accent.withOpacity(0.12),
                  border: Border.all(color: widget.page.accent.withOpacity(0.3), width: 2),
                ),
                alignment: Alignment.center,
                child: Text(widget.page.emoji, style: const TextStyle(fontSize: 56)),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Título
          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Text(
                widget.page.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.page.accent,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Corpo
          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Text(
                widget.page.body,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 15,
                  height: 1.65,
                ),
              ),
            ),
          ),

          // Blocos de exemplo na página 2
          if (widget.page.emoji == '📦') ...[
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _fade,
              child: Wrap(
                spacing: 8, runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _exampleBlock('andar(1)', AppColors.orange),
                  _exampleBlock('virar(dir)', AppColors.indigo),
                  _exampleBlock('repetir(3)', AppColors.purple),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _exampleBlock(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(8),
      border: Border(left: BorderSide(color: color, width: 3)),
    ),
    child: Text(label, style: TextStyle(
      color: color, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'monospace',
    )),
  );
}

class _TutorialPage {
  final String emoji;
  final String title;
  final String body;
  final Color accent;
  const _TutorialPage({
    required this.emoji,
    required this.title,
    required this.body,
    required this.accent,
  });
}
