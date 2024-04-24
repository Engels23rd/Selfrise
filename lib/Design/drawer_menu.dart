import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/ver_mas/Configuracion.dart';
import 'package:flutter_proyecto_final/Design/libros/booksPage.dart';
import 'package:flutter_proyecto_final/Design/menu_principal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_proyecto_final/Design/podcast/podcastpage.dart';
import 'package:flutter_proyecto_final/Design/psicologo/psicologos.dart';
import 'package:flutter_proyecto_final/Design/habitos/ver_habitos.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: 288,
          height: double.infinity,
          color: AppColors.drawer,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 16),
              child: const InfoCard(),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, bottom: 10),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, bottom: 0),
                child: Text("Explorar".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.white_trans)),
              ),
            ),
            //    ***** BOTON PSICOLOGO ******
            Container(
              //LEFT, TOP, RIGHT, BOTTOM
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      color: AppColors.linecolor,
                      height: 1,
                    ),
                  ),
                  Container(
                    //LEFT, TOP, RIGHT, BOTTOM
                    margin: EdgeInsets.fromLTRB(5, 9, 5, 0),
                    child: Stack(
                      children: [
                        ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PsicologosScreen(), // Aquí se crea la instancia de BookListScreen
                                ),
                              );
                            },
                            leading: SizedBox(
                              height: 34,
                              width: 34,
                              child:
                                  Image.asset("assets/icon-menu/psicologo.png"),
                            ),
                            title: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "Psicologo",
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //   ***** FINAL BOTON PSICOLOGO *****
            //   ***** BOTON LIBROS ******
            Container(
              //LEFT, TOP, RIGHT, BOTTOM
              margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      color: AppColors.linecolor,
                      height: 1,
                    ),
                  ),
                  Container(
                    //LEFT, TOP, RIGHT, BOTTOM
                    margin: EdgeInsets.fromLTRB(5, 9, 5, 0),
                    child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookListScreen(), // Aquí se crea la instancia de BookListScreen
                            ),
                          );
                        },
                        leading: SizedBox(
                          height: 34,
                          width: 34,
                          child: Image.asset("assets/icon-menu/libros.png"),
                        ),
                        title: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Libros",
                            style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            //   ***** FINAL BOTON LIBROS *****
            //   ***** BOTON PODCAST ******
            Container(
              //LEFT, TOP, RIGHT, BOTTOM
              margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      color: AppColors.linecolor,
                      height: 1,
                    ),
                  ),
                  Container(
                    //LEFT, TOP, RIGHT, BOTTOM
                    margin: EdgeInsets.fromLTRB(5, 9, 5, 0),
                    child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PodcastPage(), // Aquí se crea la instancia de BookListScreen
                            ),
                          );
                        },
                        leading: SizedBox(
                          height: 34,
                          width: 34,
                          child: Image.asset("assets/icon-menu/podcast.png"),
                        ),
                        title: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Podcast",
                            style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            //   ***** FINAL BOTON PODCAST *****
            //   ***** BOTON NUTRICION ******
            Container(
              //LEFT, TOP, RIGHT, BOTTOM
              margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      color: AppColors.linecolor,
                      height: 1,
                    ),
                  ),
                  Container(
                    //LEFT, TOP, RIGHT, BOTTOM
                    margin: EdgeInsets.fromLTRB(5, 9, 5, 0),
                    child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerHabitosScreen()),
                          );
                        },
                        leading: SizedBox(
                          height: 35,
                          width: 35,
                          child: Image.asset("assets/icon-menu/habits.png"),
                        ),
                        title: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Hábitos",
                            style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            //   ***** FINAL BOTON NUTRICION *****

            Container(
              margin: EdgeInsets.only(left: 10, bottom: 4, top: 15),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 32, bottom: 0),
                child: Text("Mas Opciones".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.white_trans)),
              ),
            ),

            //   ***** BOTON CONFIGURACION ******
            Container(
              //LEFT, TOP, RIGHT, BOTTOM
              margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      color: AppColors.linecolor,
                      height: 1,
                    ),
                  ),
                  Container(
                    //LEFT, TOP, RIGHT, BOTTOM
                    margin: EdgeInsets.fromLTRB(5, 9, 5, 0),
                    child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Configuracion()),
                          );
                        },
                        leading: SizedBox(
                          height: 34,
                          width: 34,
                          child:
                              Image.asset("assets/icon-menu/mas-opciones.png"),
                        ),
                        title: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Ver más",
                            style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            //   ***** FINAL BOTON CONFIGURACION *****
            //   ***** BOTON SALIR ******
            Container(
              //LEFT, TOP, RIGHT, BOTTOM
              margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      color: AppColors.linecolor,
                      height: 1,
                    ),
                  ),
                  Container(
                    //LEFT, TOP, RIGHT, BOTTOM
                    margin: EdgeInsets.fromLTRB(5, 9, 5, 0),
                    child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          signOutFromGoogle();
                          Navigator.pushNamed(context, '/login');
                        },
                        leading: SizedBox(
                          height: 34,
                          width: 34,
                          child: Image.asset("assets/icon-menu/salir.png"),
                        ),
                        title: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Salir",
                            style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            //   ***** FINAL BOTON SALIR *****
          ]),
        ),
      ),
    );
  }
}

//INFORMACION DEL USUARIO
class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: AuthService.getUserData(AuthService.getUserId()),
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasError || snapshot.data == null) {
            return Text('Error al obtener los datos del usuario');
          } else {
            final userData = snapshot.data!;
            final name = userData['name'] ?? 'Nombre de usuario no disponible';
            final photoUrl = userData['imageLink'];
            final email = userData['email'];
            return Padding(
              padding: const EdgeInsets.only(
                  top:
                      40.0), // Ajusta el valor del margen inferior según sea necesario
              child: ListTile(
                leading: ClipOval(
                  child: CircleAvatar(
                    backgroundColor: AppColors.white_trans,
                    radius: 25,
                    child: photoUrl != null
                        ? Image.network(
                            photoUrl,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          )
                        : Icon(Icons.account_circle),
                  ),
                ),
                title: Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                subtitle: Text(
                  email,
                  style: TextStyle(fontSize: 10),
                ),
                textColor: AppColors.white,
              ),
            );
          }
        }
      },
    );
  }
}
