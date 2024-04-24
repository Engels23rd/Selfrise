import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/components/UserModel.dart';
import 'package:get/get.dart';

final db = FirebaseFirestore.instance.collection('user');

class DataBase {
  Future addUser(String userId, Map<String, dynamic> userInfoMap) {
    return db.doc(userId).set(userInfoMap);
  }
}

Future<bool> checkIfUserExists(String email) async {
  try {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('user');

    QuerySnapshot querySnapshot =
        await usersRef.where('email', isEqualTo: email).get();

    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error al verificar si el usuario existe: $e');
    return false;
  }
}

class UserRep extends GetxController {
  static UserRep get instance => Get.find();
  Future<void> createUserWithEmailAndPassword(UserModel user) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      String userId = userCredential.user!.uid;

      String imageUrl =
          await user.uploadImageStorage('ImagenDePerfil', user.file);

      await db.doc(userId).set({
        "name": user.name + ' ' + user.lastname,
        'email': user.email,
        'birthday': user.birthday,
        'imageLink': imageUrl,
      });

      Get.snackbar(
        "LOGRADO",
        "Tu cuenta ha sido creada correctamente",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        "Ha ocurrido un error al crear la cuenta: $error",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print('Error al crear la cuenta: $error');
    }
  }
}
