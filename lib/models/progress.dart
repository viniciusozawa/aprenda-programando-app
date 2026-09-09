import 'game_models.dart';

/// Guarda o progresso em memória durante a sessão do app.
class GameProgress {
  GameProgress._();

  static final Map<int, int> _stars = {};
  static final Set<int> _tutorialSeen = {};

  static void setStars(int phaseId, int stars) {
    if ((_stars[phaseId] ?? 0) < stars) {
      _stars[phaseId] = stars;
    }
  }

  static int getStars(int phaseId) => _stars[phaseId] ?? 0;

  /// Fase acessível = desbloqueada no modelo E todas as anteriores concluídas.
  static bool isPhaseAccessible(Phase phase, World world) {
    if (!phase.unlocked) return false;
    final index = world.phases.indexOf(phase);
    if (index == 0) return true;
    return getStars(world.phases[index - 1].id) > 0;
  }

  static bool hasSeenTutorial(int worldId) => _tutorialSeen.contains(worldId);
  static void markTutorialSeen(int worldId) => _tutorialSeen.add(worldId);

  static double worldProgress(World world) {
    if (world.phases.isEmpty) return 0;
    final done = world.phases.where((p) => getStars(p.id) > 0).length;
    return done / world.phases.length;
  }

  static int worldTotalStars(World world) =>
      world.phases.fold(0, (sum, p) => sum + getStars(p.id));

  static void reset() {
    _stars.clear();
    _tutorialSeen.clear();
  }
}
