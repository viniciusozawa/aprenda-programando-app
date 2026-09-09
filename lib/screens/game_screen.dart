import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_models.dart';
import '../models/progress.dart';
import '../widgets/app_widgets.dart';
import 'victory_screen.dart';

class GameScreen extends StatefulWidget {
  final Phase phase;
  final World world;
  const GameScreen({super.key, required this.phase, required this.world});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  List<CommandBlock> placedBlocks = [];
  late int robotX;
  late int robotY;
  bool isRunning = false;
  bool hasError = false;

  final int cols = 7, rows = 5;

  late final AnimationController _robotCtrl;
  late final AnimationController _btnPulseCtrl;
  late final Animation<double> _robotScale;
  late final Animation<double> _btnGlow;

  List<CommandBlock> get availableBlocks => allBlocks
      .where((b) => widget.phase.availableBlocks.contains(b.type))
      .toList();

  @override
  void initState() {
    super.initState();

    final grid = widget.phase.grid;
    robotX = grid.isNotEmpty ? grid[0][0] : 0;
    robotY = grid.isNotEmpty ? grid[0][1] : 0;

    _robotCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400))
      ..repeat(reverse: true);
    _robotScale = Tween(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _robotCtrl, curve: Curves.easeInOut));

    _btnPulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _btnGlow = Tween(begin: 0.25, end: 0.55).animate(
        CurvedAnimation(parent: _btnPulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _robotCtrl.dispose();
    _btnPulseCtrl.dispose();
    super.dispose();
  }

  void _addBlock(CommandBlock block) {
    if (placedBlocks.length >= 5) return;
    setState(() => placedBlocks.add(block));
  }

  void _removeBlock(int index) {
    setState(() => placedBlocks.removeAt(index));
  }

  void _execute() async {
    final path = widget.phase.grid;

    if (placedBlocks.isEmpty) {
      setState(() => hasError = true);
      return;
    }

    setState(() { isRunning = true; hasError = false; });
    await Future.delayed(const Duration(milliseconds: 300));

    // Simula o movimento do robô com base nos blocos colocados
    // Direções: 0=direita, 1=baixo, 2=esquerda, 3=cima
    int x = path.isNotEmpty ? path[0][0] : 0;
    int y = path.isNotEmpty ? path[0][1] : 0;
    int dir = 0;
    const dx = [1, 0, -1, 0];
    const dy = [0, 1, 0, -1];

    final List<List<int>> robotPath = [[x, y]];

    for (final block in placedBlocks) {
      switch (block.type) {
        case 'andar':
          final steps = block.value ?? 1;
          for (int s = 0; s < steps; s++) {
            x += dx[dir];
            y += dy[dir];
            robotPath.add([x, y]);
          }
          break;
        case 'virar':
          dir = (dir + 1) % 4;
          break;
        case 'repetir':
          final n = block.value ?? 3;
          for (int r = 0; r < n; r++) {
            x += dx[dir];
            y += dy[dir];
            robotPath.add([x, y]);
          }
          break;
      }
    }

    // Anima o robô pelo caminho calculado
    for (final pos in robotPath) {
      await Future.delayed(const Duration(milliseconds: 280));
      if (!mounted) return;
      setState(() { robotX = pos[0]; robotY = pos[1]; });
    }

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() => isRunning = false);

    // Verifica se chegou ao destino
    final goal = path.isNotEmpty ? path.last : null;
    if (goal != null && x == goal[0] && y == goal[1]) {
      final stars = _calcStars(placedBlocks.length, path.length - 1);
      _showVictory(stars);
    } else {
      setState(() {
        hasError = true;
        // Reseta posição do robô ao início
        robotX = path.isNotEmpty ? path[0][0] : 0;
        robotY = path.isNotEmpty ? path[0][1] : 0;
      });
    }
  }

  // Menos blocos usados = mais estrelas
  int _calcStars(int blocksUsed, int pathLen) {
    if (blocksUsed <= (pathLen / 3).ceil()) return 3;
    if (blocksUsed <= (pathLen / 2).ceil()) return 2;
    return 1;
  }

  void _showVictory(int stars) {
    GameProgress.setStars(widget.phase.id, stars);
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (_, a, __) => VictoryScreen(phase: widget.phase, world: widget.world, stars: stars),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 400),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(width: 4, height: 44, color: AppColors.red),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fase ${widget.phase.id} · ${widget.phase.title}',
                            style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          Text('Aprendendo: ${widget.phase.concept}',
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                        ],
                      ),
                    ),
                    StarRow(stars: GameProgress.getStars(widget.phase.id)),
                  ]),
                ],
              ),
            ),

            // Grid
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.surface2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      childAspectRatio: 1,
                    ),
                    itemCount: cols * rows,
                    itemBuilder: (ctx, i) {
                      final x = i % cols, y = i ~/ cols;
                      final isPath = widget.phase.grid.any((g) => g[0] == x && g[1] == y);
                      final isRobot = x == robotX && y == robotY;
                      final isGoal = widget.phase.grid.isNotEmpty &&
                          x == widget.phase.grid.last[0] && y == widget.phase.grid.last[1];

                      // Cor de fundo: meta tem destaque verde, caminho tem indigo, resto transparente
                      Color cellColor;
                      if (isGoal) cellColor = AppColors.green.withOpacity(0.18);
                      else if (isRobot && isRunning) cellColor = AppColors.indigoDark.withOpacity(0.8);
                      else if (isPath) cellColor = AppColors.indigoDark;
                      else cellColor = Colors.transparent;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.all(1.5),
                        decoration: BoxDecoration(
                          color: cellColor,
                          borderRadius: BorderRadius.circular(5),
                          border: isGoal
                              ? Border.all(color: AppColors.green.withOpacity(0.7), width: 1.5)
                              : Border.all(color: AppColors.surface2.withOpacity(0.4), width: 0.5),
                          boxShadow: isGoal
                              ? [BoxShadow(color: AppColors.green.withOpacity(0.3), blurRadius: 6)]
                              : isRobot && isRunning
                                  ? [BoxShadow(color: AppColors.indigo.withOpacity(0.4), blurRadius: 8)]
                                  : null,
                        ),
                        alignment: Alignment.center,
                        child: isRobot && isGoal
                            // Robô chegou à bandeira: mostra os dois
                            ? const Text('🤖', style: TextStyle(fontSize: 18))
                            : isRobot
                                ? AnimatedBuilder(
                                    animation: _robotScale,
                                    builder: (_, __) => Transform.scale(
                                      scale: isRunning ? _robotScale.value : 1.0,
                                      child: const Text('🤖', style: TextStyle(fontSize: 20)),
                                    ),
                                  )
                                : isGoal
                                    ? const Text('🚩', style: TextStyle(fontSize: 26))
                                    : null,
                      );
                    },
                  ),
                ),
              ),
            ),

            // Objetivo / erro
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: hasError
                  ? Container(
                      key: const ValueKey('error'),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.redDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.red),
                      ),
                      child: const Row(children: [
                        Text('❌', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Expanded(child: Text('Oops! O robô se perdeu. Tente de novo!',
                          style: TextStyle(color: AppColors.red, fontSize: 12, fontWeight: FontWeight.bold))),
                      ]),
                    )
                  : Container(
                      key: const ValueKey('goal'),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(children: [
                        Text('🎯', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 8),
                        Expanded(child: Text('Leve o robô até a bandeira com menos blocos possível!',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 11))),
                      ]),
                    ),
            ),

            const SizedBox(height: 10),

            // Comandos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(children: [
                SectionTitle(text: 'Seus Comandos', trailing: '${placedBlocks.length} / 5 blocos'),
                const SizedBox(height: 8),
                Container(
                  height: 110,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    ...placedBlocks.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutBack,
                        builder: (_, v, child) => Transform.scale(scale: v, child: child),
                        child: GestureDetector(
                          onTap: () => _removeBlock(e.key),
                          child: CommandBlockWidget(block: e.value, compact: true),
                        ),
                      ),
                    )),
                    if (placedBlocks.length < 5)
                      Container(
                        width: 80, height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface2,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.surface2),
                        ),
                        alignment: Alignment.center,
                        child: const Text('+',
                          style: TextStyle(color: AppColors.textSub, fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                  ]),
                ),

                const SizedBox(height: 12),
                const SectionTitle(text: 'Blocos Disponíveis'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: availableBlocks.map((b) => GestureDetector(
                    onTap: () => _addBlock(b),
                    child: CommandBlockWidget(block: b),
                  )).toList(),
                ),
              ]),
            ),

            const SizedBox(height: 12),

            // Botão executar com glow pulsante
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: isRunning
                  ? Container(
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.surface2,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Executando...',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 17, fontWeight: FontWeight.bold)),
                    )
                  : AnimatedBuilder(
                      animation: _btnGlow,
                      builder: (_, __) => GestureDetector(
                        onTap: _execute,
                        child: Container(
                          height: 58,
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(29),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.red.withOpacity(_btnGlow.value),
                                blurRadius: 22,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text('▶  Executar',
                            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
