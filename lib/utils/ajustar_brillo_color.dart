  import 'dart:ui';

Color ajustarBrilloColor(Color color) {
    int rojo = (color.red * 0.8).round();
    int verde = (color.green * 0.8).round();
    int azul = (color.blue * 0.8).round();
    return Color.fromRGBO(rojo, verde, azul, 1);
  }