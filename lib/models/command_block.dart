import 'package:flutter/material.dart';
import '../theme/colors.dart';

enum CommandType { andar, virar, repetir, se, senao, funcao }

class CommandBlock {
  final CommandType type;
  final dynamic value;

  const CommandBlock({required this.type, this.value});

  String get label {
    switch (type) {
      case CommandType.andar:   return 'andar(${value ?? 1})';
      case CommandType.virar:   return 'virar(${value ?? 'direita'})';
      case CommandType.repetir: return 'repetir(${value ?? 2})';
      case CommandType.se:      return 'se(condição)';
      case CommandType.senao:   return 'senão';
      case CommandType.funcao:  return 'função()';
    }
  }

  Color get color {
    switch (type) {
      case CommandType.andar:   return AppColors.orange;
      case CommandType.virar:   return AppColors.indigo;
      case CommandType.repetir: return AppColors.green;
      case CommandType.se:      return AppColors.purple;
      case CommandType.senao:   return AppColors.purple;
      case CommandType.funcao:  return AppColors.red;
    }
  }

  Color get bgColor {
    switch (type) {
      case CommandType.andar:   return AppColors.orangeDark;
      case CommandType.virar:   return AppColors.indigoDark;
      case CommandType.repetir: return AppColors.greenDark;
      case CommandType.se:      return AppColors.purpleDark;
      case CommandType.senao:   return AppColors.purpleDark;
      case CommandType.funcao:  return AppColors.redDark;
    }
  }
}
