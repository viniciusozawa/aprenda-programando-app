import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_models.dart';
import '../models/progress.dart';
import '../widgets/app_widgets.dart';

class TrophyScreen extends StatefulWidget {
  const TrophyScreen({super.key});
  @override
  State<TrophyScreen> createState() => _TrophyScreenState();
}

class _TrophyScreenState extends State<TrophyScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween(begin: const Offset(0, 0.08), end: Offset.zero).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final totalStars = worlds.fold(0, (s, w) => s + GameProgress.worldTotalStars(w));
    final maxStars = worlds.fold(0, (s, w) => s + w.phases.length * 3);
    final completedPhases = worlds.fold(0, (s, w) =>
        s + w.phases.where((p) => GameProgress.getStars(p.id) > 0).length);
    final totalPhases = worlds.fold(0, (s, w) => s + w.phases.length);

    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: -40, right: -40, child: _orb(200, AppColors.yellow, 0.08)),
          Positioned(bottom: 100, left: -40, child: _orb(160, AppColors.indigo, 0.06)),
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  color: AppColors.surface,
                  padding: const EdgeInsets.fromLTRB(14, 16, 16, 16),
                  child: Row(children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text('Troféus', style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                  ]),
                ),

                Expanded(
                  child: FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slide,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Stats globais
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.yellow.withOpacity(0.3), width: 1.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _bigStat('🏆', '$totalStars', 'Estrelas'),
                                  Container(width: 1, height: 50, color: AppColors.surface2),
                                  _bigStat('✅', '$completedPhases', 'Fases'),
                                  Container(width: 1, height: 50, color: AppColors.surface2),
                                  _bigStat('📊', totalPhases > 0
                                      ? '${((completedPhases / totalPhases) * 100).toInt()}%'
                                      : '0%', 'Progresso'),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),
                            // Barra de estrelas
                            Row(children: [
                              Expanded(child: NeonProgressBar(
                                value: maxStars > 0 ? totalStars / maxStars : 0,
                                color: AppColors.yellow,
                              )),
                              const SizedBox(width: 10),
                              Text('$totalStars / $maxStars ⭐',
                                style: const TextStyle(color: AppColors.yellow, fontSize: 11, fontWeight: FontWeight.bold)),
                            ]),

                            const SizedBox(height: 24),

                            // Cards por mundo
                            ...worlds.map((world) => _WorldTrophyCard(world: world)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bigStat(String icon, String value, String label) => Column(
    children: [
      Text(icon, style: const TextStyle(fontSize: 28)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w900)),
      Text(label, style: const TextStyle(color: AppColors.textSub, fontSize: 10)),
    ],
  );

  Widget _orb(double size, Color color, double opacity) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(opacity)),
  );
}

class _WorldTrophyCard extends StatelessWidget {
  final World world;
  const _WorldTrophyCard({required this.world});

  @override
  Widget build(BuildContext context) {
    final stars = GameProgress.worldTotalStars(world);
    final maxStars = world.phases.length * 3;
    final progress = GameProgress.worldProgress(world);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: world.locked ? AppColors.surface : world.colorDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: world.locked ? AppColors.surface2 : world.color.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(world.icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(world.subtitle,
                style: TextStyle(
                  color: world.locked ? AppColors.textSub : AppColors.white,
                  fontSize: 16, fontWeight: FontWeight.bold,
                )),
              Text(world.concepts,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ])),
            if (world.locked)
              const Text('🔒', style: TextStyle(fontSize: 20))
            else
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('$stars/$maxStars',
                  style: TextStyle(color: world.color, fontSize: 18, fontWeight: FontWeight.w900)),
                const Text('estrelas', style: TextStyle(color: AppColors.textSub, fontSize: 10)),
              ]),
          ]),

          if (!world.locked) ...[
            const SizedBox(height: 12),
            NeonProgressBar(value: progress, color: world.color, height: 6),
            const SizedBox(height: 10),

            // Fases individuais
            Wrap(
              spacing: 8, runSpacing: 8,
              children: world.phases.map((phase) {
                final phaseStars = GameProgress.getStars(phase.id);
                final accessible = GameProgress.isPhaseAccessible(phase, world);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: phaseStars > 0
                          ? world.color.withOpacity(0.5)
                          : AppColors.surface2,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text('F${phase.id}',
                        style: TextStyle(
                          color: phaseStars > 0 ? AppColors.white : AppColors.textSub,
                          fontSize: 11, fontWeight: FontWeight.bold,
                        )),
                      const SizedBox(height: 3),
                      accessible
                          ? Row(mainAxisSize: MainAxisSize.min,
                              children: List.generate(3, (i) => Text(
                                i < phaseStars ? '★' : '☆',
                                style: TextStyle(
                                  color: i < phaseStars ? AppColors.yellow : AppColors.surface2,
                                  fontSize: 10,
                                ),
                              )))
                          : const Text('🔒', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
