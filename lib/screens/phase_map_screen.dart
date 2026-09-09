import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_models.dart';
import '../models/progress.dart';
import '../widgets/app_widgets.dart';
import 'game_screen.dart';
import 'trophy_screen.dart';
import 'settings_screen.dart';

class PhaseMapScreen extends StatefulWidget {
  final World world;
  const PhaseMapScreen({super.key, required this.world});
  @override
  State<PhaseMapScreen> createState() => _PhaseMapScreenState();
}

class _PhaseMapScreenState extends State<PhaseMapScreen> with SingleTickerProviderStateMixin {
  int _navIndex = 0;
  late final AnimationController _headerCtrl;
  late final Animation<double> _headerOpacity;
  late final Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _headerOpacity = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut));
    _headerSlide = Tween(begin: const Offset(0, -0.2), end: Offset.zero).animate(
        CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic));
    _headerCtrl.forward();
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    super.dispose();
  }

  void _handleNav(int i) {
    if (i == 0) { setState(() => _navIndex = 0); return; }
    if (i == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const TrophyScreen()));
    } else if (i == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.world;
    final progress = GameProgress.worldProgress(w);

    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: 200, right: -40, child: _orb(200, AppColors.indigo, 0.05)),
          Positioned(bottom: 100, left: -50, child: _orb(180, AppColors.orange, 0.05)),
          SafeArea(
            child: Column(
              children: [
                // Header animado
                FadeTransition(
                  opacity: _headerOpacity,
                  child: SlideTransition(
                    position: _headerSlide,
                    child: Container(
                      color: AppColors.surface,
                      padding: const EdgeInsets.fromLTRB(14, 16, 16, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(width: 5, height: 52, color: AppColors.red,
                              margin: const EdgeInsets.only(right: 12)),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(w.subtitle,
                                  style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                Text(w.name,
                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                              ],
                            )),
                            Text('${GameProgress.worldTotalStars(w)} ⭐',
                              style: TextStyle(color: w.color, fontWeight: FontWeight.bold)),
                          ]),
                          const SizedBox(height: 12),
                          Row(children: [
                            Expanded(child: NeonProgressBar(value: progress, color: w.color)),
                            const SizedBox(width: 10),
                            Text('${(progress * 100).toInt()}%',
                              style: TextStyle(color: w.color, fontSize: 11, fontWeight: FontWeight.bold)),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
                // Mapa de fases
                Expanded(
                  child: CustomPaint(
                    painter: _PathPainter(phases: w.phases),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: w.phases.length,
                      itemBuilder: (ctx, i) {
                        final phase = w.phases[i];
                        final accessible = GameProgress.isPhaseAccessible(phase, w);
                        return _PhaseNode(
                          phase: phase,
                          world: w,
                          index: i,
                          accessible: accessible,
                          onTap: () {
                            if (!accessible) return;
                            Navigator.push(context, PageRouteBuilder(
                              pageBuilder: (_, a, __) => GameScreen(phase: phase, world: w),
                              transitionsBuilder: (_, animation, __, child) => SlideTransition(
                                position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                                    .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                                child: FadeTransition(opacity: animation, child: child),
                              ),
                              transitionDuration: const Duration(milliseconds: 350),
                            )).then((_) => setState(() {})); // atualiza estrelas ao voltar
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: _navIndex, onTap: _handleNav),
    );
  }

  Widget _orb(double size, Color color, double opacity) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(opacity)),
  );
}

class _PhaseNode extends StatefulWidget {
  final Phase phase;
  final World world;
  final int index;
  final bool accessible;
  final VoidCallback onTap;

  const _PhaseNode({
    required this.phase,
    required this.world,
    required this.index,
    required this.accessible,
    required this.onTap,
  });
  @override
  State<_PhaseNode> createState() => _PhaseNodeState();
}

class _PhaseNodeState extends State<_PhaseNode> with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final AnimationController _entranceCtrl;
  late final Animation<double> _pulse;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  bool get _isDone => GameProgress.getStars(widget.phase.id) > 0;
  bool get _isCurrent => widget.accessible && !_isDone;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _pulse = Tween(begin: 1.0, end: 1.12).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _entranceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
    _fade = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut));
    final isRight = widget.phase.id % 2 == 0;
    _slide = Tween<Offset>(
      begin: Offset(isRight ? 0.2 : -0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 60 + widget.index * 80), () {
      if (mounted) _entranceCtrl.forward();
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phase = widget.phase;
    final world = widget.world;
    final isRight = phase.id % 2 == 0;

    Color circleColor;
    if (_isDone) circleColor = world.color;
    else if (_isCurrent) circleColor = AppColors.red;
    else circleColor = AppColors.surface2;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: SizedBox(
          height: 120,
          child: Row(
            mainAxisAlignment: isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isRight) ...[
                const SizedBox(width: 16),
                _label(world, phase),
                const SizedBox(width: 12),
              ],
              GestureDetector(
                onTap: widget.onTap,
                child: _isCurrent
                    ? AnimatedBuilder(
                        animation: _pulse,
                        builder: (_, __) => Transform.scale(
                          scale: _pulse.value,
                          child: _circle(circleColor, phase),
                        ),
                      )
                    : _circle(circleColor, phase),
              ),
              if (!isRight) ...[
                const SizedBox(width: 12),
                _label(world, phase),
              ],
              if (isRight) const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circle(Color color, Phase phase) {
    final stars = GameProgress.getStars(phase.id);
    return Container(
      width: 70, height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: _isCurrent
            ? Border.all(color: AppColors.yellow, width: 3)
            : _isDone
                ? Border.all(color: widget.world.color.withOpacity(0.5), width: 2)
                : null,
        boxShadow: _isCurrent
            ? [BoxShadow(color: AppColors.yellow.withOpacity(0.35), blurRadius: 16, spreadRadius: 2)]
            : _isDone
                ? [BoxShadow(color: widget.world.color.withOpacity(0.3), blurRadius: 12)]
                : null,
      ),
      alignment: Alignment.center,
      child: _isDone
          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${stars}★', style: TextStyle(
                color: AppColors.bg, fontSize: 14, fontWeight: FontWeight.w900)),
            ])
          : _isCurrent
              ? const Text('▶', style: TextStyle(color: AppColors.white, fontSize: 26, fontWeight: FontWeight.bold))
              : !widget.accessible
                  ? const Text('🔒', style: TextStyle(fontSize: 22))
                  : Text(phase.id.toString(), style: const TextStyle(
                      color: AppColors.textSub, fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }

  Widget _label(World world, Phase phase) {
    final stars = GameProgress.getStars(phase.id);
    final isRight = phase.id % 2 == 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: _isCurrent
                ? Border.all(color: AppColors.yellow.withOpacity(0.4), width: 1)
                : null,
          ),
          child: Column(
            crossAxisAlignment: isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(phase.title,
                style: TextStyle(
                  color: _isDone ? AppColors.white : _isCurrent ? AppColors.yellow : AppColors.textSub,
                  fontSize: 11, fontWeight: FontWeight.w600,
                )),
              const SizedBox(height: 2),
              Text(phase.concept,
                style: TextStyle(
                  color: _isDone ? world.color : AppColors.textSub,
                  fontSize: 10,
                )),
            ],
          ),
        ),
        if (_isDone) ...[
          const SizedBox(height: 4),
          StarRow(stars: stars, size: 13),
        ],
      ],
    );
  }
}

class _PathPainter extends CustomPainter {
  final List<Phase> phases;
  _PathPainter({required this.phases});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 3..style = PaintingStyle.stroke;
    final cellH = 120.0;
    for (int i = 0; i < phases.length - 1; i++) {
      final done = GameProgress.getStars(phases[i].id) > 0;
      paint.color = done ? AppColors.green.withOpacity(0.6) : AppColors.surface2.withOpacity(0.4);
      paint.strokeWidth = done ? 3 : 2;
      final isRight = (i + 1) % 2 == 0;
      final x1 = isRight ? size.width * 0.22 : size.width * 0.78;
      final x2 = isRight ? size.width * 0.78 : size.width * 0.22;
      final y1 = 16 + i * cellH + 60.0;
      final y2 = 16 + (i + 1) * cellH + 10.0;
      final path = Path()
        ..moveTo(x1, y1)
        ..cubicTo(x1, y1 + 30, x2, y2 - 30, x2, y2);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_PathPainter old) => true;
}
