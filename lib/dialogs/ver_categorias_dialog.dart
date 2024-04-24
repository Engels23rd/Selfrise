import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/entity/AuthService.dart';
import 'package:flutter_proyecto_final/entity/categoria.dart';
import 'package:flutter_proyecto_final/services/categoria_services.dart';
import 'package:flutter_proyecto_final/services/habitos_services.dart';

class CategoriaDialogo extends StatefulWidget {
  final Map<String, dynamic> habito;
  final Function() cargarHabitos;
  CategoriaDialogo(this.habito, {required this.cargarHabitos});

  @override
  _CategoriaDialogoState createState() => _CategoriaDialogoState(habito);
}

class _CategoriaDialogoState extends State<CategoriaDialogo> {
  late Future<List<Categoria>> _categoriasFuture;

  final String? idUsuarioActual = AuthService.getUserId();

  _CategoriaDialogoState(Map<String, dynamic> habito);

  @override
  void initState() {
    super.initState();
    _categoriasFuture =
        CategoriesService.getCategoriesByUserId(idUsuarioActual!);
  }

void actualizarInterfazCategoria(Categoria categoriaSeleccionada) async {
    String habitId = widget.habito['id'];
    await HabitosService().actualizarCategoriaHabito(
      habitId,
      categoriaSeleccionada.nombre,
      categoriaSeleccionada.icono,
      categoriaSeleccionada.color,
    );
    setState(() {
      // Actualizar la categoría en el widget
      widget.habito['categoria'] = categoriaSeleccionada.nombre;
      widget.habito['color'] = categoriaSeleccionada.color.value;
      widget.habito['iconoCategoria'] = categoriaSeleccionada.icono.codePoint;
    });
     
    Navigator.of(context).pop();
     widget.cargarHabitos();
     print("xd");
    // Cargar los hábitos actualizados
  
  }


  @override
  Widget build(BuildContext context) {
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
                      // Mostrar el diálogo de confirmación al seleccionar una categoría
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
  }
}
