import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/utils/ajustar_color_navigation_bar_icon.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PsicologosScreen extends StatefulWidget {
  const PsicologosScreen({Key? key}) : super(key: key);

  @override
  State<PsicologosScreen> createState() => MapSampleState();
}

class MapSampleState extends State<PsicologosScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  void initState() {
    super.initState();
    ColorSystemNavitagionBar.setSystemUIOverlayStyleLight();
  }

  void dispose() {
    ColorSystemNavitagionBar.setSystemUIOverlayStyleDark();
    super.dispose();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(18.4898366, -69.838963),
    zoom: 12,
  );

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('consultorio1'),
      position: LatLng(18.5099641, -69.9050193),
      infoWindow:
          InfoWindow(title: 'Consultorio Psicológico de la Rosa Corcino'),
    ),
    Marker(
      markerId: MarkerId('consultorio2'),
      position: LatLng(18.5001007, -69.8381881),
      infoWindow: InfoWindow(title: 'Centro de Psicologia Soridelos'),
    ),
    Marker(
      markerId: MarkerId('consultorio3'),
      position: LatLng(18.5106463, -69.848211),
      infoWindow: InfoWindow(title: 'Ápice Centro De Desarrollo Integral'),
    ),
    Marker(
      markerId: MarkerId('consultorio4'),
      position: LatLng(18.4919568, -69.859933),
      infoWindow: InfoWindow(title: 'CIADIF'),
    ),
    Marker(
      markerId: MarkerId('consultorio5'),
      position: LatLng(18.4897377, -69.8627122),
      infoWindow:
          InfoWindow(title: 'Eva Barreiro, Psicóloga infantil y juvenil'),
    ),
  };

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
            child: CustomAppBar(
              titleText: "Psícologos del país",
              showBackButton: true,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
          ),
        ],
      ),
    );
  }
}
