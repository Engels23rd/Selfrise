import 'package:flutter/services.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';

class ColorSystemNavitagionBar {
  static void setSystemUIOverlayStyleLight() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF2773B9),
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color.fromARGB(255, 0, 0, 0),
    ));
  }

  static void setSystemUIOverlayStyleDark() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.drawer,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color.fromARGB(255, 1, 0, 0),
    ));
  }
}
