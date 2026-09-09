import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/progress.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  bool _sound = true;
  bool _music = true;

  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _fade = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: -40, left: -40, child: _orb(180, AppColors.indigo, 0.07)),
          Positioned(bottom: 100, right: -40, child: _orb(150, AppColors.purple, 0.06)),
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
                    const Text('Configurações',
                      style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                  ]),
                ),

                Expanded(
                  child: FadeTransition(
                    opacity: _fade,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('🔊 Áudio'),
                          const SizedBox(height: 10),
                          _toggle('Efeitos Sonoros', _sound, (v) => setState(() => _sound = v)),
                          const SizedBox(height: 8),
                          _toggle('Música de Fundo', _music, (v) => setState(() => _music = v)),

                          const SizedBox(height: 28),
                          _sectionTitle('🎮 Jogo'),
                          const SizedBox(height: 10),

                          // Reset progress
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.redDark, width: 1.5),
                            ),
                            child: ListTile(
                              leading: const Text('🗑️', style: TextStyle(fontSize: 22)),
                              title: const Text('Resetar Progresso',
                                style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: 14)),
                              subtitle: const Text('Apaga todas as estrelas e desbloqueia tudo',
                                style: TextStyle(color: AppColors.textSub, fontSize: 11)),
                              onTap: () => _confirmReset(context),
                            ),
                          ),

                          const SizedBox(height: 28),
                          _sectionTitle('ℹ️ Sobre'),
                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(children: [
                              _infoRow('App', 'CodePlay BR'),
                              _infoRow('Versão', '1.0.0'),
                              _infoRow('Plataforma', 'Flutter'),
                              _infoRow('Instituição', 'IFSULDEMINAS · Machado'),
                            ]),
                          ),
                        ],
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

  Widget _sectionTitle(String text) => Text(text,
    style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5));

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text(label, style: const TextStyle(color: AppColors.white, fontSize: 14)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.green,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _infoRow(String key, String val) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(key, style: const TextStyle(color: AppColors.textSub, fontSize: 13)),
      Text(val, style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w600)),
    ]),
  );

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Resetar Progresso?',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
        content: const Text('Todas as estrelas e o progresso serão apagados. Esta ação não pode ser desfeita.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.textSub)),
          ),
          TextButton(
            onPressed: () {
              GameProgress.reset();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Progresso resetado!'),
                  backgroundColor: AppColors.red,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Resetar', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _orb(double size, Color color, double opacity) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(opacity)),
  );
}
