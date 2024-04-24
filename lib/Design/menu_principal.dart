import 'dart:async';
import 'dart:math';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Design/drawer_menu.dart';
import 'package:flutter_proyecto_final/Design/evaluaciones/evaluacion_screen.dart';
import 'package:flutter_proyecto_final/Design/profilepage.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/components/buttons.dart';
import 'package:flutter_proyecto_final/services/AuthService.dart';
import 'package:flutter_proyecto_final/utils/ajustar_color_navigation_bar_icon.dart';
import 'package:rive/rive.dart';
import 'package:share_plus/share_plus.dart';
import '../Colors/colors.dart';
import '../services/frases_motivacionales.dart';
import './chat.dart';
import 'habitos/habitos.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_proyecto_final/components/rive_utils.dart';

class PantallaMenuPrincipal extends StatefulWidget {
  const PantallaMenuPrincipal({Key? key}) : super(key: key);

  @override
  _PantallaMenuPrincipalState createState() => _PantallaMenuPrincipalState();
}

class _PantallaMenuPrincipalState extends State<PantallaMenuPrincipal>
    with SingleTickerProviderStateMixin {
  late SMIBool isSideBarClosed;
  bool isSideMenuClose = true;
  bool _isKeyboardVisible = false;

  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scalAnimation;

  int _selectedTab = 0;
  // ignore: unused_field
  late String _nombreUsuario = '';

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });

    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
    obtenerNombreUsuario();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> obtenerNombreUsuario() async {
    final nombre = await AuthService.getUserName();
    setState(() {
      _nombreUsuario = nombre ?? 'Usuario';
    });
  }

  final List<Widget> _pages = [
    PantallaPrincipal(),
    PantallaChat(),
    EvaluationScreen(),
    PantallaSeguimientoHabitos(),
    ProfileSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Deshabilitar las gestos de retroceso del sistema
      onPopInvoked: (bool didPop) {
        // Este callback se llama cuando se invoca un gesto de retroceso del sistema
        // didPop indica si el gesto de retroceso tuvo éxito o no
        print('Se invocó un gesto de retroceso del sistema: $didPop');
      },
      child: Scaffold(
        backgroundColor: AppColors.drawer,
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              width: 288,
              left: isSideMenuClose ? -288 : 0,
              height: MediaQuery.of(context).size.height,
              child: DrawerMenu(),
            ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(animation.value - 30 * animation.value * pi / 180),
              child: Transform.translate(
                offset: Offset(animation.value * 265, 0),
                child: Transform.scale(
                  scale: scalAnimation.value,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      child: _pages[_selectedTab]),
                ),
              ),
            ),

            // Button animado
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              left: isSideMenuClose ? 0 : 220,
              top: 12,
              child: menubtn(
                riveOnInit: (artboard) {
                  StateMachineController controller =
                      RiveUtils.getRiveController(artboard,
                          stateMachineName: "Morph");
                  isSideBarClosed = controller.findSMI("Boolean 1") as SMIBool;
                  isSideBarClosed.value = true;
                },
                press: () {
                  isSideBarClosed.value = !isSideBarClosed.value;
                  if (isSideMenuClose) {
                    _animationController.forward();
                    ColorSystemNavitagionBar.setSystemUIOverlayStyleDark();
                  } else {
                    _animationController.reverse();
                    ColorSystemNavitagionBar.setSystemUIOverlayStyleLight();
                  }
                  setState(() {
                    isSideMenuClose = isSideBarClosed.value;
                  });
                },
              ),
            ),

            // Barra de navegación curvada
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: _isKeyboardVisible
                    ? Offset(1000, 150 * animation.value)
                    : Offset(0, 150 * animation.value),
                child: CurvedNavigationBar(
                  index: _selectedTab,
                  height: 50,
                  items: _construirNavigationBarItems(),
                  backgroundColor: Colors.transparent,
                  color: Color(0xFF2773B9), // Cambia esto al color que desees
                  animationDuration: const Duration(milliseconds: 300),
                  onTap: (int index) {
                    setState(() {
                      _selectedTab = index;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _construirNavigationBarItems() {
    return [
      Icons.home,
      Icons.chat,
      Icons.assignment,
      Icons.directions_run,
      Icons.person,
    ].map((icon) => _construirNavigationBarItem(icon)).toList();
  }

  Widget _construirNavigationBarItem(IconData icon) {
    return Icon(icon, size: 30, color: Colors.white);
  }
}

class PantallaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PantallaPrincipalContent(),
    );
  }
}

