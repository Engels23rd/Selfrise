import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/AuthService.dart';
import 'package:flutter_proyecto_final/entity/Frecuencia.dart';
import 'package:flutter_proyecto_final/entity/Habito.dart';
import 'package:flutter_proyecto_final/services/habitos_services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FrecuenciaScreen extends StatefulWidget {
  final bool editar;
  final Map<String, dynamic> habito;
  final Function()? actualizarHabito;
  final Function()? obtenerHabitos;
  final void Function(bool)? validarDiasSemana;
  final Function()? validarDiasMes;
  final Function()? validarRepetir;
  int currentIndex = 0;
  final Function(int)? onUpdateIndex;


  // Asignar un valor predeterminado null a actualizarHabito
  FrecuenciaScreen({
    this.editar = false,
    this.habito = const {},
    this.actualizarHabito,
    this.obtenerHabitos,
    this.validarDiasSemana,
    this.validarDiasMes,
    this.validarRepetir,
    required this.currentIndex,
    this.onUpdateIndex,
  });

  @override
  _FrecuenciaScreenState createState() => _FrecuenciaScreenState();
}

class _FrecuenciaScreenState extends State<FrecuenciaScreen> {
  Map<String, bool> _diasSeleccionados = {
    'Lunes': false,
    'Martes': false,
    'Miércoles': false,
    'Jueves': false,
    'Viernes': false,
    'Sábado': false,
    'Domingo': false,
  };
  int _currentIndex = 0;

  late List<Map<String, dynamic>> habitosUsuario = [];
  Map<int, bool> _isSelected = {};

  Color selectedColor = Color(0xFF2773B9);

  Future<void> cargarHabitos() async {
    final String? idUsuarioActual = AuthService.getUserId();
    List<Map<String, dynamic>> habitosCargados =
        await HabitosService().obtenerHabitos(idUsuarioActual!);

    setState(() {
      habitosUsuario = habitosCargados;
    });
  }

  @override
  void initState() {
    super.initState();
    Habito.frequency = Frecuencia.CADA_DIA;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 40.0), // Ajusta el valor de top según sea necesario
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '¿Con qué frecuencia planeas realizar el hábito?',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                _buildPage(),
              ],
            ),
          ),
          if (widget.editar) _buildBotonesConfirmarCancelar(),
        ],
      ),
    );
  }

  Widget _buildPage() {
    return Padding(
      padding:
          EdgeInsets.all(widget.editar ? 10 : 0), // Define el padding deseado
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 1.1, // Factor de escala ajustable según tus necesidades
            child: RadioListTile(
              title: Text(
                'Cada día',
                style: TextStyle(
                  fontSize:
                      18.0, // Ajusta el tamaño de fuente según tus necesidades
                ),
              ),
              value: 0,
              groupValue: _currentIndex,
              onChanged: (value) {
                setState(() {
                  _currentIndex = value as int;
                  Habito.frequency = Frecuencia.CADA_DIA;
                });
              },
              activeColor: selectedColor,
            ),
          ),
          Transform.scale(
            scale: 1.1, // Factor de escala ajustable según tus necesidades
            child: RadioListTile(
              title: Text(
                'Días específicos de la semana',
                style: TextStyle(
                  fontSize:
                      18.0, // Ajusta el tamaño de fuente según tus necesidades
                ),
              ),
              value: 1,
              groupValue: _currentIndex,
              onChanged: (value) {
                setState(() {
                  _currentIndex = value as int;
                  Habito.frequency = Frecuencia.DIAS_ESPECIFICOS;
                });
              },
              activeColor: selectedColor,
            ),
          ),
          if (_currentIndex == 1) _buildDiasSemanaCheckboxes(),
          Transform.scale(
            scale: 1.1, // Factor de escala ajustable según tus necesidades
            child: RadioListTile(
              title: Text(
                'Días específicos del mes',
                style: TextStyle(
                  fontSize:
                      18.0, // Ajusta el tamaño de fuente según tus necesidades
                ),
              ),
              value: 2,
              groupValue: _currentIndex,
              onChanged: (value) {
                setState(() {
                  _currentIndex = value as int;
                  Habito.frequency = Frecuencia.DIAS_MES;
                });
              },
              activeColor: selectedColor,
            ),
          ),
          if (_currentIndex == 2) _buildDiasMesCheckboxes(),
          Transform.scale(
            scale: 1.1, // Factor de escala ajustable según tus necesidades
            child: RadioListTile(
              title: Text(
                'Repetir',
                style: TextStyle(
                  fontSize:
                      18.0, // Ajusta el tamaño de fuente según tus necesidades
                ),
              ),
              value: 3,
              groupValue: _currentIndex,
              onChanged: (value) {
                setState(() {
                  _currentIndex = value as int;
                  Habito.frequency = Frecuencia.REPETIR;
                });
              },
              activeColor: selectedColor,
            ),
          ),
          if (_currentIndex == 3) _buildRepetirTextBox(),
        ],
      ),
    );
  }

  Widget _buildDiasSemanaCheckboxes() {
    List<Widget> checkboxes = _diasSeleccionados.keys.map((dia) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _diasSeleccionados[dia] = !_diasSeleccionados[dia]!;
            Frecuencia.actualizarDiasSemana(_diasSeleccionados.keys
                .where((dia) => _diasSeleccionados[dia]!)
                .toSet());
            print(dia);
          });
        },
        child: Container(
          child: Row(
            children: [
              Checkbox(
                value: _diasSeleccionados[dia],
                onChanged: (value) {
                  setState(() {
                    Frecuencia.actualizarDiasSemana(_diasSeleccionados.keys
                        .where((dia) => _diasSeleccionados[dia]!)
                        .toSet());
                    _diasSeleccionados[dia] = value!;
                  });
                  print(dia);
                },
                checkColor:
                    Colors.white, // Color del tick cuando está seleccionado
                fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    // Cambia el color de fondo del checkbox cuando está seleccionado
                    if (states.contains(MaterialState.selected)) {
                      return Color(
                          0xFF2773B9); // Color cuando está seleccionado
                    }
                    return Colors.transparent; // Color por defecto
                  },
                ),
              ),
              Text(
                dia,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5, // Ajusta este valor según el alto que desees
      children: checkboxes,
    );
  }

