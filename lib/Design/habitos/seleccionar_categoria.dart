import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/const/colores_categorias.dart';
import 'package:flutter_proyecto_final/dialogs/crear_categoria_dialog.dart';
import 'package:flutter_proyecto_final/entity/Habito.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/entity/categoria.dart';
import 'package:flutter_proyecto_final/services/categoria_services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SeleccionarCategoriaPantalla extends StatefulWidget {
  final PageController pageController;

  SeleccionarCategoriaPantalla(this.pageController);

  @override
  _SeleccionarCategoriaPantallaState createState() =>
      _SeleccionarCategoriaPantallaState();
}

class _SeleccionarCategoriaPantallaState
    extends State<SeleccionarCategoriaPantalla> {
  late Stream<List<Categoria>> _categoriasStream;
  late StreamSubscription _categoriasSubscription;
  List<Categoria> categorias = [];
  final String? currentUserId = AuthService.getUserId();

  @override
  @override
  void initState() {
    super.initState();
    _categoriasStream = _getCategoriasStream();
    _categoriasSubscription = _categoriasStream.listen((List<Categoria> data) {
      setState(() {
        categorias = _ordenarCategoriasPorId(data);
      });
    });
    // Mover la llamada aquí
  }

  List<Categoria> _ordenarCategoriasPorId(List<Categoria> categorias) {
    categorias.sort((a, b) => b.id!.compareTo(a.id!));
    return categorias;
  }

  Stream<List<Categoria>> _getCategoriasStream() async* {
    if (currentUserId != null) {
      try {
        while (true) {
          // Espera 1 segundo
          List<Categoria> userCategories =
              await CategoriesService.getCategoriesByUserId(currentUserId!);
          yield userCategories;
        }
      } catch (error) {
        print('Error al obtener las categorías del usuario: $error');
      }
    }
    yield [];
  }

  @override
  void dispose() {
    _categoriasSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          margin: EdgeInsets.only(top: 70.0),
          child: Stack(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Selecciona una categoría para tu hábito',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          for (int i = 0; i < categorias.length; i += 2)
                            _buildChipRow(
                              _buildChip(categorias[i]),
                              i + 1 < categorias.length
                                  ? _buildChip(categorias[i + 1])
                                  : null,
                            ),
                          _buildChip(
                            Categoria(
                              nombre: 'Crear nueva categoría',
                              icono: Icons.add,
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChipRow(Widget chip1, Widget? chip2) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: chip1,
          ),
          if (chip2 != null) SizedBox(width: 8.0),
          if (chip2 != null) Expanded(child: chip2),
        ],
      ),
    );
  }

  Widget _buildChip(Categoria categoria) {
    return GestureDetector(
      onTap: () {
        if (categoria.nombre != 'Crear nueva categoría') {
          setState(() {
            Habito.category = categoria.nombre;
            Habito.categoryIcon = categoria.icono;
            Habito.color = categoria.color;
            widget.pageController.animateToPage(1,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          });
        } else {
          _showCrearCategoriaDialog(context);
        }
      },
      onLongPress: () {
        if (categoria.nombre != 'Crear nueva categoría') {
          _showCrearCategoriaDialog(context,
              showDeleteButton: true, categoria: categoria);
        } else {
          Fluttertoast.showToast(
            msg: "Las categorías por defecto no pueden modificarse",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
        }
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: categoria.color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                categoria.icono,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  categoria.nombre,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCrearCategoriaDialog(BuildContext context,
      {Categoria? categoria, bool showDeleteButton = false}) async {
    showDialog(
      context: context,
      builder: (context) => CrearCategoriaDialog(
        categoriaColores: categoriaColores,
        onCategoriaAdded: _agregarCategoria,
        showDeleteButton: showDeleteButton,
        categoria: categoria,
      ),
    );
  }

  void _agregarCategoria(
      String nuevaCategoriaText, IconData nuevoIcono, Color nuevoColor) async {
    final String? currentUserId = AuthService.getUserId();
    if (currentUserId != null) {
      try {
        // Añadir la categoría a la base de datos
        Categoria nuevaCategoria = Categoria(
          nombre: nuevaCategoriaText,
          icono: nuevoIcono,
          color: nuevoColor,
        );
        String? idCategoria =
            await CategoriesService.addCategory(currentUserId, nuevaCategoria);
        nuevaCategoria.id = idCategoria;
        setState(() {
          categorias.add(nuevaCategoria);
          categorias = _ordenarCategoriasPorId(
              categorias); // Ordenar nuevamente después de agregar
        });
      } catch (error) {
        print('Error al agregar la nueva categoría: $error');
      }
    }
  }
}