class PantallaPrincipalContent extends StatefulWidget {
  @override
  _PantallaPrincipalContentState createState() =>
      _PantallaPrincipalContentState();
}

class _PantallaPrincipalContentState extends State<PantallaPrincipalContent> {
  late Map<String, dynamic> _fraseAleatoria = {};

  @override
  void initState() {
    super.initState();
    _obtenerFraseAleatoria();
    Timer.periodic(Duration(hours: 24), (timer) {
      _obtenerFraseAleatoria();
    });
  }

  Future<void> _obtenerFraseAleatoria() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? fraseGuardada = prefs.getString('frase');
      final String? autorGuardado = prefs.getString('autor');
      final String? fechaGuardada = prefs.getString('fecha');

      if (fraseGuardada != null &&
          autorGuardado != null &&
          fechaGuardada != null) {
        final DateTime fechaObtenida = DateTime.parse(fechaGuardada);
        final DateTime fechaActual = DateTime.now();

        if (fechaActual.difference(fechaObtenida).inDays < 1) {
          setState(() {
            _fraseAleatoria = {
              'frase': fraseGuardada,
              'autor': autorGuardado,
            };
          });
          return;
        }
      }
      Map<String, dynamic> frase =
          await FrasesMotivacionales.obtenerFraseAleatoria();
      await prefs.setString('frase', frase['frase']);
      await prefs.setString('autor', frase['autor']);
      await prefs.setString('fecha', DateTime.now().toIso8601String());

      setState(() {
        _fraseAleatoria = frase;
      });
    } catch (error) {
      print(error);
    }
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
            child: CustomAppBar(titleText: "Inicio"),
          ),
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          FutureBuilder<String?>(
            future: AuthService.getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              final userName = snapshot.data ?? 'Usuario';
              return _construirTextoBienvenida(userName);
            },
          ),
          _construirTextoSentimientos(),
          _construirFilaIconosSentimientos(),
          const Text(
            'Frase de hoy',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          if (_fraseAleatoria['frase'] != null)
            Container(
              child: _construirFraseDelDia(
                  _fraseAleatoria['frase'], _fraseAleatoria['autor']),
            ),
        ],
      ),
    );
  }

  Widget _construirTextoBienvenida(String userName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        '¡Hola, $userName!',
        style: TextStyle(
          fontSize: 25,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  Widget _construirTextoSentimientos() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Text(
        '¿Cómo te sientes hoy?',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  Widget _construirIconoConTexto(String nombreAsset, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/iconos/$nombreAsset',
            width: 50,
            height: 50,
          ),
          const SizedBox(height: 5),
          Text(
            texto,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _construirFilaIconosSentimientos() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _construirIconoConTexto('feliz.gif', 'Feliz'),
          _construirIconoConTexto('angel.gif', 'Tranquilo'),
          _construirIconoConTexto('triste.gif', 'Triste'),
          _construirIconoConTexto('neutral.gif', 'Neutral'),
          _construirIconoConTexto('enojado.gif', 'Enojado'),
        ],
      ),
    );
  }

  Widget _construirFraseDelDia(String fraseDelDia, String autor) {
    if (fraseDelDia.isEmpty || autor.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(20),
        ),
      );
    }

    return SizedBox(
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          decoration: BoxDecoration(
            color: AppColors.darkGray,
            borderRadius: BorderRadius.circular(
                20), // Ajusta el radio de borde según sea necesario
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                fraseDelDia,
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "-$autor",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 98, 168, 233),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    EdgeInsets.all(0), // Ajusta el padding según sea necesario
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2773B9), // Cambia el color del círculo aquí
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    _compartirFrase(fraseDelDia, autor);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _compartirFrase(String texto, String autor) {
    Share.share("$texto\n-$autor", subject: 'Compartir frase del día');
  }
}

void signOutFromGoogle() async {
  GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
}
