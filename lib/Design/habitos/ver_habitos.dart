import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/habitos/editar_habito.dart';
import 'package:flutter_proyecto_final/Design/habitos/habitos_stepper.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/entity/AuthService.dart';
import 'package:flutter_proyecto_final/services/habitos_services.dart';
import 'package:flutter_proyecto_final/utils/ajustar_brillo_color.dart';
import 'package:flutter_proyecto_final/utils/ajustar_color_navigation_bar_icon.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_dialogs/material_dialogs.dart';

class VerHabitosScreen extends StatefulWidget {
  @override
  _VerHabitosScreenState createState() => _VerHabitosScreenState();
}

class _VerHabitosScreenState extends State<VerHabitosScreen> {
  late List<Map<String, dynamic>> habitosUsuario = [];
  final String? idUsuarioActual = AuthService.getUserId();
  DateTime now = DateTime.now();
  List<String> weekDays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  @override
  void initState() {
    super.initState();
    ColorSystemNavitagionBar.setSystemUIOverlayStyleLight();
    cargarHabitos();
  }

  void dispose() {
    ColorSystemNavitagionBar.setSystemUIOverlayStyleDark();
    super.dispose();
  }

  Future<void> cargarHabitos() async {
    List<Map<String, dynamic>> habitosCargados =
        await HabitosService().obtenerHabitos(idUsuarioActual!);

    setState(() {
      habitosUsuario = habitosCargados;
    });
  }

