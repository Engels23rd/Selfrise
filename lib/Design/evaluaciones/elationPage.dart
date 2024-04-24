import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/evaluaciones/evaluacion_screen.dart';
import 'package:flutter_proyecto_final/Design/evaluaciones/question_page.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/utils/ajustar_brillo_color.dart';
import 'package:get/get.dart';

void main() {
  runApp(MaterialApp(
    home: EvaluationPage(),
  ));
}

class EvaluationPage extends StatefulWidget {
  @override
  _EvaluationPageState createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  late PageController _pageController;
  List<bool?> userAnswers = List.filled(10, null);
  List<Widget> questionPages = [];

  @override
  void initState() {
    super.initState();
    _initializeQuestionPages();
    _pageController = PageController();
  }

  void _initializeQuestionPages() {
    for (int i = 0; i < 10; i++) {
      questionPages.add(QuestionPage(
        questionNumber: i + 1,
        onAnswerSelected: (answer) {
          setState(() {
            userAnswers[i] = answer;
          });
          if (_pageController.page == i) {
            _pageController.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }
          // Verificar si el usuario ha respondido todas las preguntas
          if (userAnswers.every((answer) => answer != null)) {
            _showRecommendationDialog(context, _closeDialogAndPage);
          }
        },
      ));
    }
  }

  void _closeDialogAndPage() {
    Navigator.pop(context); // Cerrar el diálogo
    Navigator.pop(context); // Cerrar la ventana principal
  }

  void _showRecommendationDialog(BuildContext context, VoidCallback onClose) {
    // Calcular la recomendación basada en las respuestas del usuario
    String recommendation = calculateResult();

    // Mostrar el diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.drawer,
          title: Text(
            'Recomendación',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Text(
              recommendation,
              style: TextStyle(color: Colors.white,fontSize: 16),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onClose();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ajustarBrilloColor(Colors.red), // Color de fondo rojo
                  borderRadius: BorderRadius.circular(
                      8), // Opcional: añade bordes redondeados al botón
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8), // Opcional: ajusta el relleno del botón
                child: Text(
                  'Cerrar',
                  style: TextStyle(color: Colors.white), // Texto blanco
                ),
              ),
            )
          ],
        );
      },
    );
  }

  String calculateResult() {
    int positiveCount = userAnswers.where((answer) => answer == true).length;
    if (positiveCount >= 7) {
      return '''
Tienes una alta autoestima! ¡Felicidades!
    
Consejos para mantener y mejorar tu autoestima:

- Sigue siendo consciente de tus logros y celebra tus éxitos, grandes y pequeños.

- Practica la gratitud diaria, enfocándote en las cosas positivas de tu vida.

- Mantén relaciones saludables y equilibradas con amigos y seres queridos.

- Aprende a establecer límites saludables y a decir no cuando sea necesario.

- Continúa desafiándote a ti mismo y buscando nuevas experiencias.
    ''';
    } else if (positiveCount >= 5) {
      return '''Tu autoestima está en un nivel medio. Aquí hay algunas áreas en las que puedes trabajar:

- Practica el autocuidado regularmente, dedicando tiempo a tus necesidades físicas y emocionales.

- Trabaja en identificar y desafiar pensamientos negativos sobre ti mismo.

- Establece metas alcanzables y trabaja para lograrlas, celebrando cada paso del camino.

- Busca apoyo de amigos, familiares o un terapeuta si sientes que necesitas ayuda adicional.

- Recuerda que el crecimiento personal lleva tiempo y esfuerzo; sé amable contigo mismo durante el proceso.
    ''';
    } else {
      return '''
Parece que podrías trabajar en mejorar tu autoestima. No te desanimes; aquí hay algunos consejos para empezar:

- Practica la autocompasión, siendo amable y comprensivo contigo mismo, especialmente en momentos difíciles.

- Identifica y desafía pensamientos negativos sobre ti mismo, reemplazándolos con afirmaciones positivas.

- Busca actividades que disfrutes y que te hagan sentir bien contigo mismo.

- Considera hablar con un terapeuta o un profesional de la salud mental para obtener apoyo adicional.

- Recuerda que el proceso de mejorar la autoestima es único para cada persona; sé paciente contigo mismo y date tiempo para crecer.

    ''';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: _buildAppBar(),
      ),
      body: PageView(
        controller: _pageController,
        children: questionPages,
        physics:
            NeverScrollableScrollPhysics(), // Deshabilitar el desplazamiento con los dedos
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: Color(0xFF2773B9),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Center(
        child: CustomAppBar(
          titleText: "Evaluación de autoestima",
          showBackButton: true,
        ),
      ),
    );
  }
}
