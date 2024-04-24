
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/ver_mas/Acercadenosotros.dart';
import 'package:flutter_proyecto_final/Design/ver_mas/Licencias.dart';
import 'package:flutter_proyecto_final/Design/ver_mas/Terminosycondiciones.dart';
import 'package:flutter_proyecto_final/Design/ver_mas/peticiondeamigos.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/utils/ajustar_color_navigation_bar_icon.dart';

class Configuracion extends StatefulWidget {
  const Configuracion({super.key});

  @override
  State<Configuracion> createState() => _ConfiguracionState();
}



class _ConfiguracionState extends State<Configuracion> {

   void initState() {
    super.initState();
    ColorSystemNavitagionBar.setSystemUIOverlayStyleLight();
  }

   void dispose() {
    ColorSystemNavitagionBar.setSystemUIOverlayStyleDark();
    super.dispose();
  }
  
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
            child: CustomAppBar(titleText: "Ver más", showBackButton: true,),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 50, bottom: 50),
                child: Image.asset('assets/iconos/Selfrise + LOGO.png',
                    height: 200, width: 200)),
            GestureDetector(
              onTap: () {
                //FUNCIONES AQUIIIIII
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => peticiondeamigo(),
                  ),
                );
              },
              child: Container(
                width: 335,
                height: 70,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.drawer, width: 3)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.people_outline_rounded,
                      size: 35,
                      color: AppColors.drawer,
                    ),
                    const SizedBox(width: 20),
                    Container(
                      child: Text(
                        'Invita a tus amigos',
                        style: TextStyle(
                            fontSize: 23,
                            color: AppColors.drawer,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                //FUNCIONES AQUIIII
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => licencias(),
                  ),
                );
              },
              child: Container(
                width: 335,
                height: 70,
                margin: EdgeInsets.only(top: 20),
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.drawer, width: 3)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 3),
                      child: Icon(
                        Icons.import_contacts_outlined,
                        size: 35,
                        color: AppColors.drawer,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      child: Text(
                        'Licencias',
                        style: TextStyle(
                            fontSize: 23,
                            color: AppColors.drawer,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => acercade(),
                  ),
                );
              },
              child: Container(
                width: 335,
                height: 70,
                margin: EdgeInsets.only(top: 20),
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.drawer, width: 3)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.group,
                      size: 35,
                      color: AppColors.drawer,
                    ),
                    const SizedBox(width: 20),
                    Container(
                      child: Text(
                        'Acerca de nosotros',
                        style: TextStyle(
                            fontSize: 23,
                            color: AppColors.drawer,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => terminos(),
                  ),
                );
              },
              child: Container(
                width: 335,
                height: 70,
                margin: EdgeInsets.only(top: 20),
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.drawer, width: 3)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.description,
                      size: 35,
                      color: AppColors.drawer,
                    ),
                    const SizedBox(width: 20),
                    Container(
                      child: Text(
                        'Terminos y condiciones',
                        style: TextStyle(
                            fontSize: 23,
                            color: AppColors.drawer,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
