import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        await _saveUserData(user.uid, {
          'name': user.displayName,
          'email': user.email,
          'imageLink': user.photoURL,
          'id': user.uid,
        });
      }
    } catch (error) {
      print('Error al iniciar sesión con Google: $error');
    }
  }

  static Future<void> _saveUserData(
      String userId, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('user').doc(userId).set(userData);
    } catch (error) {
      print('Error al guardar los datos del usuario: $error');
    }
  }

  static Future<String?> getUserName() async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDataSnapshot =
            await _firestore.collection('user').doc(user.uid).get();
        return userDataSnapshot.get('name');
      }
      return null;
    } catch (error) {
      print('Error al obtener el nombre del usuario: $error');
      return null;
    }
  }

  static Future<String?> getUserPhotoUrl(String? userId) async {
    try {
      if (userId != null) {
        final DocumentSnapshot userDataSnapshot =
            await _firestore.collection('user').doc(userId).get();
        return userDataSnapshot.get('imageLink');
      }
      return null;
    } catch (error) {
      print('Error al obtener la foto de perfil del usuario: $error');
      return null;
    }
  }

  static Future<String?> getUserEmail() async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDataSnapshot =
            await _firestore.collection('user').doc(user.uid).get();
        return userDataSnapshot.get('email');
      }
      return null;
    } catch (error) {
      print('Error al obtener el email del usuario: $error');
      return null;
    }
  }

  static String? getUserId() {
    try {
      final User? user = _firebaseAuth.currentUser;
      return user?.uid;
    } catch (error) {
      print('Error al obtener el ID del usuario: $error');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUserData(String? userId) async {
    try {
      if (userId != null) {
        final DocumentSnapshot userDataSnapshot =
            await _firestore.collection('user').doc(userId).get();
        return userDataSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (error) {
      print('Error al obtener los datos del usuario: $error');
      return null;
    }
  }

  static Future<void> updateUserData(
      String userId, Map<String, dynamic> data) async {
    await _firestore.collection('user').doc(userId).update(data);
  }

  // Asume que esta es tu función modificada que ahora acepta una contraseña para reautenticación.
  static Future<void> updateEmail(String newEmail, String password) async {
    User? user = FirebaseAuth.instance.currentUser;
    AuthCredential credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: password,
    );

    try {
      // Reautentica al usuario
      await user.reauthenticateWithCredential(credential);
      // Actualiza el correo electrónico
      await user.verifyBeforeUpdateEmail(newEmail);
      print("Correo electrónico actualizado con éxito en Firebase Auth.");
    } on FirebaseAuthException catch (e) {
      print("Error al actualizar el correo electrónico: $e");
      throw e;
    }
  }

  static Future<void>? updateName(String name) {
    try {
      final User? user = _firebaseAuth.currentUser;
      return user?.updateDisplayName(name);
    } catch (error) {
      print('Error al obtener el ID del usuario: $error');
      return null;
    }
  }

  static Future<void>? updatePhoto(String? photoURL) {
    try {
      final User? user = _firebaseAuth.currentUser;
      return user?.updatePhotoURL(photoURL);
    } catch (error) {
      print('Error al obtener el ID del usuario: $error');
      return null;
    }
  }
}
