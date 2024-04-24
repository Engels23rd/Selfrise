import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/entity/Alarma.dart';
import 'package:flutter_proyecto_final/entity/Frecuencia.dart';

class HabitosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> guardarHabito(
      String? userId,
      String categoria,
      IconData iconoCategoria,
      String nombreHabito,
      String evaluarProgreso,
      Frecuencia frecuenciaHabito,
      dynamic frecuenciaValor,
      DateTime fechaInicio,
      DateTime? fechaFinal,
      bool estaCompletado,
      Color color,
      int meta,
      List<Alarma>? recordatorios,
      [String? descripcionHabito = '']) async {
    try {
      List<Map<String, dynamic>> alarmasMaps = [];
      if (recordatorios != null) {
        // Convertir cada alarma en un mapa y agregarlo a la lista
        for (var alarma in recordatorios) {
          alarmasMaps.add(alarma.toMap());
        }
      }
      await FirebaseFirestore.instance.collection('habitos').add({
        'userId': userId,
        'categoria': categoria,
        'iconoCategoria': iconoCategoria.codePoint,
        'nombreHabito': nombreHabito,
        'evaluarProgreso': evaluarProgreso,
        'descripcionHabito': descripcionHabito,
        'frecuenciaHabito': frecuenciaHabito.nombre,
        'color': color.value,
        'valorFrecuencia': frecuenciaValor,
        'fechaInicio': fechaInicio,
        'fechaFinal': fechaFinal,
        'meta': meta,
        'metaUsuario': 0,
        'horaRecordatorio': alarmasMaps,
        'completado': estaCompletado
      });
      print('Hábito guardado en Firestore correctamente.');
    } catch (e) {
      print('Error al guardar el hábito en Firestore: $e');
      throw e;
    }
  }

  Future<void> borrarHabito(String idHabito) async {
    try {
      await FirebaseFirestore.instance
          .collection('habitos')
          .doc(idHabito)
          .delete();
      print('Hábito eliminado de Firestore correctamente.');
    } catch (e) {
      print('Error al eliminar el hábito de Firestore: $e');
      throw e;
    }
  }

  Future<void> actualizarMetaUsuario(
      String habitId, int nuevaMetaUsuario) async {
    try {
      // Obtener la referencia al documento del hábito
      DocumentReference habitRef =
          _firestore.collection('habitos').doc(habitId);

      // Actualizar el campo 'metaUsuario' del documento
      await habitRef.update({
        'metaUsuario': nuevaMetaUsuario,
      });
    } catch (e) {
      // Manejar cualquier error que ocurra durante la actualización
      throw Exception('Error al actualizar la metaUsuario del hábito: $e');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerHabitos(String userId) async {
    try {
      QuerySnapshot habitosSnapshot = await FirebaseFirestore.instance
          .collection('habitos')
          .where('userId', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> habitos = habitosSnapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();

      return habitos;
    } catch (e) {
      print('Error al obtener los hábitos: $e');
      throw e;
    }
  }

  Future<void> actualizarEstadoHabito(String habitId, bool completado) async {
    try {
      // Obtener la referencia al documento del hábito
      DocumentReference habitRef =
          _firestore.collection('habitos').doc(habitId);

      // Actualizar el campo 'completado' del documento
      await habitRef.update({
        'completado': completado,
      });

      // Si el hábito se marca como completado, guardar un registro de hábito completado
    } catch (e) {
      // Manejar cualquier error que ocurra durante la actualización
      throw Exception('Error al actualizar el estado del hábito: $e');
    }
  }

  Future<void> actualizarNombreHabito(
      String habitId, String nuevoNombre) async {
    try {
      // Obtener la referencia al documento del hábito
      DocumentReference habitRef =
          _firestore.collection('habitos').doc(habitId);

      // Actualizar el campo 'nombre' del documento
      await habitRef.update({
        'nombreHabito': nuevoNombre,
      });

      // No es necesario manejar eventos de cambio aquí, ya que Firestore sincroniza automáticamente los cambios en tiempo real
    } catch (e) {
      // Manejar cualquier error que ocurra durante la actualización
      throw Exception('Error al actualizar el nombre del hábito: $e');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerHabitosCompletadosEnFecha(
      DateTime selectedDate) async {
    try {
      QuerySnapshot registrosSnapshot = await _firestore
          .collection('registrosHabitosCompletados')
          .where('fechaCompletado', isEqualTo: selectedDate)
          .get();

      List<Map<String, dynamic>> registros = registrosSnapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();

      return registros;
    } catch (e) {
      print(
          'Error al obtener los hábitos completados en la fecha seleccionada: $e');
      throw e;
    }
  }

  // Método para obtener un hábito por su ID
  Future<Map<String, dynamic>> obtenerHabitoPorId(String habitId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('habitos').doc(habitId).get();
      return {...doc.data() as Map<String, dynamic>, 'id': doc.id};
    } catch (e) {
      print('Error al obtener el hábito por ID: $e');
      throw e;
    }
  }

  Future<int> obtenerValorHabitoCompletado(
      String habitId, DateTime fechaSeleccionada) async {
    try {
      final QuerySnapshot habitosProgreso = await _firestore
          .collection('habito_progreso')
          .where('fk_idHabito', isEqualTo: habitId)
          .where('fechaCompletado', isEqualTo: fechaSeleccionada)
          .get();

      if (habitosProgreso.docs.isNotEmpty) {
        print(habitosProgreso.docs[0]);
        return habitosProgreso.docs[0].get('valor') as int;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error al obtener los hábitos: $e');
      // Si ocurre una excepción, se retorna 0 o cualquier otro valor predeterminado
      return 0;
    }
  }

  Future<int> obtenerConteoHabitosCompletados(String habitId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('habito_progreso')
          .where('fk_idHabito', isEqualTo: habitId)
          .get();

      // Obtener el número de documentos que cumplen con la condición
      int conteo = querySnapshot.docs.length;
      return conteo;
    } catch (e) {
      print('Error al obtener el conteo de hábitos completados: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>?> obtenerRegistrosCompletadosPorId(
      String habitId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('habito_progreso')
          .where('fk_idHabito', isEqualTo: habitId)
          .get();

      // Mapear los documentos a una lista de mapas
      List<Map<String, dynamic>> registros = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      return registros;
    } catch (e) {
      print('Error al obtener los registros de hábitos completados: $e');
      throw e;
    }
  }

  Future<void> guardarHabitoCompletado(
      String habitId, DateTime fechaCompletado, int valor) async {
    try {
      await _firestore.collection('habito_progreso').add({
        'fk_idHabito': habitId,
        'fechaCompletado': fechaCompletado,
        'valor': valor,
      });
    } catch (e) {
      print('Error al guardar nuevo hábito de progreso: $e');
      throw e;
    }
  }

  Future<void> borrarHabitoCompletado(
      String habitId, DateTime fechaCompletado) async {
    try {
      // Acceder a la instancia de Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      Timestamp timestamp = Timestamp.fromDate(fechaCompletado);

      print(habitId);
      print(fechaCompletado);

      // Obtener la referencia del documento del hábito completado
      QuerySnapshot querySnapshot = await firestore
          .collection('habito_progreso')
          .where('fk_idHabito', isEqualTo: habitId)
          .where('fechaCompletado', isEqualTo: timestamp) // Filtrar por fecha
          .get();

      // Eliminar el documento encontrado
      querySnapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });
    } catch (e) {
      print('Error al borrar el hábito completado: $e');
      throw e;
    }
  }

  Future<bool> verificarHabitoCompletadoExistente(
      String habitId, DateTime fechaCompletado) async {
    try {
      // Acceder a la instancia de Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Convertir la fecha a un Timestamp

      // Obtener la referencia del documento del hábito completado
      QuerySnapshot querySnapshot = await firestore
          .collection('habito_progreso')
          .where('fk_idHabito', isEqualTo: habitId)
          .where('fechaCompletado', isEqualTo: fechaCompletado)
          .get();

      // Si hay documentos que cumplen con los criterios de consulta, el hábito existe
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error al verificar el hábito completado: $e');
      throw e;
    }
  }

  Future<void> actualizarValorHabito(String habitId, int nuevoValor) async {
    try {
      // Acceder a la instancia de Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Obtener la referencia del documento del hábito
      DocumentReference habitoRef =
          firestore.collection('habito_progreso').doc(habitId);

      // Actualizar el campo "valor" del documento
      await habitoRef.update({'valor': nuevoValor});

      print('Valor del hábito actualizado correctamente');
    } catch (e) {
      print('Error al actualizar el valor del hábito: $e');
      throw e;
    }
  }

  Future<String?> obtenerIdDocumentoHabitoCompletado(
      String habitId, DateTime fechaCompletado) async {
    try {
      // Acceder a la instancia de Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Realizar la consulta a la colección 'habito_progreso'
      QuerySnapshot querySnapshot = await firestore
          .collection('habito_progreso')
          .where('fk_idHabito', isEqualTo: habitId)
          .where('fechaCompletado', isEqualTo: fechaCompletado)
          .get();

      // Verificar si se encontraron documentos
      if (querySnapshot.docs.isNotEmpty) {
        // Obtener el ID del primer documento encontrado
        return querySnapshot.docs.first.id;
      } else {
        // Si no se encontraron documentos, devolver null
        return null;
      }
    } catch (e) {
      print('Error al obtener el ID del documento: $e');
      throw e;
    }
  }

  Future<void> actualizarCategoriaHabito(String habitId, String nuevaCategoria,
      IconData nuevoIcono, Color nuevoColor) async {
    try {
      // Obtener la referencia al documento del hábito
      DocumentReference habitRef =
          _firestore.collection('habitos').doc(habitId);

      // Actualizar los campos 'categoria', 'icono' y 'color' del documento
      await habitRef.update({
        'categoria': nuevaCategoria,
        'iconoCategoria': nuevoIcono.codePoint,
        'color': nuevoColor.value,
      });

      print('Categoría, icono y color del hábito actualizados correctamente');
    } catch (e) {
      print('Error al actualizar la categoría, icono y color del hábito: $e');
      throw e;
    }
  }

  Future<void> actualizarDescripcionHabito(
      String habitId, String nuevaDescripcion) async {
    try {
      // Obtener la referencia al documento del hábito
      DocumentReference habitRef =
          _firestore.collection('habitos').doc(habitId);

      // Actualizar el campo 'descripcionHabito' del documento
      await habitRef.update({
        'descripcionHabito': nuevaDescripcion,
      });

      print('Descripción del hábito actualizada correctamente');
    } catch (e) {
      print('Error al actualizar la descripción del hábito: $e');
      throw e;
    }
  }

  Future<void> actualizarFrecuenciaHabito(String habitId,
      Frecuencia frecuenciaHabito, dynamic frecuenciaValor) async {
    try {
      await FirebaseFirestore.instance
          .collection('habitos')
          .doc(habitId)
          .update({
        'frecuenciaHabito': frecuenciaHabito.nombre,
        'valorFrecuencia': frecuenciaValor,
      });
      print('Frecuencia del hábito actualizada correctamente.');
    } catch (e) {
      print('Error al actualizar la frecuencia del hábito: $e');
      throw e;
    }
  }

  Future<bool> verificarHabitoCompletadoExistenteParaDia(
      String habitId, DateTime fechaCompletado) async {
    try {
      // Acceder a la instancia de Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Convertir la fecha a un Timestamp
      Timestamp fechaCompletadoTimestamp = Timestamp.fromDate(fechaCompletado);

      // Obtener la referencia del documento del hábito completado
      QuerySnapshot querySnapshot = await firestore
          .collection('habito_progreso')
          .where('fk_idHabito', isEqualTo: habitId)
          .where('fechaCompletado', isEqualTo: fechaCompletadoTimestamp)
          .get();

      // Si hay documentos que cumplen con los criterios de consulta, el hábito existe
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error al verificar el hábito completado para el día: $e');
      throw e;
    }
  }

  Future<void> actualizarFechaInicioHabito(
      String habitId, DateTime nuevaFecha) async {
    try {
      await FirebaseFirestore.instance
          .collection('habitos')
          .doc(habitId)
          .update({
        'fechaInicio': nuevaFecha,
      });
      print('Fecha del hábito actualizada correctamente.');
    } catch (e) {
      print('Error al actualizar la fecha del hábito: $e');
      throw e;
    }
  }

  Future<void> actualizarFechaFinalHabito(
      String habitId, DateTime nuevaFecha) async {
    try {
      await FirebaseFirestore.instance
          .collection('habitos')
          .doc(habitId)
          .update({
        'fechaFinal': nuevaFecha,
      });
      print('Fecha del hábito actualizada correctamente.');
    } catch (e) {
      print('Error al actualizar la fecha del hábito: $e');
      throw e;
    }
  }

  Future<void> borrarFechaFinalHabito(String habitId) async {
    try {
      await FirebaseFirestore.instance
          .collection('habitos')
          .doc(habitId)
          .update({
        'fechaFinal': null, // Establecer el valor como null
      });
      print('Fecha final del hábito establecida como null correctamente.');
    } catch (e) {
      print('Error al establecer la fecha final del hábito como null: $e');
      throw e;
    }
  }
}
