import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../models/command_block.dart';

// ── Botão primário (vermelho) ────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.red,
          foregroundColor: textColor ?? AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      ),
    );
  }
}

// ── Botão secundário (contorno) ──────────────────────────
class OutlineButton2 extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color borderColor;
  final Color textColor;

  const OutlineButton2({
    super.key,
    required this.label,
    required this.onTap,
    this.borderColor = AppColors.indigo,
    this.textColor = AppColors.indigo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
        ),
      ),
    );
  }
}

// ── Bloco de comando (drag & drop) ───────────────────────
class CommandBlockWidget extends StatelessWidget {
  final CommandBlock block;
  final VoidCallback? onRemove;

  const CommandBlockWidget({super.key, required this.block, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: block.bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 4, decoration: BoxDecoration(
            color: block.color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          )),
          const SizedBox(width: 10),
          Text(block.label, style: TextStyle(
            color: block.color, fontSize: 13, fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
          )),
          if (onRemove != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              child: Icon(Icons.close, size: 14, color: block.color.withOpacity(0.7)),
            ),
            const SizedBox(width: 8),
          ] else const SizedBox(width: 12),
        ],
      ),
    );
  }
}

// ── Card de surface ──────────────────────────────────────
class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final Color? borderColor;
  final double radius;

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderColor,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.5)
            : null,
      ),
      child: child,
    );
  }
}

// ── Header da tela ───────────────────────────────────────
class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color accentColor;
  final Widget? trailing;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.accentColor = AppColors.red,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: accentColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: const Text('←', style: TextStyle(fontSize: 22, color: AppColors.white, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.white)),
                          if (subtitle != null)
                            Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    if (trailing != null) trailing!,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Nav Bar ───────────────────────────────────────
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.map_outlined,     'label': 'Mapa'},
      {'icon': Icons.emoji_events_outlined, 'label': 'Troféus'},
      {'icon': Icons.settings_outlined,'label': 'Config'},
    ];

    return Container(
      height: 62,
      color: AppColors.surface,
      child: Row(
        children: List.generate(items.length, (i) {
          final isActive = i == currentIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isActive)
                    Container(width: 24, height: 3,
                      decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(99)),
                    ),
                  const SizedBox(height: 4),
                  Icon(items[i]['icon'] as IconData,
                    color: isActive ? AppColors.yellow : AppColors.textSub, size: 22),
                  const SizedBox(height: 2),
                  Text(items[i]['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                      color: isActive ? AppColors.yellow : AppColors.textSub,
                    )),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Star rating ──────────────────────────────────────────
class StarRating extends StatelessWidget {
  final int stars;
  final int maxStars;
  final double size;

  const StarRating({super.key, required this.stars, this.maxStars = 3, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (i) => Icon(
        i < stars ? Icons.star : Icons.star_border,
        color: AppColors.yellow,
        size: size,
      )),
    );
  }
}
