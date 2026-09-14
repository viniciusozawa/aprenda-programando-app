import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/statusbar/statusbar_menu_screen.dart';

/// Ponto de entrada que abre direto os exemplos de StatusBar.
///
///   flutter run -t lib/main_statusbar.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(estiloStatusBarPadrao);
  runApp(const StatusBarExemplosApp());
}

class StatusBarExemplosApp extends StatelessWidget {
  const StatusBarExemplosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StatusBar · CodePlay BR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const StatusBarMenuScreen(),
    );
  }
}
