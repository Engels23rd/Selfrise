import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';


class acercade extends StatefulWidget {
  const acercade({super.key});

  @override
  State<acercade> createState() => _acercadeState();
}

class _acercadeState extends State<acercade> {
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
            child: CustomAppBar(titleText: "Acerca de nosotros", showBackButton: true,),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "Acerca de Selfrise",
                  style: TextStyle(
                      fontSize: 25,
                      color: AppColors.drawer,
                      fontWeight: FontWeight.bold),
                )),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: 250,
              child: Divider(
                thickness: 2,
                color: AppColors.drawer,
              ),
            ),
            Container(
                width: 320,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "En Selfrise, creemos en el poder de la autoexploración y el autodesarrollo para transformar vidas. " +
                      "Nuestra plataforma está diseñada para ser un espacio seguro y acogedor donde las personas puedan " +
                      "embarcarse en un viaje de crecimiento personal y bienestar emocional.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                )),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "Nuestra Misión",
                  style: TextStyle(
                      fontSize: 25,
                      color: AppColors.drawer,
                      fontWeight: FontWeight.bold),
                )),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: 250,
              child: Divider(
                thickness: 2,
                color: AppColors.drawer,
              ),
            ),
            Container(
                width: 320,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "Nuestra misión es proporcionar herramientas y recursos accesibles que empoderen a individuos " +
                      "de todas partes del mundo para que descubran su potencial máximo y alcancen una vida más " +
                      "plena y satisfactoria. Creemos en la importancia de la autenticidad, la compasión y el " +
                      "crecimiento continuo en el camino hacia el autodescubrimiento.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                )),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "Lo Que Ofrecemos",
                  style: TextStyle(
                      fontSize: 25,
                      color: AppColors.drawer,
                      fontWeight: FontWeight.bold),
                )),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: 250,
              child: Divider(
                thickness: 2,
                color: AppColors.drawer,
              ),
            ),
            Container(
                width: 320,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "En Selfrise, ofrecemos una variedad de recursos, incluyendo meditaciones guiadas, ejercicios " +
                      "de mindfulness, técnicas de respiración, cursos de desarrollo personal y mucho más. Nuestro " +
                      "equipo está comprometido a proporcionar contenido de alta calidad que sea fácilmente " +
                      "accesible y adaptable a las necesidades individuales de cada usuario.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                )),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "Nuestro Equipo",
                  style: TextStyle(
                      fontSize: 25,
                      color: AppColors.drawer,
                      fontWeight: FontWeight.bold),
                )),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: 250,
              child: Divider(
                thickness: 2,
                color: AppColors.drawer,
              ),
            ),
            Container(
                width: 320,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "Detrás de Selfrise hay un equipo diverso de profesionales apasionados por el bienestar mental " +
                      "y emocional. Nuestros expertos en psicología, desarrollo personal y tecnología trabajan " +
                      "incansablemente para asegurar que nuestra plataforma ofrezca experiencias enriquecedoras y " +
                      "transformadoras para nuestros usuarios.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                )),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "Únete a Nosotros",
                  style: TextStyle(
                      fontSize: 25,
                      color: AppColors.drawer,
                      fontWeight: FontWeight.bold),
                )),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: 250,
              child: Divider(
                thickness: 2,
                color: AppColors.drawer,
              ),
            ),
            Container(
                width: 320,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "Te invitamos a unirte a la comunidad de Selfrise y embarcarte en un viaje de " +
                      "autodescubrimiento y crecimiento personal. Juntos, podemos trabajar hacia un mundo donde cada " +
                      "individuo pueda florecer y prosperar en su vida diaria.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                )),
            Container(
                alignment: Alignment.center,
                width: 350,
                margin: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  "¡¡¡Gracias por ser parte de la familia Selfrise!!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.drawer,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}
