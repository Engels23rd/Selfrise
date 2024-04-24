import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/libros/booksPage.dart';
import 'package:flutter_proyecto_final/Design/libros/favoriteBooks.dart';
import 'package:flutter_proyecto_final/components/favorite_provider.dart';
import 'package:flutter_proyecto_final/entity/AuthService.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget {
  final String titleText;
  final bool showBackButton;
  final IconData? icon;

  CustomAppBar({
    required this.titleText,
    this.showBackButton = false,
    this.icon,
  });

  final Map<String, double> textToPadding = {
    "Mis hábitos": 30,
    "Psícologos del país": 40,
    "Podcasts": 50,
    "Configuración": 50,
    "Petición de amigos": 50,
    "Licencias": 50,
    "Acerca de nosotros": 50,
    "Términos y condiciones": 50,
    "Evaluación": 50,
    "Evaluación de autoestima": 40,
    "Ver más": 40
  };

  @override
  Widget build(BuildContext context) {
    double customPadding = titleText == 'Perfil' ? 0 : 15;

    final double rightPadding =
        textToPadding.containsKey(titleText) ? textToPadding[titleText]! : 0;

    final String? currentUserId = AuthService.getUserId();
    final bool isBookTitle = titleText.toLowerCase().contains('libros') ||
        titleText.toLowerCase().contains('libro');
    return AppBar(
      backgroundColor: Color(0xFF2773B9),
      automaticallyImplyLeading: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(customPadding),
          bottomRight: Radius.circular(customPadding),
        ),
      ),
      shadowColor: Color(0xFF000000).withOpacity(1),
      title: Container(
        padding: EdgeInsets.only(
            top: 35), // Modificar el padding según el texto del título
        alignment: Alignment.center,
        child: Stack(
          children: [
            // Título
            Center(
              // Centra el título
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (showBackButton)
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 50), // Ajusta este valor según sea necesario
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                        iconSize: 30,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  Expanded(
                    child: Container(
                      alignment: icon == null
                          ? Alignment.center
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom:
                              50, // Ajusta el padding vertical según sea necesario
                          right:
                              rightPadding, // Ajusta el padding derecho según el texto
                        ),
                        child: Text(
                          titleText,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (icon != null)
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 50), // Ajusta el relleno según sea necesario
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),

                  // Agregar el icono y el contador si el título contiene la palabra "libro"
                  // Agregar el icono y el contador si el título contiene la palabra "libro"
                  if (isBookTitle)
                    Container(
                      margin: EdgeInsets.only(
                          bottom: 50), // Establece el margen deseado
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.bookmark_border,
                              size: 30,
                            ),
                            color: Colors.white,
                            onPressed: () {
                              // Lógica al presionar el icono de favoritos
                              final route = MaterialPageRoute(
                                builder: ((context) => const FavoritePage()),
                              );
                              Navigator.push(context, route);
                            },
                          ),
                          Positioned(
                            bottom: 25,
                            right:
                                5, // Ajusta la posición vertical según tus preferencias
                            child: Consumer<FavoriteProvider>(
                              builder: (context, provider, _) {
                                return FutureBuilder<List<Book>>(
                                  future: provider.getFavorites(currentUserId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    } else if (snapshot.hasError) {
                                      return Container();
                                    } else {
                                      final List<Book> favoriteBooks =
                                          snapshot.data ?? [];
                                      return Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: AppColors.drawer,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${favoriteBooks.length}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
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
    );
  }
}