  void closeDialog() {
    Navigator.pop(context);
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
            child: CustomAppBar(titleText: "Mis hábitos", showBackButton: true),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            habitosUsuario.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 320),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No hay hábitos activos.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Siempre es un buen día para empezar.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 80),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: habitosUsuario.length,
                    itemBuilder: (context, index) {
                      final habito = habitosUsuario[index];
                      return buildHabitoCard(habito);
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: _construirBotonFlotante(),
    );
  }

  Widget construirIconoConTexto(Map<String, dynamic> habito) {
    return Column(
      children: [
        ListTile(
          // Color de fondo del ListTile
          leading: Icon(
            Icons.analytics_rounded,
            color: Colors.white,
          ),
          title: Text('Estadísticas', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditarHabito(
                      initialTabIndex: 0,
                      habito: habito,
                      cargarHabitos: cargarHabitos,
                      closeDialogs: closeDialog)), // Llama a EditarHabito
            );
          },
        ),
        ListTile(
          // Color de fondo del ListTile
          leading: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          title: Text('Editar', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditarHabito(
                      initialTabIndex: 1,
                      habito: habito,
                      cargarHabitos: cargarHabitos,
                      closeDialogs: closeDialog)), // Llama a EditarHabito
            );
          },
        ),
        ListTile(
// Color de fondo del ListTile
          leading: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          title: Text('Eliminar', style: TextStyle(color: Colors.white)),
          onTap: () {
            // Agregar lógica para la opción de Eliminar
            _mostrarDialogoEliminarHabito(context, habito, () {
              // Función de cierre para cerrar ambos diálogos
              Navigator.of(context).popUntil((route) => true);
            });
          },
        ),
      ],
    );
  }

  void _mostrarDialogoEliminarHabito(
      BuildContext context, Map<String, dynamic> habito,
      [Function? closeDialogs]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.drawer, // Color de fondo azul
          title: Text(
            'Eliminar habito',
            style: TextStyle(color: Colors.white), // Texto blanco
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar este habito?',
            style: TextStyle(color: Colors.white), // Texto blanco
          ),
          actions: <Widget>[
            // Botón Cancelar
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue, // Color de fondo azul
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Bordes redondos
                ),
              ),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            // Botón Eliminar
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    ajustarBrilloColor(Colors.red), // Color de fondo azul
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Bordes redondos
                ),
              ),
              child: Text(
                'Eliminar',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              onPressed: () async {
                HabitosService().borrarHabito(habito['id']);

                Fluttertoast.showToast(
                  msg: "Habito borrado correctamente",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                );
                await cargarHabitos();

                closeDialog();

                Navigator.pop(context);
                // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  void mostrarDialogo(Map<String, dynamic> habito, BuildContext context) {
    Dialogs.bottomMaterialDialog(
      color: AppColors.drawer,
      context: context,
      actions: [
        Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.zero,
                child: buildHabitoInfo(habito, color: Colors.white),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.zero,
                child: buildDivider(color: Colors.white),
              ),
              SizedBox(height: 10),
              construirIconoConTexto(habito)
              // Agregar más widgets según sea necesario
            ],
          ),
        ),
      ],
    );
  }

  Widget buildHabitoCard(Map<String, dynamic> habito) {
    return Card(
      margin: EdgeInsets.all(8.0),
      color: AppColors.drawer,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.grey, width: 1.0),
      ),
      child: InkWell(
        onTap: () {
          mostrarDialogo(habito, context);
        },
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHabitoInfo(habito),
              buildDivider(color: Colors.white),
              SizedBox(height: 15),
              buildWeekDays(habito),
              SizedBox(height: 15),
              buildDivider(color: Colors.white),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
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
              manejarHabitoGuardado: cargarHabitos,
            ), // No se pasa ningún parámetro opcional
          ),
        );
      },
      child: Icon(Icons.add, color: Colors.white),
    );
  }

  Widget buildHabitoInfo(Map<String, dynamic> habito, {Color? color}) {
    Color nombreColor = color ?? Colors.white;
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildHabitoName(habito, color: nombreColor),
          buildHabitoIcon(habito),
        ],
      ),
    );
  }

  Widget buildHabitoName(Map<String, dynamic> habito, {Color? color}) {
    Color nombreColor = color ?? Colors.black;
    Color colorAjustado = ajustarBrilloColor(Color(habito['color']));
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            habito['nombreHabito'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: nombreColor,
            ),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: colorAjustado,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              habito['frecuenciaHabito'],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHabitoIcon(Map<String, dynamic> habito) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color(habito['color']),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(
        IconData(
          habito['iconoCategoria'],
          fontFamily: 'MaterialIcons',
        ),
        size: 24,
        color: Colors.black,
      ),
    );
  }

  Widget buildDivider({Color? color}) {
    return Divider(
      color: color ??
          Colors
              .black, // Establecer un color por defecto si no se proporciona ninguno
      height: 15,
    );
  }

  Widget buildWeekDays(Map<String, dynamic> habito) {
    List<DateTime> weekDaysList = [];
    for (int i = 6; i >= 0; i--) {
      DateTime day = now.subtract(Duration(days: i));
      weekDaysList.add(day);
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: weekDaysList.map((day) {
            return Column(
              children: [
                Text(
                  weekDays[day.weekday - 1],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                FutureBuilder<Color>(
                  future: getColorsForDay(day, habito),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      Color color = snapshot.data!;
                      return Container(
                        width: 44,
                        height: 44,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                          color: color,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<Color> getColorsForDay(
      DateTime day, Map<String, dynamic> habito) async {
    Color color = Colors.grey;
    int num = 0;

    Timestamp fechaInicioTimestamp = habito['fechaInicio'];
    DateTime fechaInicio = fechaInicioTimestamp.toDate();
    DateTime fechaFin = habito['fechaFinal'] != null
        ? (habito['fechaFinal'] as Timestamp).toDate()
        : DateTime.now(); // Si fechaFinal es nula, usar la fecha actual

    print(fechaInicioTimestamp.toDate());
    print("object");
    // Verificar si el día está dentro del rango de fechas del hábito
    if (day.isAfter(fechaInicio.subtract(Duration(days: 0))) &&
        day.isBefore(fechaFin.add(Duration(days: 1)))) {
      // Verificar si el hábito fue completado para este día
      String habitId = habito['id'];
      DateTime fechaSinHora = DateTime(day.year, day.month, day.day);

      print("xd ${num} ${fechaSinHora.toIso8601String()}");
      bool completado = await HabitosService()
          .verificarHabitoCompletadoExistenteParaDia(habitId, fechaSinHora);
      num++;
      if (completado) {
        color = Colors.green; // Hábito completado
      } else if (day.year == DateTime.now().year &&
          day.month == DateTime.now().month &&
          day.day == DateTime.now().day) {
        color = Colors.yellow; // Hábito pendiente para el día actual
      } else if (day.isBefore(DateTime.now())) {
        color = Colors.red; // Hábito no completado y el día ya pasó
      }
    }

    return color;
  }
}
