import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/Habito.dart';

class EvaluarProgresoScreen extends StatefulWidget {
  final PageController pageController;
  final String? categoriaSeleccionada;
  final IconData? iconoSeleccionado;

  EvaluarProgresoScreen(
      {required this.pageController,
      this.categoriaSeleccionada,
      this.iconoSeleccionado});

  @override
  _EvaluarProgresoScreenState createState() => _EvaluarProgresoScreenState();
}

class _EvaluarProgresoScreenState extends State<EvaluarProgresoScreen> {
  void animateToPage() {
    widget.pageController.animateToPage(
      2,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              SizedBox(height: 20.0),
              Text(
                '¿Cómo quieres evaluar tu progreso?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Habito.evaluateProgress = "si o no";
                  animateToPage();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF2773B9)),
                ),
                child: Text(
                  'Con si o no',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Si solo desea registrar si tuvo éxito con la actividad o no',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Habito.evaluateProgress = "valor numerico";
                  animateToPage();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF2773B9)),
                ),
                child: Text('Con valor numérico',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              SizedBox(height: 10.0),
              Text(
                'Si solo quieres establecer un valor como meta diaria o límite para el hábito',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
