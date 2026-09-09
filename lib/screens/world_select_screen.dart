import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_models.dart';
import '../models/progress.dart';
import '../widgets/app_widgets.dart';
import 'phase_map_screen.dart';
import 'tutorial_screen.dart';
import 'trophy_screen.dart';
import 'settings_screen.dart';

class WorldSelectScreen extends StatefulWidget {
  const WorldSelectScreen({super.key});
  @override
  State<WorldSelectScreen> createState() => _WorldSelectScreenState();
}

class _WorldSelectScreenState extends State<WorldSelectScreen> with SingleTickerProviderStateMixin {
  int _navIndex = 0;

  late final AnimationController _headerCtrl;
  late final Animation<double> _headerOpacity;
  late final Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: 60, right: -30, child: _orb(200, AppColors.green, 0.06)),
          Positioned(bottom: 100, left: -60, child: _orb(200, AppColors.red, 0.06)),
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
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                            Text('Escolha um Mundo',
                              style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                            SizedBox(height: 2),
                            Text('Selecione onde quer continuar',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          ]),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(16)),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Container(width: 10, height: 10,
                                decoration: const BoxDecoration(color: AppColors.yellow, shape: BoxShape.circle)),
                              const SizedBox(width: 6),
                              const Text('Nível 4  ⚡',
                                style: TextStyle(color: AppColors.yellow, fontSize: 11, fontWeight: FontWeight.bold)),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Lista de mundos com stagger
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    itemCount: worlds.length,
                    itemBuilder: (context, i) => _WorldCard(world: worlds[i], index: i),
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

  void _handleNav(int i) {
    if (i == 0) { setState(() => _navIndex = 0); return; }
    if (i == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const TrophyScreen()));
    } else if (i == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
    }
  }

  Widget _orb(double size, Color color, double opacity) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(opacity)),
  );
}

class _WorldCard extends StatefulWidget {
  final World world;
  final int index;
  const _WorldCard({required this.world, required this.index});
  @override
  State<_WorldCard> createState() => _WorldCardState();
}

class _WorldCardState extends State<_WorldCard> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 480));
    _slide = Tween<Offset>(begin: const Offset(0.25, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: 80 + widget.index * 130), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final world = widget.world;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: world.locked ? null : () => _openWorld(context, world),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: world.locked ? AppColors.surface : world.colorDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: world.locked ? AppColors.surface2 : world.color,
                width: world.locked ? 1 : 1.5,
              ),
              boxShadow: world.locked
                  ? null
                  : [BoxShadow(color: world.color.withOpacity(0.15), blurRadius: 16, offset: const Offset(0, 4))],
            ),
            child: Stack(
              children: [
                if (world.locked)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bg.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: world.locked ? _lockedContent() : _unlockedContent(context, world),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openWorld(BuildContext context, World world) {
    final dest = GameProgress.hasSeenTutorial(world.id)
        ? PhaseMapScreen(world: world)
        : TutorialScreen(world: world) as Widget;
    Navigator.push(context, PageRouteBuilder(
      pageBuilder: (_, a, __) => dest,
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: FadeTransition(opacity: animation, child: child),
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ));
  }

  Widget _lockedContent() {
    final world = widget.world;
    return SizedBox(
      height: 90,
      child: Row(children: [
        _iconCircle(world, 0.3),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(world.name, style: const TextStyle(color: AppColors.textSub, fontSize: 11, fontWeight: FontWeight.bold)),
            Text(world.subtitle, style: const TextStyle(color: AppColors.textSub, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('🔒  Bloqueado — conclua o mundo anterior',
              style: TextStyle(color: AppColors.textSub, fontSize: 11)),
          ],
        )),
      ]),
    );
  }

  Widget _unlockedContent(BuildContext context, World world) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          _iconCircle(world, 0.25),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(world.name, style: TextStyle(color: world.color, fontSize: 11, fontWeight: FontWeight.bold)),
            Text(world.subtitle,
              style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.2)),
            const SizedBox(height: 4),
            Text(world.concepts, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ])),
          GestureDetector(
            onTap: () => _openWorld(context, world),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(color: world.color, borderRadius: BorderRadius.circular(20)),
              child: Text('▶  Jogar',
                style: TextStyle(color: world.colorDark, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Builder(builder: (_) {
          final prog = GameProgress.worldProgress(world);
          final totalStars = GameProgress.worldTotalStars(world);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(child: NeonProgressBar(value: prog, color: world.color)),
                const SizedBox(width: 10),
                Text('${(prog * 100).toInt()}%',
                  style: TextStyle(color: world.color, fontSize: 11, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 8),
              StarRow(stars: totalStars ~/ (world.phases.isEmpty ? 1 : world.phases.length)),
              const SizedBox(height: 4),
              Text(
                prog > 0 ? '${(prog * 100).toInt()}% concluído' : 'Novo!',
                style: TextStyle(color: prog > 0 ? AppColors.textMuted : world.color, fontSize: 11),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _iconCircle(World world, double opacity) => Container(
    width: 66, height: 66,
    decoration: BoxDecoration(shape: BoxShape.circle, color: world.color.withOpacity(opacity)),
    alignment: Alignment.center,
    child: Text(world.icon, style: const TextStyle(fontSize: 36)),
  );
}
