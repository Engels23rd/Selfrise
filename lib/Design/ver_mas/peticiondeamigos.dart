import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:share_plus/share_plus.dart';

class peticiondeamigo extends StatefulWidget {
  const peticiondeamigo({super.key});

  @override
  State<peticiondeamigo> createState() => _peticiondeamigoState();
}

class _peticiondeamigoState extends State<peticiondeamigo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: CustomAppBar(titleText: "Petición de amigos", showBackButton: true,),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Text(
                  '¡Invita a tus amigos y crezcan juntos en Selfrise!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Text(
                  '¡Hola, amante del crecimiento personal!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: 340,
                child: Text(
                  "En Selfrise, creemos en el poder de la transformación personal y el autoconciencia. " +
                      "¿Por qué no compartes esta experiencia única con tus amigos y seres queridos? Invita a tus " +
                      "amigos a unirse a nosotros en este viaje hacia una vida más plena y satisfactoria.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: 340,
                child: Text(
                  "Imagina tener un espacio donde puedas explorar tus emociones, desarrollar nuevas habilidades " +
                      "y descubrir tu máximo potencial. ¡Eso es exactamente lo que ofrecemos en Selfrise!",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: 340,
                child: Text(
                  "¿Tienes amigos que podrían beneficiarse de meditaciones guiadas, ejercicios de mindfulness y " +
                      "recursos para el desarrollo personal? Entonces, ¡invítalos ahora mismo!",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: 340,
                child: Text(
                  "¡No esperes más! Haz clic en el botón (Invitar) a continuación y comienza a construir un futuro " +
                      "más brillante junto a tus amigos en Selfrise.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(50),
                child: ElevatedButton(
                  onPressed: () {
                    // Lógica para enviar invitaciones
                    invitaramigo();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.drawer,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    'Invitalos aqui',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void invitaramigo() async {
    // El enlace de descarga de la aplicación
    String enlaceDescarga = "https://www.selfrise.com";

    String texto = "¿Estás listo para embarcarte en un viaje hacia el crecimiento personal y el bienestar " +
        "emocional? En Selfrise, encontrarás un espacio seguro y acogedor donde podrás descubrir tu " +
        "potencial máximo y alcanzar una vida más plena y satisfactoria.\n" +
        "\n¡Únete a nuestra comunidad hoy mismo y comienza a explorar todo lo que tenemos para ofrecer! " +
        "Descarga la aplicación ahora y empieza tu camino hacia una versión mejor de ti mismo.\n " +
        "\n¡Te esperamos en Selfrise! ¡Descárgala ya debajo!\n \n$enlaceDescarga";

    Share.share("$texto", subject: '¡Hola!');
  }
}
