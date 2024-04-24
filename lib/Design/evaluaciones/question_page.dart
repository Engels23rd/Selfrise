import 'package:flutter/material.dart';

class QuestionPage extends StatelessWidget {
  final int questionNumber;
  final ValueChanged<bool?> onAnswerSelected;
  final VoidCallback? onClose;

  // Lista de preguntas
  static const List<String> questions = [
    "¿Te sientes capaz de enfrentar desafíos y resolver problemas de manera efectiva?",
    "¿Sientes que mereces amor y respeto de los demás?",
    "¿Confías en tus habilidades y talentos?",
    "¿Te comparas constantemente con los demás y te sientes inferior?",
    "¿Puedes aceptar tus errores y aprender de ellos sin sentirte demasiado afectado?",
    "¿Te sientes satisfecho contigo mismo/a en general?",
    "¿Sientes que tienes el control sobre tu vida y tus decisiones?",
    "¿Te sientes cómodo/a expresando tus opiniones y emociones?",
    "¿Te preocupas demasiado por la aprobación de los demás?",
    "¿Tienes una imagen positiva de ti mismo/a y de tu futuro?"
  ];

  // Lista de rutas de imágenes correspondientes a cada pregunta
  static const List<String> questionImages = [
    'assets/imagenes/pregunta1.jpg',
    'assets/imagenes/pregunta2.jpg',
    'assets/imagenes/pregunta3.jpg',
    'assets/imagenes/pregunta4.jpg',
    'assets/imagenes/pregunta5.jpg',
    'assets/imagenes/pregunta6.jpg',
    'assets/imagenes/pregunta7.jpg',
    'assets/imagenes/pregunta8.jpg',
    'assets/imagenes/pregunta9.jpg',
    'assets/imagenes/pregunta10.jpg',
  ];

  const QuestionPage(
      {required this.questionNumber,
      required this.onAnswerSelected,
      this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200, // Ancho fijo de la imagen
              height: 200, // Alto fijo de la imagen
              child: Image.asset(
                questionImages[questionNumber -
                    1], // Obtener la ruta de la imagen según la pregunta actual
                fit:
                    BoxFit.cover, // Ajustar la imagen para cubrir el contenedor
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 400, // Ancho fijo del contenedor de la pregunta
              child: Text(
                questions[questionNumber - 1], // Mostrar la pregunta actual
                textAlign: TextAlign.center, // Centrar el texto
                style: TextStyle(fontSize: 18), // Tamaño de la fuente
              ),
            ),
            SizedBox(height: 20),
            _buildAnswerButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            onAnswerSelected(true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Color(0xFF2773B9), // Color de fondo para la respuesta "Sí"
          ),
          child: Text('Sí', style: TextStyle(color: Colors.white)),
        ),
        SizedBox(width: 10), // Espacio entre los botones
        ElevatedButton(
          onPressed: () {
            onAnswerSelected(false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Color(0xFF2773B9), // Color de fondo para la respuesta "No"
          ),
          child: Text('No', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
