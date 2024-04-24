import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/components/mySlides.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SlideLogin extends StatefulWidget {
  const SlideLogin({Key? key}) : super(key: key);

  @override
  State<SlideLogin> createState() => _SlideLoginState();
}

class _SlideLoginState extends State<SlideLogin> {
  int currentPage = 0;
  PageController controller =
      PageController(); // Asegúrate de tener esta línea si aún no la tienes.

  void markSlideSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (int page) {
              setState(() {
                currentPage = page;
              });
              if (page == 2) {
                // Suponiendo que el índice 2 es tu último slide
                markSlideSeen(); // Marca el SlideLogin como visto cuando el usuario llega al último slide
              }
            },
            children: [
              buildSlide(
                context,
                'assets/imagenes/slide 1.png',
                '¡Hola! Bienvenido a SelfRaise...',
                withButtons: false,
              ),
              buildSlide(
                context,
                'assets/imagenes/slide 2.png',
                'Descubre la tranquilidad y la paz mental...',
                withButtons: false,
              ),
              buildSlide(
                context,
                'assets/imagenes/slide 3.png',
                'Aprende técnicas de respiración...',
                withButtons: true, // Suponiendo que este es tu último slide
              ),
            ],
          ),
          // Otros elementos como indicadores de página, botones, etc.
        ],
      ),
    );
  }
}
