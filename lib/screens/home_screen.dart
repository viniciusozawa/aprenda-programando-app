import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'world_select_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final AnimationController _orbCtrl;
  late final AnimationController _floatCtrl;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _btnSlide;
  late final Animation<double> _btnOpacity;
  late final Animation<double> _orbScale;
  late final Animation<double> _floatY;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _orbCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200))..repeat(reverse: true);
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3800))..repeat(reverse: true);

    _logoScale = Tween(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.0, 0.55, curve: Curves.elasticOut)));
    _logoOpacity = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.0, 0.25, curve: Curves.easeOut)));
    _textSlide = Tween(begin: const Offset(0, 0.25), end: Offset.zero).animate(
        CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.35, 0.72, curve: Curves.easeOutCubic)));
    _textOpacity = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.35, 0.72, curve: Curves.easeOut)));
    _btnSlide = Tween(begin: const Offset(0, 0.4), end: Offset.zero).animate(
        CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic)));
    _btnOpacity = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.55, 1.0, curve: Curves.easeOut)));
    _orbScale = Tween(begin: 0.92, end: 1.08).animate(
        CurvedAnimation(parent: _orbCtrl, curve: Curves.easeInOut));
    _floatY = Tween(begin: -10.0, end: 10.0).animate(
        CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _orbCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _orbScale,
            builder: (_, __) => Stack(children: [
              Positioned(top: -60, left: -60,
                child: Transform.scale(scale: _orbScale.value,
                  child: _orb(280, AppColors.red, 0.09))),
              Positioned(bottom: 120, right: -40,
                child: Transform.scale(scale: 2.0 - _orbScale.value,
                  child: _orb(220, AppColors.indigo, 0.08))),
              Positioned(top: 60, right: 20,
                child: Transform.scale(scale: _orbScale.value,
                  child: _orb(140, AppColors.orange, 0.06))),
              Positioned(bottom: 350, left: -30,
                child: Transform.scale(scale: 2.0 - _orbScale.value,
                  child: _orb(100, AppColors.purple, 0.05))),
            ]),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),

                  // Logo
                  Center(
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_logoScale, _logoOpacity, _floatY]),
                      builder: (_, __) => Opacity(
                        opacity: _logoOpacity.value,
                        child: Transform.translate(
                          offset: Offset(0, _floatY.value),
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: const _CodePlayLogo(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Título
                  FadeTransition(
                    opacity: _textOpacity,
                    child: SlideTransition(
                      position: _textSlide,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Aprenda',
                            style: TextStyle(color: AppColors.white, fontSize: 52, fontWeight: FontWeight.w900, height: 1.1)),
                          Text('Programação',
                            style: TextStyle(color: AppColors.white, fontSize: 44, fontWeight: FontWeight.w900, height: 1.1)),
                          Text('Jogando',
                            style: TextStyle(color: AppColors.yellow, fontSize: 52, fontWeight: FontWeight.w900, height: 1.2)),
                          SizedBox(height: 16),
                          Text('Aprenda lógica de programação\natravés de um jogo de puzzle interativo',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 15, height: 1.6)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Botões
                  FadeTransition(
                    opacity: _btnOpacity,
                    child: SlideTransition(
                      position: _btnSlide,
                      child: Column(
                        children: [
                          NeonButton(
                            label: '▶  Começar a Jogar',
                            onTap: () => Navigator.push(context, _slideRoute(const WorldSelectScreen())),
                            color: AppColors.red,
                          ),
                          const SizedBox(height: 14),
                          NeonButton(
                            label: 'Continuar Progresso',
                            onTap: () => Navigator.push(context, _slideRoute(const WorldSelectScreen())),
                            color: AppColors.indigo,
                            outline: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  const Center(
                    child: Text('Instituto Federal Sul de Minas Gerais · Campus Machado',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSub, fontSize: 10)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PageRoute _slideRoute(Widget page) => PageRouteBuilder(
    pageBuilder: (_, a, __) => page,
    transitionsBuilder: (_, animation, __, child) => SlideTransition(
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: FadeTransition(opacity: animation, child: child),
    ),
    transitionDuration: const Duration(milliseconds: 380),
  );

  Widget _orb(double size, Color color, double opacity) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(opacity)),
  );
}

// ── LOGO ─────────────────────────────────────────────────
class _CodePlayLogo extends StatelessWidget {
  const _CodePlayLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _LogoIcon(),
        const SizedBox(height: 14),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RichText(
              text: const TextSpan(children: [
                TextSpan(text: 'Code',
                  style: TextStyle(color: Colors.white, fontSize: 46, fontWeight: FontWeight.w900, height: 1.0)),
                TextSpan(text: 'Play',
                  style: TextStyle(color: AppColors.red, fontSize: 46, fontWeight: FontWeight.w900, height: 1.0)),
              ]),
            ),
            const SizedBox(width: 6),
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(6)),
              child: const Text('BR',
                style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w900, height: 1.0)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 110, height: 2, color: Colors.white),
            Container(width: 70, height: 2, color: AppColors.red),
          ],
        ),
        const SizedBox(height: 8),
        const Text('APRENDA PROGRAMAÇÃO JOGANDO',
          style: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 1.8, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _LogoIcon extends StatelessWidget {
  const _LogoIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160, height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Braço horizontal
          Positioned(
            top: 52, left: 0, right: 0,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF16122E),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          // Braço vertical
          Positioned(
            left: 52, top: 0, bottom: 0,
            child: Container(
              width: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF16122E),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          // Centro
          Center(child: Container(width: 56, height: 56, color: const Color(0xFF16122E))),
          // Borda glow horizontal
          Positioned(
            top: 49, left: -3, right: -3,
            child: Container(
              height: 62,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.indigo.withOpacity(0.45), width: 2),
                borderRadius: BorderRadius.circular(31),
              ),
            ),
          ),
          // Borda glow vertical
          Positioned(
            left: 49, top: -3, bottom: -3,
            child: Container(
              width: 62,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.indigo.withOpacity(0.45), width: 2),
                borderRadius: BorderRadius.circular(31),
              ),
            ),
          ),
          // Bloco vermelho principal
          Positioned(
            top: 6, left: 24, right: 24,
            child: Container(
              height: 106,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Color(0xFFE11D48), Color(0xFFC0143C)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: AppColors.red.withOpacity(0.55), blurRadius: 28, spreadRadius: 2, offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('</>',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                  const SizedBox(height: 10),
                  _dots(4),
                  const SizedBox(height: 5),
                  _dots(3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dots(int n) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(n, (_) => Container(
      width: 5, height: 5,
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      decoration: const BoxDecoration(color: Colors.white30, shape: BoxShape.circle),
    )),
  );
}
