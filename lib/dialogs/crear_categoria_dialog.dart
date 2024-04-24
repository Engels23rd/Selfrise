import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/entity/categoria.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/services/categoria_services.dart';
import 'package:flutter_proyecto_final/utils/ajustar_brillo_color.dart';
import 'package:flutter_proyecto_final/utils/iconos_disponibles.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CrearCategoriaDialog extends StatefulWidget {
  final Map<String, Color> categoriaColores;
  final Function(String, IconData, Color) onCategoriaAdded;
  final bool showDeleteButton;
  final Categoria? categoria;
  final void Function()? onCategoriaDeleted; // Nuevo parámetro

  CrearCategoriaDialog({
    required this.categoriaColores,
    required this.onCategoriaAdded,
    this.showDeleteButton = false,
    this.categoria,
    this.onCategoriaDeleted, // Agregado al constructor
  });

  @override
  _CrearCategoriaDialogState createState() => _CrearCategoriaDialogState();
}

class _CrearCategoriaDialogState extends State<CrearCategoriaDialog> {
  late String nuevaCategoriaText;
  late IconData nuevoIcono;
  late Color nuevoColor;

  void closeDialog() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.categoria?.id);

    nuevaCategoriaText =
        widget.showDeleteButton ? widget.categoria!.nombre : 'Nueva categoría';
    nuevoIcono =
        widget.showDeleteButton ? widget.categoria!.icono : Icons.category;
    nuevoColor = (widget.showDeleteButton
        ? widget.categoria?.color
        : Color(0xFFBBDEFB))!;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: AppColors.drawer,
          contentPadding: EdgeInsets.all(20),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    child: Icon(
                      Icons.circle,
                      size: 20,
                      color: nuevoColor,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    nuevaCategoriaText,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: nuevoColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  nuevoIcono,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(),
                ListTile(
                  textColor: Colors.white,
                  leading: Icon(Icons.edit, color: Colors.white),
                  title: Text('Nombre de la categoría'),
                  onTap: () {
                    _mostrarDialogoNombreCategoria(
                      context,
                      (nuevoNombreCategoria) {
                        setState(() {
                          nuevaCategoriaText = nuevoNombreCategoria!;
                        });
                      },
                    );
                  },
                ),
                Divider(),
                ListTile(
                  textColor: Colors.white,
                  leading: Icon(Icons.image, color: Colors.white),
                  title: Text('Icono de la categoría'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: AppColors.drawer,
                          title: Text(
                            'Selecciona un icono',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: GridView.count(
                              crossAxisCount: 4,
                              children: iconosDisponibles.map((icono) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      nuevoIcono = icono;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: nuevoIcono == icono
                                          ? Colors.grey.withOpacity(0.5)
                                          : null,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      icono,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                Divider(),
                ListTile(
                  textColor: Colors.white,
                  leading: Icon(
                    Icons.color_lens,
                    color: Colors.white,
                  ),
                  title: Text('Color de la categoría'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: AppColors.drawer,
                          title: Text(
                            'Selecciona un color',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: widget.categoriaColores.entries
                                  .take(12)
                                  .map((entry) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      nuevoColor = entry.value;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: entry.value,
                                      shape: BoxShape.circle,
                                    ),
                                    child: nuevoColor == entry.value
                                        ? Icon(Icons.check, color: Colors.white)
                                        : null,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                Divider(),
                if (widget.showDeleteButton)
                  ListTile(
                    textColor: Colors.white,
                    leading: Icon(Icons.delete, color: Colors.white),
                    title: Text('Eliminar categoría'),
                    onTap: () {
                      _mostrarDialogoEliminarCategoria(context, closeDialog);
                    },
                  ),
                if (widget.showDeleteButton) Divider(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nuevaCategoriaText.isNotEmpty &&
                    !widget.categoriaColores.containsKey(nuevaCategoriaText)) {
                  Categoria nuevaCategoria = Categoria(
                    nombre: nuevaCategoriaText,
                    icono: nuevoIcono,
                    color: nuevoColor,
                  );

                  final String? currentUserId = AuthService.getUserId();
                  CategoriesService.addCategory(currentUserId!, nuevaCategoria);

                  Navigator.pop(context);
                }
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF2773B9),
                    borderRadius: BorderRadius.circular(
                        20.0), // Ajusta el radio según sea necesario
                  ),
                  padding: EdgeInsets.all(
                      10.0), // Ajusta el relleno según sea necesario
                  child: widget.showDeleteButton
                      ? GestureDetector(
                          onTap: () async {
                            Categoria categoriaActualizada = Categoria(
                                id: widget.categoria!.id,
                                nombre: nuevaCategoriaText,
                                color: nuevoColor,
                                icono:
                                    nuevoIcono // Supongamos que el nuevo color es azul
                                );
                            try {
                              await CategoriesService.updateCategory(
                                  categoriaActualizada);
                              Fluttertoast.showToast(
                                msg: "Categoría actualizada correctamente",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                              );
                              Navigator.pop(context);
                            } catch (error) {
                              print('Error al actualizar la categoría: $error');
                            }
                          },
                          child: Text(
                            'Modificar categoría',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : Text(
                          'Crear categoría',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18), // Color del texto
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoNombreCategoria(
      BuildContext context, Function(String?) onChanged) {
    String? nuevoNombreCategoria;
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.drawer,
          title: Text('Nombre de la categoría',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            onChanged: (value) {
              setState(() {
                nuevoNombreCategoria = value;
              });
            },
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(50.0), // Borde redondeado
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(50.0), // Borde redondeado
              ),
              hintText: 'Ingresa el nombre',
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          actions: [
            Container(
              margin:
                  EdgeInsets.all(8.0), // Ajusta el margen según sea necesario
              decoration: BoxDecoration(
                color: Color(0xFF2773B9), // Color de fondo
                borderRadius: BorderRadius.circular(20), // Bordes redondeados
              ),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal:
                          24.0), // Ajusta el padding según sea necesario
                  // Otros estilos de botón, como el color del borde, pueden ser ajustados aquí
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.white, // Color del texto
                  ),
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.all(8.0), // Ajusta el margen según sea necesario
              decoration: BoxDecoration(
                color: Color(0xFF2773B9), // Color de fondo
                borderRadius: BorderRadius.circular(20), // Bordes redondeados
              ),
              child: OutlinedButton(
                onPressed: () {
                  if (nuevoNombreCategoria != null &&
                      nuevoNombreCategoria!.isNotEmpty) {
                    onChanged(nuevoNombreCategoria);
                    Navigator.pop(context, nuevoNombreCategoria);
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal:
                          24.0), // Ajusta el padding según sea necesario
                  // Otros estilos de botón, como el color del borde, pueden ser ajustados aquí
                ),
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                    color: Colors.white, // Color del texto
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoEliminarCategoria(
      BuildContext context, Function? onCategoriaDeleted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.drawer, // Color de fondo azul
          title: Text(
            'Eliminar categoría',
            style: TextStyle(color: Colors.white), // Texto blanco
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar esta categoría?',
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
                backgroundColor: ajustarBrilloColor(Colors.red  ), // Color de fondo azul
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Bordes redondos
                ),
              ),
              child: Text(
                'Eliminar',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              onPressed: () {
                if (widget.categoria != null) {
                  CategoriesService.deleteCategoryById(widget.categoria!.id);

                  Fluttertoast.showToast(
                    msg: "Categoría borrada correctamente",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  );

                  if (onCategoriaDeleted != null) {
                    onCategoriaDeleted();
                  }
                }

                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }
}
