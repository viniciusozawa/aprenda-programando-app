import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Phase {
  final int id;
  final String title;
  final String concept;
  final bool unlocked;
  final int stars; // 0–3
  final List<String> availableBlocks;
  final List<List<int>> grid; // caminho da fase

  const Phase({
    required this.id,
    required this.title,
    required this.concept,
    required this.unlocked,
    required this.stars,
    required this.availableBlocks,
    required this.grid,
  });
}

class World {
  final int id;
  final String name;
  final String subtitle;
  final String concepts;
  final String icon;
  final Color color;
  final Color colorDark;
  final bool locked;
  final List<Phase> phases;

  const World({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.concepts,
    required this.icon,
    required this.color,
    required this.colorDark,
    required this.locked,
    required this.phases,
  });

  int get totalStars => phases.fold(0, (sum, p) => sum + p.stars);
  int get maxStars => phases.length * 3;
  double get progress => phases.isEmpty ? 0 : phases.where((p) => p.stars > 0).length / phases.length;
}

class CommandBlock {
  final String label;
  final Color color;
  final Color colorDark;
  final String type; // 'andar', 'virar', 'repetir', 'se', 'senao', 'funcao'
  final int? value;

  const CommandBlock({
    required this.label,
    required this.color,
    required this.colorDark,
    required this.type,
    this.value,
  });
}

// ── DADOS DO JOGO ─────────────────────────────────────────
final List<World> worlds = [
  World(
    id: 1,
    name: 'Mundo 1',
    subtitle: 'Floresta Mágica',
    concepts: 'Sequência · Loops',
    icon: '🌲',
    color: AppColors.green,
    colorDark: AppColors.greenDark,
    locked: false,
    phases: [
      const Phase(
        id: 1, title: 'Andar em Frente', concept: 'Sequência',
        unlocked: true, stars: 0,
        availableBlocks: ['andar', 'virar'],
        grid: [[0,0],[1,0],[2,0],[3,0]],
      ),
      const Phase(
        id: 2, title: 'Virar à Direita', concept: 'Sequência',
        unlocked: true, stars: 0,
        availableBlocks: ['andar', 'virar'],
        grid: [[0,0],[1,0],[1,1],[1,2]],
      ),
      const Phase(
        id: 3, title: 'Usando Repetir', concept: 'Loops',
        unlocked: true, stars: 0,
        availableBlocks: ['andar', 'virar', 'repetir'],
        grid: [[0,4],[1,4],[2,4],[3,4],[3,3],[3,2],[3,1],[3,0],[4,0],[5,0],[6,0]],
      ),
      const Phase(
        id: 4, title: 'Loops Aninhados', concept: 'Loops',
        unlocked: false, stars: 0,
        availableBlocks: ['andar', 'virar', 'repetir'],
        grid: [],
      ),
      const Phase(
        id: 5, title: 'Se / Senão', concept: 'Condicionais',
        unlocked: false, stars: 0,
        availableBlocks: ['andar', 'virar', 'repetir', 'se'],
        grid: [],
      ),
      const Phase(
        id: 6, title: 'Funções', concept: 'Funções',
        unlocked: false, stars: 0,
        availableBlocks: ['andar', 'virar', 'repetir', 'se', 'funcao'],
        grid: [],
      ),
    ],
  ),
  World(
    id: 2,
    name: 'Mundo 2',
    subtitle: 'Cidade Futurista',
    concepts: 'Condicionais · Funções',
    icon: '🏙️',
    color: AppColors.indigo,
    colorDark: AppColors.indigoDark,
    locked: false,
    phases: [],
  ),
  World(
    id: 3,
    name: 'Mundo 3',
    subtitle: 'Espaço Profundo',
    concepts: 'Variáveis · Recursão',
    icon: '🚀',
    color: AppColors.orange,
    colorDark: AppColors.orangeDark,
    locked: true,
    phases: [],
  ),
  World(
    id: 4,
    name: 'Mundo 4',
    subtitle: 'Dimensão Digital',
    concepts: 'Algoritmos Avançados',
    icon: '💾',
    color: AppColors.purple,
    colorDark: AppColors.purpleDark,
    locked: true,
    phases: [],
  ),
];

final List<CommandBlock> allBlocks = [
  const CommandBlock(label: 'andar', color: AppColors.orange, colorDark: AppColors.orangeDark, type: 'andar', value: 1),
  const CommandBlock(label: 'virar', color: AppColors.indigo, colorDark: AppColors.indigoDark, type: 'virar'),
  const CommandBlock(label: 'repetir', color: AppColors.purple, colorDark: AppColors.purpleDark, type: 'repetir', value: 3),
  const CommandBlock(label: 'se', color: AppColors.green, colorDark: AppColors.greenDark, type: 'se'),
  const CommandBlock(label: 'senão', color: AppColors.green, colorDark: AppColors.greenDark, type: 'senao'),
  const CommandBlock(label: 'função', color: AppColors.red, colorDark: AppColors.redDark, type: 'funcao'),
];
