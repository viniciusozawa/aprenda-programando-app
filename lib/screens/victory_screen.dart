import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_models.dart';
import '../widgets/app_widgets.dart';
import 'phase_map_screen.dart';
import 'game_screen.dart';

class VictoryScreen extends StatefulWidget {
  final Phase phase;
  final World world;
  final int stars;

  const VictoryScreen({super.key, required this.phase, required this.world, required this.stars});

  @override
  State<VictoryScreen> createState() => _VictoryScreenState();
}

class _VictoryScreenState extends State<VictoryScreen> with TickerProviderStateMixin {
  late final AnimationController _trophyCtrl;
  late final AnimationController _starsCtrl;
  late final AnimationController _contentCtrl;
  late final AnimationController _confettiCtrl;

  late final Animation<double> _trophyScale;
  late final Animation<double> _trophyOpacity;
  late final Animation<double> _contentOpacity;
  late final Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    _trophyCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    _starsCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _contentCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _confettiCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))
      ..repeat();

    _trophyScale = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _trophyCtrl, curve: Curves.elasticOut));
    _trophyOpacity = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _trophyCtrl, curve: const Interval(0.0, 0.3, curve: Curves.easeOut)));
    _contentOpacity = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut));
    _contentSlide = Tween(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOutCubic));

    _trophyCtrl.forward().then((_) {
      _starsCtrl.forward().then((_) => _contentCtrl.forward());
    });
  }

  @override
  void dispose() {
    _trophyCtrl.dispose();
    _starsCtrl.dispose();
    _contentCtrl.dispose();
    _confettiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: 50, left: 50, child: _orb(230, AppColors.yellow, 0.08)),
          Positioned(bottom: 100, right: -30, child: _orb(160, AppColors.red, 0.07)),

          // Confete animado
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _confettiCtrl,
              builder: (_, __) => Stack(children: _animatedConfetti()),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Troféu com spring
                  ScaleTransition(
                    scale: _trophyScale,
                    child: FadeTransition(
                      opacity: _trophyOpacity,
                      child: const Text('🏆', style: TextStyle(fontSize: 90)),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Estrelas com stagger
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final start = i * 0.25;
                      final end = start + 0.45;
                      final anim = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _starsCtrl,
                          curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0), curve: Curves.elasticOut),
                        ),
                      );
                      return AnimatedBuilder(
                        animation: anim,
                        builder: (_, __) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Transform.scale(
                            scale: anim.value,
                            child: Text(
                              i < widget.stars ? '★' : '☆',
                              style: TextStyle(
                                fontSize: 52,
                                color: i < widget.stars ? AppColors.yellow : AppColors.textSub,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  FadeTransition(
                    opacity: _contentOpacity,
                    child: SlideTransition(
                      position: _contentSlide,
                      child: Column(
                        children: [
                          const Text('Fase Concluída!',
                            style: TextStyle(color: AppColors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 20),

                          SurfaceCard(
                            padding: const EdgeInsets.all(16),
                            child: Row(children: [
                              Container(width: 4, height: 44, color: AppColors.yellow,
                                margin: const EdgeInsets.only(right: 12)),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Text('Você aprendeu:',
                                  style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                                Text(widget.phase.concept,
                                  style: const TextStyle(color: AppColors.yellow, fontSize: 19, fontWeight: FontWeight.bold)),
                              ]),
                            ]),
                          ),

                          const SizedBox(height: 14),

                          SurfaceCard(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _stat('⌨️', '5', 'Comandos'),
                                Container(width: 1, height: 44, color: AppColors.surface2),
                                _stat('⏱️', '1:24', 'Tempo'),
                                Container(width: 1, height: 44, color: AppColors.surface2),
                                _stat('⭐', '${widget.stars}/3', 'Estrelas'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.orangeDark,
                              borderRadius: BorderRadius.circular(24),
                              border: const Border(left: BorderSide(color: AppColors.orange, width: 4)),
                            ),
                            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text('⚡ +150 XP  ·  Recorde pessoal!',
                                style: TextStyle(color: AppColors.orange, fontSize: 14, fontWeight: FontWeight.bold)),
                            ]),
                          ),

                          const SizedBox(height: 24),

                          NeonButton(
                            label: '▶  Próxima Fase',
                            onTap: () => Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => PhaseMapScreen(world: widget.world))),
                            color: AppColors.red,
                          ),

                          const SizedBox(height: 12),

                          NeonButton(
                            label: '↺  Tentar Novamente',
                            onTap: () => Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => GameScreen(phase: widget.phase, world: widget.world))),
                            color: AppColors.indigo,
                            outline: true,
                            height: 50,
                          ),

                          const SizedBox(height: 12),

                          NeonButton(
                            label: '🗺️  Voltar ao Mapa',
                            onTap: () => Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => PhaseMapScreen(world: widget.world))),
                            color: AppColors.surface2,
                            outline: true,
                            height: 50,
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String icon, String value, String label) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(icon, style: const TextStyle(fontSize: 18)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(color: AppColors.textSub, fontSize: 9)),
    ],
  );

  Widget _orb(double size, Color color, double opacity) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(opacity)),
  );

  List<Widget> _animatedConfetti() {
    final rng = math.Random(42);
    final colors = [AppColors.red, AppColors.yellow, AppColors.indigo, AppColors.orange, AppColors.green, AppColors.purple];
    return List.generate(16, (i) {
      final x = rng.nextDouble() * 380;
      final startY = -30.0 - rng.nextDouble() * 60;
      final endY = startY + 320 + rng.nextDouble() * 200;
      final size = 6.0 + rng.nextDouble() * 6;
      final color = colors[i % colors.length];
      final phase = (i / 16);
      final t = ((_confettiCtrl.value + phase) % 1.0);
      final y = startY + (endY - startY) * t;
      final opacity = t < 0.2 ? t / 0.2 : t > 0.75 ? (1.0 - t) / 0.25 : 1.0;
      return Positioned(
        left: x,
        top: y,
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.rotate(
            angle: t * math.pi * 2 * (i.isEven ? 1 : -1),
            child: Container(
              width: size, height: size,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
            ),
          ),
        ),
      );
    });
  }
}
