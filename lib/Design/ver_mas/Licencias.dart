import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';

class licencias extends StatefulWidget {
  const licencias({super.key});

  @override
  State<licencias> createState() => _licenciasState();
}

class _licenciasState extends State<licencias> {
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
            child: CustomAppBar(titleText: "Licencias", showBackButton: true,),
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
                  "Licencia de Uso",
                  style: TextStyle(
                      fontSize: 20,
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
                  "Selfrise es una plataforma en línea diseñada para proporcionar recursos y herramientas de " +
                      "autoayuda y bienestar emocional. Todos los materiales, contenido y recursos disponibles en " +
                      "Selfrise están protegidos por derechos de autor y son propiedad de Selfrise y/o sus colaboradores.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                )),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "Uso Personal",
                  style: TextStyle(
                      fontSize: 20,
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
                  "El acceso a Selfrise y el uso de sus recursos están destinados únicamente para uso personal y " +
                      "no comercial. Los usuarios tienen derecho a acceder y utilizar el contenido proporcionado en " +
                      "Selfrise para su propio beneficio y desarrollo personal.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                )),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "Restricciones de Uso",
                  style: TextStyle(
                      fontSize: 20,
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
                  "Queda estrictamente prohibida la reproducción, distribución, modificación, o cualquier otro " +
                      "uso no autorizado del contenido disponible en Selfrise. Cualquier violación de estos términos " +
                      "puede resultar en acciones legales conforme a las leyes de derechos de autor y propiedad intelectual.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                )),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "Derechos de Autor",
                  style: TextStyle(
                      fontSize: 20,
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
                  "Todos los derechos de autor y propiedad intelectual sobre el contenido de Selfrise son " +
                      "propiedad de Selfrise y/o sus colaboradores, a menos que se indique lo contrario. Se prohíbe " +
                      "la reproducción no autorizada o el uso no autorizado de cualquier contenido sin el " +
                      "consentimiento expreso por escrito de Selfrise.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                )),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "Renuncia de Responsabilidad",
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.drawer,
                      fontWeight: FontWeight.bold),
                )),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: 300,
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
                  "Selfrise no se hace responsable por el uso indebido o inadecuado del contenido proporcionado " +
                      "en la plataforma. Los usuarios son responsables de su propia interpretación y aplicación del " +
                      "contenido y deben buscar asesoramiento profesional si así lo requieren.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                )),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "Cambios en la Licencia",
                  style: TextStyle(
                      fontSize: 20,
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
                  "Selfrise se reserva el derecho de actualizar, modificar o cambiar los términos de esta " +
                      "licencia en cualquier momento y sin previo aviso. Se alienta a los usuarios a revisar " +
                      "periódicamente estos términos para estar al tanto de cualquier cambio.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                )),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "Contacto",
                  style: TextStyle(
                      fontSize: 20,
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
                margin: EdgeInsets.only(top: 15, bottom: 40),
                child: Text(
                  "Si tienes alguna pregunta o inquietud sobre la licencia de uso de Selfrise, no dudes en " +
                      "ponerte en contacto con nosotros a través de la información de contacto proporcionada en la plataforma.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                )),
          ],
        ),
      ),
    );
  }
}
