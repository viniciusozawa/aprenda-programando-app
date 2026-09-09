import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_models.dart';

// ── COMMAND BLOCK WIDGET ─────────────────────────────────
class CommandBlockWidget extends StatelessWidget {
  final CommandBlock block;
  final bool compact;
  final bool locked;
  final VoidCallback? onTap;

  const CommandBlockWidget({
    super.key,
    required this.block,
    this.compact = false,
    this.locked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = locked ? AppColors.surface2 : block.colorDark;
    final accent = locked ? AppColors.textSub : block.color;

    return GestureDetector(
      onTap: locked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: compact ? 40 : 46,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: accent, width: 4)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (locked) const Text('🔒', style: TextStyle(fontSize: 12)),
            if (locked) const SizedBox(width: 6),
            Text(
              block.label,
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.bold,
                fontSize: compact ? 12 : 13,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── STAR ROW ─────────────────────────────────────────────
class StarRow extends StatelessWidget {
  final int stars;
  final double size;

  const StarRow({super.key, required this.stars, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) => Text(
        i < stars ? '★' : '☆',
        style: TextStyle(
          color: i < stars ? AppColors.yellow : AppColors.textSub,
          fontSize: size,
        ),
      )),
    );
  }
}

// ── NEON BUTTON (com animação de pressão) ────────────────
class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool outline;
  final double height;

  const NeonButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = AppColors.red,
    this.outline = false,
    this.height = 58,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 90));
    _scale = Tween(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.outline ? Colors.transparent : widget.color,
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: widget.outline ? Border.all(color: widget.color, width: 1.5) : null,
            boxShadow: widget.outline
                ? null
                : [BoxShadow(color: widget.color.withOpacity(0.38), blurRadius: 18, offset: const Offset(0, 4))],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.outline ? widget.color : AppColors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// ── SECTION TITLE ────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String text;
  final String? trailing;

  const SectionTitle({super.key, required this.text, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: const TextStyle(
          color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w600,
        )),
        if (trailing != null) Text(trailing!, style: const TextStyle(
          color: AppColors.textSub, fontSize: 11,
        )),
      ],
    );
  }
}

// ── SURFACE CARD ─────────────────────────────────────────
class SurfaceCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final Color? color;
  final Color? borderColor;
  final double radius;
  final EdgeInsets? padding;

  const SurfaceCard({
    super.key,
    required this.child,
    this.height,
    this.color,
    this.borderColor,
    this.radius = 12,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor != null ? Border.all(color: borderColor!, width: 1.5) : null,
      ),
      child: child,
    );
  }
}

// ── BOTTOM NAV BAR ───────────────────────────────────────
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': '🗺️', 'label': 'Mapa'},
      {'icon': '🏆', 'label': 'Troféus'},
      {'icon': '⚙️', 'label': 'Config'},
    ];

    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.surface2, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isActive ? 10 : 0,
                    height: isActive ? 3 : 0,
                    margin: EdgeInsets.only(bottom: isActive ? 4 : 0),
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  Text(items[i]['icon']!, style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 2),
                  Text(
                    items[i]['label']!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? AppColors.yellow : AppColors.textSub,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── PROGRESS BAR (animada com glow) ──────────────────────
class NeonProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final double height;

  const NeonProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.green,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: value),
      duration: const Duration(milliseconds: 950),
      curve: Curves.easeOutCubic,
      builder: (_, v, __) => ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: Stack(children: [
          Container(height: height, color: AppColors.surface2),
          FractionallySizedBox(
            widthFactor: v.clamp(0.0, 1.0),
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: color,
                boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 6)],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
