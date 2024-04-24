import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login/login.dart';
import 'menu_principal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return PantallaMenuPrincipal();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Ha ocurrido un error'),
                );
              } else {
                return LoginPage();
              }
            }),
      );
}
