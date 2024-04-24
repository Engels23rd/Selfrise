import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/habitos/frecuenciaHabito.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/entity/AuthService.dart';
import 'package:flutter_proyecto_final/entity/BarraCircularProgreso.dart';
import 'package:flutter_proyecto_final/entity/categoria.dart';
import 'package:flutter_proyecto_final/services/categoria_services.dart';
import 'package:flutter_proyecto_final/services/habitos_services.dart';
import 'package:flutter_proyecto_final/utils/ajustar_brillo_color.dart';
import 'package:flutter_proyecto_final/utils/habito_chart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class EditarHabito extends StatefulWidget {
  final int initialTabIndex;
  final Map<String, dynamic> habito;
  final Function() cargarHabitos;
  final Function() closeDialogs;

  EditarHabito(
      {required this.initialTabIndex,
      required this.habito,
      required this.cargarHabitos,
      required this.closeDialogs});

  @override
  _EditarHabitoState createState() => _EditarHabitoState();
}

class _EditarHabitoState extends State<EditarHabito>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int conteoHabito = 0;
  int conteoMes = 0;
  int conteoSemana = 0;
  int conteoAnio = 0;
  List<HabitData> datosGrafica = [];
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late Future<List<Categoria>> _categoriasFuture;
  final String? idUsuarioActual = AuthService.getUserId();
  late String nombreCategoria = '';
  late Icon iconoCategoria;
  late Color colorCategoria;
  late List<Map<String, dynamic>> habitosUsuario = [];
  late DateTime fechaInicioDateTime;
  DateTime? fechaFinalDateTime = null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);
    _tabController.addListener(_tabChanged);
    _fetchConteoHabito();
    _fetchConteosAdicionales();
    _nombreController =
        TextEditingController(text: widget.habito['nombreHabito']);
    _descripcionController =
        TextEditingController(text: widget.habito['descripcionHabito']);
    _categoriasFuture =
        CategoriesService.getCategoriesByUserId(idUsuarioActual!);
    nombreCategoria = widget.habito['categoria'];

    if (widget.habito['fechaInicio'] is Timestamp) {
      fechaInicioDateTime =
          (widget.habito['fechaInicio'] as Timestamp).toDate();
    } else if (widget.habito['fechaInicio'] is DateTime) {
      fechaInicioDateTime = widget.habito['fechaInicio'];
    }

    if (widget.habito['fechaFinal'] == null) {
      

         widget.habito['fechaFinal'] = null;
         fechaFinalDateTime = null;
    }

    print("${fechaFinalDateTime} en init");

    if (widget.habito['fechaFinal'] != null) {
      if (widget.habito['fechaFinal'] is Timestamp) {
        fechaFinalDateTime =
            (widget.habito['fechaFinal'] as Timestamp).toDate();
      } else if (widget.habito['fechaFinal'] is DateTime) {
        fechaFinalDateTime = widget.habito['fechaFinal'];
      }
    } else {
      fechaFinalDateTime = null;
    }
  }

  Future<void> cargarHabitos() async {
    List<Map<String, dynamic>> habitosCargados =
        await HabitosService().obtenerHabitos(idUsuarioActual!);

    setState(() {
      habitosUsuario = habitosCargados;
    });
  }

  void _fetchConteoHabito() {
    String habitId = widget.habito['id'];
    HabitosService().obtenerConteoHabitosCompletados(habitId).then((value) {
      setState(() {
        conteoHabito = value;
      });
    }).catchError((error) {
      print('Error al obtener el conteo de hábitos completados: $error');
    });
  }

  void _fetchConteosAdicionales() async {
    String habitId = widget.habito['id'];
    // Obtener datos de Firestore según el mes seleccionado
    List<Map<String, dynamic>>? registros =
        await HabitosService().obtenerRegistrosCompletadosPorId(habitId);

    // Procesar los datos y actualizar los conteos
    if (registros != null) {
      // Obtener la fecha actual
      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat.MMM(); // Formato de fecha en español

      // Inicializar los conteos
      int conteoSemana = 0;
      int conteoMes = 0;
      int conteoAnio = 0;

      // Calcular los conteos de hábitos completados por semana, mes y año
      for (int i = 0; i < registros.length; i++) {
        DateTime fecha =
            (registros[i]['fechaCompletado'] as Timestamp).toDate();
        // Verificar si la fecha está dentro de la semana actual
        DateTime startOfWeek =
            DateTime(now.year, now.month, now.day - now.weekday);
        DateTime endOfWeek =
            DateTime(now.year, now.month, now.day - now.weekday + 7);
        if (fecha.isAfter(startOfWeek) && fecha.isBefore(endOfWeek)) {
          conteoSemana++;
        }
        // Verificar si la fecha está dentro del mes actual
        if (fecha.year == now.year && fecha.month == now.month) {
          conteoMes++;
        }
        // Verificar si la fecha está dentro del año actual
        if (fecha.year == now.year) {
          conteoAnio++;
        }
      }

      // Actualizar los estados de los conteos
      setState(() {
        this.conteoSemana = conteoSemana;
        this.conteoMes = conteoMes;
        this.conteoAnio = conteoAnio;

        // Construir la lista de datos para la gráfica
        List<HabitData> datosMeses = [];
        for (int i = 4; i >= 0; i--) {
          int month = now.month - i;
          int year = now.year;
          if (month <= 0) {
            month += 12;
            year--;
          }
          String nombreMes = formatter.format(DateTime(year, month));
          int conteo = 0;
          for (int j = 0; j < registros.length; j++) {
            DateTime fecha =
                (registros[j]['fechaCompletado'] as Timestamp).toDate();
            if (fecha.year == year && fecha.month == month) {
              conteo++;
            }
          }
          datosMeses.add(HabitData(nombreMes, conteo));
        }
        this.datosGrafica = datosMeses;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _tabChanged() {
    setState(() {});
  }

  Divider customDivider({double height = 10, double grosor = 8}) {
    return Divider(
      height:
          height, // Se usará el valor proporcionado, o 10 si no se proporciona ninguno
      color: Colors.grey,
      thickness: grosor,
    );
  }

  void _mostrarDialogoEliminarHabito(BuildContext context) {
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
                HabitosService().borrarHabito(widget.habito['id']);

                Fluttertoast.showToast(
                  msg: "Habito borrado correctamente",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                );

                await widget.cargarHabitos();

                widget.closeDialogs();

                // Llama a EditarHabito
                Navigator.pop(context);

                // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> nombresMeses = [];


    print(widget.habito['fechaFinal']);
    if(widget.habito['fechaFinal'] == null){
        
        setState(() {
          fechaFinalDateTime = null;
        });
    }

    print("${fechaFinalDateTime}  fecha final datetime");

    Color color = Color(widget.habito['color']);
    Color colorAjustado = ajustarBrilloColor(color);
    int conteoRecordatorios = 0;

    IconData iconoDatos = IconData(
      widget.habito['iconoCategoria'],
      fontFamily: 'MaterialIcons',
    );

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat.MMM();
    for (int i = 0; i < 5; i++) {
      nombresMeses.add(formatter.format(DateTime(now.year, now.month - i)));
    }
    nombresMeses = nombresMeses.reversed.toList();

    if (widget.habito['horaRecordatorio'] != null &&
        widget.habito['horaRecordatorio'].isNotEmpty) {
      conteoRecordatorios = widget.habito['horaRecordatorio'].length;
    }

    return DefaultTabController(
      length: 2, // Número total de pestañas
      initialIndex: widget.initialTabIndex, // Índice inicial de la pestaña
      child: Scaffold(
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
              child: CustomAppBar(
                titleText: widget.habito['nombreHabito'],
                showBackButton: true,
                icon: IconData(widget.habito['iconoCategoria'],
                    fontFamily: 'MaterialIcons'),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // Agregar el TabBar
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    'Estadísticas',
                  ),
                ),
                Tab(
                  child: Text(
                    'Editar',
                  ),
                ),
              ],
              indicatorColor: Color(0xFF2773B9),
              labelColor: Colors.black,
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold), // Estilo del texto activo
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Contenido de la pestaña de estadísticas
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Sección de la barra de progreso circular
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        10), // Padding interno del Container
                                    decoration: BoxDecoration(
                                      color: AppColors
                                          .drawer, // Color de fondo azul
                                      borderRadius: BorderRadius.circular(
                                          10), // Bordes redondeados
                                    ),
                                    child: Text(
                                      'Puntuación de hábito',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            14, // Tamaño del texto del título
                                        color: Colors
                                            .white, // Color del texto del título
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                    height:
                                        10), // Espacio entre el título y el CircularProgressBar
                                CircularProgressBar(
                                  percentage: conteoHabito.toDouble(),
                                  number: conteoHabito,
                                ),
                              ],
                            ),
                          ),

                          customDivider(),

                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              padding: EdgeInsets.all(
                                  10), // Padding interno del Container
                              decoration: BoxDecoration(
                                color: AppColors.drawer, // Color de fondo azul
                                borderRadius: BorderRadius.circular(
                                    10), // Bordes redondeados
                              ),
                              child: Text(
                                'Tiempos completados',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14, // Tamaño del texto del título
                                  color: Colors
                                      .white, // Color del texto del título
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20),
                            child: Column(
                              children: [
                                customDivider(height: 2, grosor: 1),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Esta semana:'),
                                    Text('$conteoSemana',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                customDivider(height: 2, grosor: 1),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Este mes:'),
                                    Text('$conteoMes',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                customDivider(height: 2, grosor: 1),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Este año:'),
                                    Text('$conteoAnio',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                customDivider(height: 2, grosor: 1),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total:'),
                                    Text(
                                      '$conteoHabito',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                customDivider(height: 2, grosor: 1),
                              ],
                            ),
                          ),

                          customDivider(),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: HabitoProgresoChart(
                              data: datosGrafica,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Contenido de la pestaña de editar
                  ListView.separated(
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      print(index);
                      if (index == 0) {
                        return ListTile(
                          leading: Icon(Icons.edit),
                          onTap: () {
                            mostrarDialogEditarNombre();
                          },
                          title: Text(
                            'Editar hábito',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            widget.habito['nombreHabito'],
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      } else if (index == 1) {
                        return ListTile(
                          leading: Icon(Icons.category),
                          onTap: () {
                            mostrarDialogoEditarCategoria();
                          },
                          title: Text(
                            'Categoría',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                nombreCategoria,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: colorAjustado,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                iconoDatos,
                                size: 24,
                                color: Colors.white,
                              ),
                            )
                          ]),
                        );
                      } else if (index == 2) {
                        return ListTile(
                          leading: Icon(Icons.info),
                          onTap: () {
                            mostrarDialogEditarDescripcion();
                          },
                          title: Text(
                            'Descripción',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            widget.habito['descripcionHabito'] == null
                                ? ''
                                : widget.habito['descripcionHabito'],
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }  else if (index == 3) {
                        return ListTile(
                          leading: Icon(Icons.repeat),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FrecuenciaScreen(
                                  editar: true,
                                  habito: widget.habito,
                                  actualizarHabito: widget.cargarHabitos,
                                  obtenerHabitos: cargarHabitos,
                                  currentIndex: index,
                                ),
                              ),
                            );
                          },
                          title: Text(
                            'Frecuencia',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Container(
                            constraints: BoxConstraints(
                              maxWidth: 200, // Define el ancho máximo del texto
                            ),
                            child: Text(
                              widget.habito['frecuenciaHabito'],
                              style: TextStyle(fontSize: 16),
                              softWrap:
                                  true, // Permite que el texto se envuelva automáticamente
                              overflow: TextOverflow
                                  .clip, // Controla el desbordamiento de texto
                            ),
                          ),
                        );
                      } else if (index == 4) {
                        return ListTile(
                          leading: Icon(Icons.calendar_month),
                          onTap: () {
                            _seleccionarFecha(
                                context, fechaInicioDateTime, false);
                          },
                          title: Text(
                            'Fecha inicio',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFF2773B9),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)), // Set rounded corners
                            ),
                            child: Text(
                              DateFormat('dd/MM/yy')
                                  .format(fechaInicioDateTime),
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          ),
                        );
                      } else if (index == 5) {
                        return ListTile(
                          leading: Icon(Icons.calendar_month),
                          onTap: () {
                            if (fechaFinalDateTime == null) {
                              fechaFinalDateTime = DateTime.now();
                            }

                            _seleccionarFecha(
                                context, fechaFinalDateTime!, true);
                          },
                          title: Text(
                            'Fecha final',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Espacio entre el contenedor y el icono de basurita
                              GestureDetector(
                                onTap: () {
                                  HabitosService().borrarFechaFinalHabito(
                                      widget.habito['id']);

                                  setState(() {
                                    fechaFinalDateTime = null;
                                    widget.habito['fechaFinal'] = null;
                                  });

                                  print("${fechaFinalDateTime} la fecha we");
                                },
                                child: Icon(
                                  Icons.delete_outline, // Icono de la basurita
                                  color: Colors
                                      .black, // Color del icono de la basurita
                                ),
                              ),
                              SizedBox(width: 5),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2773B9),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  fechaFinalDateTime != null
                                      ? DateFormat('dd/MM/yy')
                                          .format(fechaFinalDateTime!)
                                      : '-', // Mostrar guion si fechaFinalDateTime es nulo
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (index == 6) {
                        return ListTile(
                          leading: Icon(Icons.delete),
                          onTap: () {
                            _mostrarDialogoEliminarHabito(context);
                          },
                          title: Text(
                            'Borrar hábito',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return null;
                    },
                    separatorBuilder: (context, index) =>
                        Divider(), // Add divider after each item
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _seleccionarFecha(
    BuildContext context,
    DateTime isFechaInicio,
    bool isFechaFinal,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF2773B9),
              onSurface: Colors.white,
              background: Colors.red,
              surface: AppColors.drawer,
            ),
            dialogBackgroundColor: Color(0xFF2773B9),
            highlightColor: Colors.white,
            hintColor: Colors.red,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: isFechaInicio,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      helpText: 'Seleccionar Fecha',
    );

    if (pickedDate != null) {
      if (isFechaFinal) {
        try {
          fechaFinalDateTime = pickedDate;
          await HabitosService().actualizarFechaFinalHabito(
              widget.habito['id'], fechaFinalDateTime!);
          setState(() {
            widget.habito['fechaFinal'] = fechaFinalDateTime;
          });
        } catch (e) {
          print('Error al actualizar la fecha final del hábito: $e');
        }
      } else {
        try {
          fechaInicioDateTime = pickedDate;
          await HabitosService().actualizarFechaInicioHabito(
              widget.habito['id'], fechaInicioDateTime);
          setState(() {
            widget.habito['fechaInicio'] = fechaInicioDateTime;
          });
        } catch (e) {
          print('Error al actualizar la fecha del hábito: $e');
        }
      }
    }
  }

  void actualizarNombreHabito(String nuevoNombre) async {
    String habitId = widget.habito['id'];
    await HabitosService().actualizarNombreHabito(
        habitId, nuevoNombre); // Actualizar el nombre en Firebase
    setState(() {
      widget.habito['nombreHabito'] =
          nuevoNombre; // Actualizar el nombre en el widget
    });
    widget.cargarHabitos(); // Cargar los hábitos actualizados
  }

  void actualizarInterfazCategoria(Categoria categoriaSeleccionada) async {
    String habitId = widget.habito['id'];
    print(nombreCategoria);
    await HabitosService().actualizarCategoriaHabito(
      habitId,
      categoriaSeleccionada.nombre,
      categoriaSeleccionada.icono,
      categoriaSeleccionada.color,
    );
    setState(() {
      nombreCategoria = categoriaSeleccionada.nombre;
      widget.habito['categoria'] = categoriaSeleccionada.nombre;
      widget.habito['color'] = categoriaSeleccionada.color.value;
      widget.habito['iconoCategoria'] = categoriaSeleccionada.icono.codePoint;
    });

    widget.cargarHabitos();
    Navigator.pop(context);
  }

  void mostrarDialogoEditarCategoria() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.drawer,
          title: Text(
            'Categorías',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          contentPadding: EdgeInsets.all(20.0),
          content: Container(
            width: double.maxFinite,
            child: FutureBuilder<List<Categoria>>(
              future: _categoriasFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar las categorías'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(child: Text('No se encontraron categorías'));
                } else if (snapshot.hasData) {
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final categoria = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          print("object");
                          actualizarInterfazCategoria(categoria);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: categoria.color,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                categoria.icono,
                                color: Colors.black,
                                size: 20.0,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              categoria.nombre,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return SizedBox(); // Si no hay datos, retorna un contenedor vacío
                }
              },
            ),
          ),
        );
      },
    );
  }

  void mostrarDialogEditarNombre() {
    _nombreController =
        TextEditingController(text: widget.habito['nombreHabito']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.drawer,
              content: Form(
                child: TextFormField(
                  controller: _nombreController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Hábito',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(10),
                    backgroundColor: ajustarBrilloColor(Colors.red),
                  ),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    String nuevoNombre = _nombreController.text;
                    actualizarNombreHabito(
                        nuevoNombre); // Llamar a actualizarNombreHabito
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void actualizarDescripcionHabito(String nuevaDescripcion) async {
    String habitId = widget.habito['id'];
    await HabitosService().actualizarDescripcionHabito(
        habitId, nuevaDescripcion); // Actualizar la descripción en Firebase
    setState(() {
      widget.habito['descripcionHabito'] =
          nuevaDescripcion; // Actualizar la descripción en el widget
    });
    widget.cargarHabitos(); // Cargar los hábitos actualizados
  }

  void mostrarDialogEditarDescripcion() {
    _descripcionController =
        TextEditingController(text: widget.habito['descripcionHabito']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.drawer,
              content: Form(
                child: TextFormField(
                  controller: _descripcionController,
                  autofocus: true,
                  maxLines: null, // Permite múltiples líneas
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(10),
                    backgroundColor: ajustarBrilloColor(Colors.red),
                  ),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    String nuevaDescripcion = _descripcionController.text;
                    actualizarDescripcionHabito(
                        nuevaDescripcion); // Llamar a actualizarDescripcionHabito
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
