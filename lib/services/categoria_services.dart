/// The `CategoriesService` class provides methods for interacting with categories in a Firestore
/// database for a Flutter project.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/categoria.dart';

class CategoriesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String?> addCategory(String userId, Categoria categoria) async {
    try {
      await _firestore.collection('categorias').add({
        'userId': userId,
        'nombre': categoria.nombre,
        'icono': categoria.icono.codePoint,
        'color': categoria.color.value,
      });
    } catch (error) {
      print('Error al guardar la categoría: $error');
      throw error;
    }
    return null;
  }

    static Future<void> updateCategory(Categoria categoria) async {
    try {
      await _firestore.collection('categorias').doc(categoria.id).update({
        'nombre': categoria.nombre,
        'icono': categoria.icono.codePoint,
        'color': categoria.color.value,
      });
      print('Categoría actualizada con éxito');
    } catch (error) {
      print('Error al actualizar la categoría: $error');
      throw error;
    }
  }

  static Future<List<Categoria>> getCategoriesByUserId(
      String currentUserId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('categorias')
          .where('userId', isEqualTo: currentUserId)
          .get();

      List<Categoria> userCategories = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Categoria(
          id: doc.id,
          nombre: data['nombre'],
          icono: IconData(data['icono'], fontFamily: 'MaterialIcons'),
          color: Color(data['color']),
        );
      }).toList();

      return userCategories;
    } catch (error) {
      print('Error al obtener las categorías del usuario: $error');
      throw error;
    }
  }

  static Future<String?> getCategoryIdByName(
      String currentUserId, String categoryName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('categorias')
          .where('userId', isEqualTo: currentUserId)
          .where('nombre', isEqualTo: categoryName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Si se encontró al menos un documento con el nombre de la categoría
        // Devolvemos el ID del primer documento encontrado
        return querySnapshot.docs.first.id;
      } else {
        // Si no se encontraron documentos con el nombre de la categoría
        // Devolvemos null o manejas el caso según tus necesidades
        return null;
      }
    } catch (error) {
      print('Error al obtener el ID de la categoría por nombre: $error');
      throw error;
    }
  }

  static Future<void> deleteCategoryById(String? categoryId) async {
    try {
      await _firestore.collection('categorias').doc(categoryId).delete();
      print('Categoría eliminada con éxito');
    } catch (error) {
      print('Error al eliminar la categoría: $error');
      throw error;
    }
  }
}
