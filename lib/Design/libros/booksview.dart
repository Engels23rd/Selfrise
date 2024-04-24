import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/components/favorite_provider.dart';
import 'package:flutter_proyecto_final/entity/AuthService.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart' as UniLinks;

import 'booksPage.dart';

class BookViewPage extends StatefulWidget {
  final ImageProvider<Object>? imageProvider;
  final PreferredSizeWidget? appBarCustom;
  final Book book;
  final String title;
  final String subtitle;
  final List<String> authors;
  final String publisher;
  final String publishedDate;
  final String description;

  BookViewPage({
    Key? key,
    required this.imageProvider,
    required this.title,
    required this.authors,
    required this.subtitle,
    required this.description,
    required this.publisher,
    required this.publishedDate,
    this.appBarCustom,
    required this.book,
  }) : super(key: key);

  @override
  State<BookViewPage> createState() => _BookViewPageState();
}

class _BookViewPageState extends State<BookViewPage> {
  late bool isFavorite = false;
  final Color baseColor = AppColors.drawer;

  void initState() {
    super.initState();
    initUniLinks();
    checkFavoriteStatus();
  }

  void checkFavoriteStatus() async {
    final provider = Provider.of<FavoriteProvider>(context, listen: false);
    final userId = AuthService.getUserId();
    if (userId != null) {
      final favorites = await provider.getFavorites(userId);
      print(favorites.length);
      setState(() {
        isFavorite = favorites.any((book) => book.id == widget.book.id);
      });
    } else {
      setState(() {
        isFavorite = false;
      });
    }
  }

  Future<void> initUniLinks() async {
    // Maneja el URI inicial
    handleInitialUri(await UniLinks.getInitialUri());
    // Escucha los enlaces entrantes
    UniLinks.linkStream.listen((uri) {
      if (uri != null) {
        // Maneja el enlace recibido
        handleUri(uri as Uri);
      }
    });
  }

  void handleInitialUri(Uri? uri) {
    if (uri != null) {
      // Realiza acciones basadas en el URI inicial
      print('URI inicial: $uri');
    }
  }

  void handleUri(Uri uri) {
    // Realiza acciones basadas en el URI recibido
    print('Nuevo URI: $uri');
  }

  @override
  Widget build(BuildContext context) {
    Future<void>? _launched;
    String url =
        'https://www.amazon.com/s?k=${widget.title}+${widget.subtitle}&i=stripbooks-intl-ship&ref=nb_sb_noss_2';

    final provider = Provider.of<FavoriteProvider>(context);
    final String? userId = AuthService.getUserId();
    return Scaffold(
      backgroundColor: baseColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: Color(0xFF2773B9),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Center(
            child: CustomAppBar(
              titleText: "Descripción del libro",
              showBackButton: true,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Imagen de fondo en la parte superior
                Container(
                  height: 250, // Altura de la imagen de fondo
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/imagenes/fondodelibros.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 250, // Misma altura que la imagen de fondo
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        baseColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top:
                          60), // Ajusta este valor para mover el contenido hacia abajo
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Contenedor para la imagen del libro y la información
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image(
                                image: widget.imageProvider ??
                                    AssetImage('assets/default_image.png'),
                                height: 180.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              widget.title,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              widget.subtitle,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              '- ${widget.authors.join(', ')}',
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              '${widget.publisher} - ${widget.publishedDate}',
                              style: TextStyle(
                                  fontSize: 10.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Descripción
                      SizedBox(
                        height: 150,
                        child: SingleChildScrollView(
                          child: Text(
                            widget.description,
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (userId != null) {
                                  provider.toggleFavorite(widget.book, userId);
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });
                                }
                              },
                              child: Text(isFavorite
                                  ? 'Remover de Favoritos'
                                  : 'Agregar a Favoritos'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor:
                                    Colors.white, // El color del texto
                                backgroundColor: isFavorite
                                    ? Colors.red
                                    : Colors.blue, // El color del botón
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  _launched = _launchInBrowser(url);
                                },
                                child: Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: true,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }
}
