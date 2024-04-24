import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Design/menu_principal.dart';

class FirebaseAuthServ {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await _auth.currentUser;
  }

  Future<User?> SignUpPassAndEmail(String email, String password) async {
    if (password != null) {
      try {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        return credential.user;
      } catch (e) {
        print('Ha ocurrido un error');
      }
    }
    return null;
  }

  Future<User?> SignInPassAndEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException {}
    return null;
  }

  signInGoogle(BuildContext context) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Desconectar el usuario actual
      await firebaseAuth.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      UserCredential result =
          await firebaseAuth.signInWithCredential(credential);

      User? userDetails = result.user;

      Map<String, dynamic> userInfoMap = {
        'email': userDetails!.email,
        'name': userDetails.displayName,
        'imageLink': userDetails.photoURL,
        'id': userDetails.uid
      };
      
      await DataBase().addUser(userDetails.uid, userInfoMap).then((value) =>
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PantallaMenuPrincipal())));
        } catch (e) {
      print('Ocurrió un error durante la autenticación con Google: $e');
    }
  }
}