Widget _buildDiasMesCheckboxes() {
  final int totalDaysToShow = 31;
  final DateTime now = DateTime.now();
  final int currentDay = now.day;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.0,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: totalDaysToShow,
          itemBuilder: (context, index) {
            final int day = index + 1;

            _isSelected.putIfAbsent(day, () => false);

            return GestureDetector(
              onTap: () {
                setState(() {
                  _isSelected.update(day, (isSelected) => !isSelected);
                  Habito.frequency = Frecuencia.DIAS_MES;
                  Frecuencia.actualizarDiasMes(_isSelected.keys
                      .toList()
                      .where((day) => _isSelected[day]!)
                      .toList()
                      .cast<int>()
                      .toSet());
                  print(Frecuencia.diasMes);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isSelected[day]! ? Color(0xFF2773B9) : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 15,
                      color: _isSelected[day]! ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}



  Widget _buildBotonesConfirmarCancelar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Color(0xFF2773B9), // Color azul original del container
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 30), // Ajusta el espacio interno según sea necesario
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // Acción al presionar el botón Cancelar
                  Navigator.of(context).pop(); // Cerrar la pantalla actual
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                      color: Colors.white, // Color del texto blanco
                      fontWeight: FontWeight.bold,
                      fontSize: 20 // Negrita
                      ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  dynamic frecuenciaValor;

                  switch (Habito.frequency.nombre) {
                    case 'Cada día':
                      frecuenciaValor = Frecuencia.cadaDia;
                      break;
                    case 'Días específicos de la semana':
                      frecuenciaValor = Frecuencia.diasSemana;
                      break;
                    case 'Días específicos del mes':
                      frecuenciaValor = Frecuencia.diasMes;
                      break;
                    case 'Repetir':
                      frecuenciaValor = Frecuencia.diasDespues;
                      break;
                    default:
                      throw ArgumentError(
                          'Frecuencia no válida: ${Habito.frequency.nombre}');
                  }

                  String idHabito = widget.habito['id'];

                  HabitosService().actualizarFrecuenciaHabito(
                      idHabito, Habito.frequency, frecuenciaValor);

                  widget.habito['frecuenciaHabito'] = Habito.frequency.nombre;

                  if (widget.actualizarHabito != null) {
                    // La función actualizarHabito no es null, así que podemos llamarla
                    await widget.actualizarHabito!();
                    print('Función actualizarHabito ejecutada exitosamente');
                  } else {
                    // La función actualizarHabito es null
                    print('La función actualizarHabito es nula');
                  }

                  widget.obtenerHabitos!();
                  cargarHabitos();

                  Fluttertoast.showToast(
                    msg: "Frecuencia actualizada correctamente",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  );

                  widget.actualizarHabito!();

                  Navigator.pop(context);
                },
                child: Text(
                  'Confirmar',
                  style: TextStyle(
                      color: Colors.white, // Color del texto blanco
                      fontWeight: FontWeight.bold,
                      fontSize: 20 // Negrita
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRepetirTextBox() {
    TextEditingController _controller = TextEditingController();

    _controller.addListener(() {
      Frecuencia.actualizarDiasDespues(_controller.text);
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Repetir cada',
            style: TextStyle(
                fontSize:
                    18), // Tamaño de fuente ajustable según tus necesidades
          ),
          SizedBox(width: 5), // Espacio entre el texto y el TextField
          SizedBox(
            width: 100, //  Ancho ajustable según tus necesidades
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(
                          0xFF2773B9)), // Color del borde cuando el TextField está activo
                ),
              ),
            ),
          ),
          SizedBox(width: 5), // Espacio entre el TextField y el texto
          Text('día(s)', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
