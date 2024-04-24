import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart'; // Importa esta librería si es necesaria para la definición de la clase IconData

class Categoria {
  late final String? id;
  final String nombre;
  final IconData icono;
  final Color color;
  final bool esDefault; // Nueva propiedad para indicar si la categoría es por defecto

  Categoria({
    this.id,
    required this.nombre,
    required this.icono,
    required this.color,
    this.esDefault = false, // Por defecto, las categorías no serán por defecto
  });
}

