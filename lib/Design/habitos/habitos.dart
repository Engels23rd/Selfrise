import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/habitos/habitos_stepper.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/const/frases_felicitacion.dart';
import 'package:flutter_proyecto_final/dialogs/ingresar_meta_dialog.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/services/habitos_services.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_proyecto_final/services/notificacion_services.dart';
import 'package:flutter_proyecto_final/utils/ajustar_brillo_color.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import 'package:timezone/timezone.dart' as tz;

class PantallaSeguimientoHabitos extends StatefulWidget {
  @override
  _PantallaSeguimientoHabitosState createState() =>
      _PantallaSeguimientoHabitosState();
}

class _PantallaSeguimientoHabitosState
    extends State<PantallaSeguimientoHabitos> {
  late StreamController<List<Map<String, dynamic>>> _streamControllerHabitos;
  late DateTime _fechaSeleccionadCalendario = DateTime.now();
  bool elHabitoEstaCompletado = false;
  DateTime fechaActual = DateTime.now();
  late bool esFechaPosterior;
  bool estaCorriendo = false;
  final controller = ConfettiController();

  final String? idUsuarioActual = AuthService.getUserId();

  // ignore: unused_field

  @override
  void initState() {
    super.initState();

    _streamControllerHabitos =
        StreamController<List<Map<String, dynamic>>>.broadcast();
    _cargarHabitos();
    esFechaPosterior = fechaActual.isBefore(_fechaSeleccionadCalendario);

    controller.addListener(() {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          estaCorriendo = controller.state == ConfettiControllerState.playing;
        });
      });
    });
  }

  void mostrarDialogoFelicitacion(String mensajeFelicitacion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.drawer,
          title: Text('¡Felicitaciones!',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                child: ConfettiWidget(
                  confettiController: controller,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  maxBlastForce: 9,
                  minBlastForce: 2,
                  emissionFrequency: 0.03,
                  numberOfParticles: 5,
                  gravity: 0.1,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.yellow,
                    Colors.red,
                  ],
                ),
              ),
              // Aquí colocamos el contenido original del AlertDialog
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mensajeFelicitacion,
                    style: TextStyle(color: Colors.white),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          ajustarBrilloColor(Colors.red), // text color
                    ),
                    onPressed: () {
                      controller.stop();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cerrar'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _cargarHabitos() async {
    try {
      // Obtener todos los hábitos del usuario
      final habitData = await HabitosService().obtenerHabitos(idUsuarioActual!);

      // Filtrar los hábitos según la fecha seleccionada
      final habitosFiltrados =
          filtrarHabitosPorFecha(habitData, _fechaSeleccionadCalendario);

      cargarHabitoYProgramarNotificaciones(habitData);
      _streamControllerHabitos.add(habitosFiltrados);
    } catch (error) {
      print("Error al cargar hábitos: $error");
    }
  }

  @override
  void dispose() {
    _streamControllerHabitos.close();
    super.dispose();
  }

  bool _debeMostrarseDiario() {
    return true;
  }

  bool _debeMostrarseEnDiasEspecificosSemana(
      List<int> diasSeleccionados,
      int diaSemanaSeleccionado,
      int diaSemanaInicio,
      DateTime fechaInicio,
      DateTime fechaSeleccionada) {
    // Verificamos si la fecha seleccionada es igual a la fecha de inicio.
    // Si es así, el hábito debería mostrarse en la fecha de inicio.
    if (fechaSeleccionada.year == fechaInicio.year &&
        fechaSeleccionada.month == fechaInicio.month &&
        fechaSeleccionada.day == fechaInicio.day) {
      return true;
    }

    // Si el día de la semana seleccionado es igual al día de inicio,
    // y el día de inicio está en la lista de días seleccionados,
    // entonces no debería mostrarse en el día de inicio mismo.
    if (diaSemanaSeleccionado == diaSemanaInicio &&
        diasSeleccionados.contains(diaSemanaInicio)) {
      return false;
    }

    // Si el día de la semana seleccionado está en la lista de días seleccionados,
    // entonces el hábito debería mostrarse.
    return diasSeleccionados.contains(diaSemanaSeleccionado);
  }

  bool _debeMostrarseEnDiasEspecificosMes(
      List<int> diasSeleccionados, int diaMesSeleccionado) {
    return diasSeleccionados.contains(diaMesSeleccionado);
  }

  bool _debeMostrarseRepetir(
      int intervaloRepetir, DateTime fechaInicio, DateTime fechaSeleccionada) {
    int diferenciaDias = fechaSeleccionada.difference(fechaInicio).inDays;
    return diferenciaDias % intervaloRepetir == 0;
  }

  int convertirDiaSemanaStringANumero(String diaSemana) {
    switch (diaSemana.toLowerCase()) {
      case 'lunes':
        return 1;
      case 'martes':
        return 2;
      case 'miércoles':
        return 3;
      case 'jueves':
        return 4;
      case 'viernes':
        return 5;
      case 'sábado':
        return 6;
      case 'domingo':
        return 7;
      default:
        return -1; // Valor por defecto si no se reconoce el día de la semana
    }
  }

  List<Map<String, dynamic>> filtrarHabitosPorFecha(
      List<Map<String, dynamic>> habitos, DateTime fechaSeleccionada) {
    return habitos.where((habito) {
      DateTime? fechaInicio = habito['fechaInicio'] != null
          ? (habito['fechaInicio'] as Timestamp).toDate()
          : null;
      DateTime? fechaFin = habito['fechaFinal'] != null
          ? (habito['fechaFinal'] as Timestamp).toDate()
          : null;

      if (fechaInicio != null && fechaSeleccionada.isBefore(fechaInicio)) {
        return false;
      }

      if (fechaFin != null && fechaSeleccionada.isAfter(fechaFin)) {
        return false;
      }

      String frecuencia = habito['frecuenciaHabito'];

      if (frecuencia == 'Cada día') {
        return _debeMostrarseDiario();
      } else if (frecuencia == 'Días específicos de la semana') {
        // Obtener la lista de días como List<dynamic>
        List<dynamic> valorFrecuencia = habito['valorFrecuencia'];

        // Convertir la lista de días a List<String>
        List<String> diasSeleccionados =
            valorFrecuencia.map((dia) => dia.toString()).toList();

        print("Dias seleccionados ${diasSeleccionados}");
        List<int> diasNumericos = diasSeleccionados
            .map((dia) => convertirDiaSemanaStringANumero(dia))
            .toList();

        print("Dias numericos: $diasNumericos");

        // Obtener el día de la semana de la fecha de inicio del hábito
        int diaSemanaInicio = fechaInicio?.weekday ?? 0;

        print("Dias semana inicio: $diaSemanaInicio");

        // Obtener el día de la semana de la fecha seleccionada
        int diaSemanaSeleccionado = fechaSeleccionada.weekday;

        print("Dias semana seleciconado $diaSemanaSeleccionado");

        // Retornar true si el día de la semana de la fecha seleccionada está entre los días seleccionados
        // o si coincide con el día de inicio del hábito
        return _debeMostrarseEnDiasEspecificosSemana(
            diasNumericos,
            diaSemanaSeleccionado,
            diaSemanaInicio,
            fechaInicio!,
            fechaSeleccionada);
      } else if (frecuencia == 'Días específicos del mes') {
        // Obtener la lista de días como List<dynamic>
        List<dynamic> valorFrecuencia = habito['valorFrecuencia'];

        // Convertir los elementos de la lista a enteros
        List<int> diasSeleccionados =
            valorFrecuencia.map((dia) => dia as int).toList();

        // Obtener el día del mes de la fecha seleccionada
        int diaMesSeleccionado = fechaSeleccionada.day;

        // Obtener el día del mes de la fecha de inicio del hábito
        int diaMesInicio = fechaInicio?.day ?? 0;

        // Retornar true si el día de la fecha seleccionada está entre los días seleccionados
        // o si es igual al día de inicio del hábito
        return diasSeleccionados.contains(diaMesSeleccionado) ||
            diaMesInicio == diaMesSeleccionado;
      } else if (frecuencia == 'Repetir') {
        int intervaloRepetir = int.parse(habito['valorFrecuencia']);
        return _debeMostrarseRepetir(
            intervaloRepetir, fechaInicio!, fechaSeleccionada);
      } else {
        return false;
      }
    }).toList();
  }

  Widget construirCalendario(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 100,
          width: double.infinity, // Ancho máximo disponible
          child: DatePicker(
            DateTime.now(),
            initialSelectedDate: DateTime.now(),
            selectionColor: Color(0xFF2773B9),
            selectedTextColor: Colors.white,
            height: 100,
            locale: 'es',
            onDateChange: (date) {
              setState(() {
                _fechaSeleccionadCalendario = date;
              });

              _cargarHabitos();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: Color(0xFF2773B9),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Center(
            child: CustomAppBar(titleText: "Rastreador de hábitos"),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                child:
                    SizedBox(height: 100, child: construirCalendario(context)),
              ),
              _construirHabitoStream(),
            ],
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 65),
        child: _construirBotonFlotante(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _construirBotonFlotante() {
    return FloatingActionButton(
      backgroundColor: Color(0xFF2773B9),
      focusColor: Colors.white,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HabitosPageView(
              manejarHabitoGuardado: _cargarHabitos,
            ), // No se pasa ningún parámetro opcional
          ),
        );
      },
      child: Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _construirHabitoStream() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120.0), // Margen inferior
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _streamControllerHabitos.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _construirListaHabitos(snapshot.data!);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _construirListaHabitos(List<Map<String, dynamic>> habitData) {
    if (habitData.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No hay hábitos agendados',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '¡Es un buen día para empezar!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: habitData.length,
        itemBuilder: (context, index) {
          final habit = habitData[index];
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: _construirHabito(habit),
          );
        },
      );
    }
  }

  Widget _construirHabito(Map<String, dynamic> habito) {
    Color color = Color(habito['color']);
    Color colorAjustado = ajustarBrilloColor(color);

    return GestureDetector(
      onTap: () => _manejarClicEnHabito(habito),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _construirContenedorIcono(habito),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _construirNombreHabito(habito),
                  SizedBox(height: 4),
                  _construirContenedorCategoria(habito, colorAjustado),
                ],
              ),
            ),
            SizedBox(width: 8),
            _construirCheckbox(habito),
          ],
        ),
      ),
    );
  }

  Widget _construirContenedorIcono(Map<String, dynamic> habito) {
    Color colorIcono = Colors.black;
    IconData iconoDatos = IconData(
      habito['iconoCategoria'],
      fontFamily: 'MaterialIcons',
    );

    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color(habito['color']),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconoDatos,
        size: 24,
        color: colorIcono,
      ),
    );
  }

  Widget _construirNombreHabito(Map<String, dynamic> habito) {
    String nombreHabito = habito['nombreHabito'] ?? '';
    return Text(
      nombreHabito,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _construirContenedorCategoria(
      Map<String, dynamic> habito, Color color) {
    String categoria = habito['categoria'] ?? '';
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(5.0),
      child: Text(
        categoria,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _construirCheckbox(Map<String, dynamic> habito) {
    // Obtener la fecha actual
    DateTime fechaActual = DateTime.now();
    bool esFechaPosterior = fechaActual.isBefore(_fechaSeleccionadCalendario);

    // Si la fecha del hábito es posterior a la fecha actual, desactiva el RadioButton
    if (esFechaPosterior) {
      return Transform.scale(
        scale: 1.5,
        child: Stack(
          children: [
            Checkbox(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              shape: CircleBorder(),
              fillColor: MaterialStateProperty.all<Color>(Colors.grey),
              value:
                  false, // Establecer el valor en falso para desactivar el checkbox
              onChanged:
                  null, // Establecer onChanged como null para deshabilitar el checkbox
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Icon(Icons.lock,
                  color: Colors.black, size: 10), // Icono del candado
            ),
          ],
        ),
      );
    } else {
      // Si la fecha del hábito no es posterior a la fecha actual, construye el checkbox normalmente
      return FutureBuilder<bool>(
        future: _verificarHabitoCompletado(habito),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final bool elHabitoEstaCompletado = snapshot.data!;

            return Transform.scale(
              scale: 1.5,
              child: Checkbox(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                shape: CircleBorder(),
                fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> estados) {
                    if (estados.contains(MaterialState.selected)) {
                      return Color(0xFF2773B9);
                    }
                    return Colors.transparent;
                  },
                ),
                value: elHabitoEstaCompletado,
                onChanged: (bool? value) {
                  // Aquí puedes agregar la lógica para manejar el cambio de estado del checkbox si es necesario
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return SizedBox(); // O cualquier otro widget que desees mostrar mientras esperas los datos
          }
        },
      );
    }
  }

  void actualizarHabitos() {
    _cargarHabitos();
  }

  Future<bool> _verificarHabitoCompletado(Map<String, dynamic> habito) async {
    int verificarValor = 0;

    DateTime fechaSinHora = DateTime(_fechaSeleccionadCalendario.year,
        _fechaSeleccionadCalendario.month, _fechaSeleccionadCalendario.day);

    verificarValor = await HabitosService()
        .obtenerValorHabitoCompletado(habito['id'], fechaSinHora);

    return verificarValor > 0;
  }

  Future<void> _manejarClicEnHabito(Map<String, dynamic> habito) async {
    if (habito['evaluarProgreso'] == 'valor numerico') {
      _mostrarDialogo(context, habito);
    } else {
      DateTime fechaSinHora = DateTime(_fechaSeleccionadCalendario.year,
          _fechaSeleccionadCalendario.month, _fechaSeleccionadCalendario.day);

      Future<bool> elHabitoCompletadoExiste =
          verificarHabitoCompletadoExiste(habito, fechaSinHora);

      if (await elHabitoCompletadoExiste) {
        await HabitosService()
            .borrarHabitoCompletado(habito['id'], fechaSinHora);
      } else {
        await HabitosService()
            .guardarHabitoCompletado(habito['id'], fechaSinHora, 1);
        final random = Random();
        final indiceAleatorio = random.nextInt(frasesDeFelicitacion.length);
        final mensajeFelicitacion = frasesDeFelicitacion[indiceAleatorio];
        mostrarDialogoFelicitacion(mensajeFelicitacion);
        if (estaCorriendo) {
          controller.stop();
        } else {
          controller.play();
        }
      }

      setState(() {});
    }
  }

  Future<bool> verificarHabitoCompletadoExiste(
      habito, DateTime fechaCompletado) async {
    bool elHabitoCompletadoExiste = await HabitosService()
        .verificarHabitoCompletadoExistente(habito['id'], fechaCompletado);
    return elHabitoCompletadoExiste;
  }

  void _mostrarDialogo(BuildContext context, Map<String, dynamic> habito) {
    showDialog(
      context: context,
      builder: (context) {
        // Crear una instancia de IngresarMetaDialog y pasarle el mapa habito
        return IngresarMetaDialog(
            context: context,
            habit: habito,
            actualizarHabitos: actualizarHabitos);
      },
    );
  }

  void programarNotificacion(Map<String, dynamic> habito) {
    List<dynamic> recordatorios = habito['horaRecordatorio'];

    if (recordatorios.isNotEmpty) {
      Map<String, dynamic> primerRecordatorio = recordatorios[0];
      String horaRecordatorio = primerRecordatorio['hora'];

      print("Hora del recordatorio: $horaRecordatorio");

      // Analizar la cadena de hora en formato AM/PM
      final DateFormat format = DateFormat('h:mm a');
      final DateTime parsedTime = format.parse(horaRecordatorio);

      // Obtener la fecha actual
      DateTime now = DateTime.now();

      // Calcular la hora de notificación para hoy
      DateTime scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );

      // Si la hora ya pasó hoy, programar la notificación para mañana
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(Duration(days: 1));
      }

      print("${scheduledDate} ok la fehca");

      // Programar la notificación
      NotificationService notificationService = NotificationService();
      notificationService.scheduleNotification(
        'Recordatorio', // Título de la notificación
        'Es hora de completar el hábito: ${habito['nombreHabito']}', // Cuerpo de la notificación
        scheduledDate, // Hora de la notificación
      );

      print("xd ok");
    }
  }

  Future<void> programarAlarma(Map<String, dynamic> habito) async {
    NotificationService notificationService = NotificationService();
    String horaAlarma = habito['horaRecordatorio'][0]['hora'];
    print("Hora de la alarma: $horaAlarma");

    // Analizar la cadena de hora en formato AM/PM
    final DateFormat format = DateFormat('h:mm a');
    final DateTime parsedTime = format.parse(horaAlarma);

    // Calcular la hora de la alarma
    final DateTime now = DateTime.now();
    DateTime alarmaDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    // Si la hora ya pasó hoy, programamos la alarma para mañana
    if (now.isAfter(alarmaDateTime)) {
      alarmaDateTime = alarmaDateTime.add(Duration(days: 1));
    }

    // Crear una descripción para la alarma
    String cuerpoAlarma =
        'Es hora de completar el hábito: ${habito['nombreHabito']}';

    // Mostrar la alarma
    await notificationService.showAlarm('Alarma', cuerpoAlarma);
  }

  void cargarHabitoYProgramarNotificaciones(
      List<Map<String, dynamic>> habitos) {
    habitos.forEach((habito) {
      if (habito['horaRecordatorio'] != null &&
          habito['horaRecordatorio'].isNotEmpty) {
        print(habito['horaRecordatorio']);
        if (habito['horaRecordatorio'][0]['tipo'] == 'Notificación') {
          programarNotificacion(habito);
        } else if (habito['horaRecordatorio'][0]['tipo'] == 'Alarma') {
          programarAlarma(habito);
        }
      }
    });
  }
}
