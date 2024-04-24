import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Importa el paquete de notificaciones locales
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_proyecto_final/Design/login/login.dart';
import 'package:flutter_proyecto_final/Design/login/slide_login.dart';
import 'package:flutter_proyecto_final/Design/menu_principal.dart';
import 'package:flutter_proyecto_final/Design/register.dart';
import 'package:flutter_proyecto_final/components/favorite_provider.dart';
import 'package:flutter_proyecto_final/components/profilProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();
  // Inicializa el complemento de notificaciones locales
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await AndroidAlarmManager.initialize();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  // Configura las opciones de inicialización según tus necesidades
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool seen = prefs.getBool('seen') ?? false;

  runApp(MyApp(seen: seen));
}

class MyApp extends StatelessWidget {
  final bool seen;
  const MyApp({Key? key, required this.seen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => UserDataProvider('', '', '')),
        // Agrega más providers si es necesario
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SelfRise',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        home: seen ? LoginPage() : SlideLogin(),
        routes: {
          '/menu_principal': (context) => const PantallaMenuPrincipal(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegistroScreen(),
        },
      ),
    );
  }
}
