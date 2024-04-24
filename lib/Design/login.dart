import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/components/inputs.dart';
import 'package:flutter_proyecto_final/services/database.dart';
import 'package:flutter_proyecto_final/services/firebase_auth.dart';
import '../Colors/colors.dart';
import '../components/buttons.dart';
import '../components/loginwith.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthServ _auth = FirebaseAuthServ();
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/imagenes/ingre_regis.png',
            fit: BoxFit.fill,
          ),
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      'assets/iconos/Selfriselogoblanco.png',
                      width: 124,
                      height: 124,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Bienvenido a tu nueva vida',
                      style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InputsLogin(
                      controller: emailController,
                      hinttxt: 'Correo electrónico',
                      obscuretxt: false,
                      icono: Icons.alternate_email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor introduce el correo';
                        } else if (!isValidEmail(value)) {
                          return 'Introduce un correo electrónico válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputsLogin(
                      controller: passwordController,
                      hinttxt: 'Contraseña',
                      obscuretxt: true,
                      icono: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor introduce la contraseña';
                        } else if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: GestureDetector(
                        onTap: () {
                          FirebaseAuth.instance.sendPasswordResetEmail(
                              email: emailController.text);
                        },
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ButtonsLogin(
                      ontap: signInUser,
                      txt: 'Ingresar',
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'O continua con',
                            style: TextStyle(
                              color: Colors.grey[350],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loginwith(
                          text: "Logueate con google",
                          route: 'assets/iconos/google.png',
                          onTap: () {
                            _auth.signInGoogle(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿No tienes una cuenta todavía?',
                          style: TextStyle(
                            color: Colors.grey[350],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistroScreen()),
                            );
                          },
                          child: const Text(
                            'Regístrate ahora',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void signInUser() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;

      try {
        // Verificar si el usuario existe en la base de datos
        bool userExists = await checkIfUserExists(email);
        if (!userExists) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              'No existe un usuario con este email',
              style: TextStyle(fontSize: 18),
            ),
          ));
          return; // Salir del método si el usuario no existe
        }

        // Autenticar al usuario
        await _auth.SignInPassAndEmail(email, password);
        Navigator.pushNamed(context, '/menu_principal');
        emailController.clear();
        passwordController.clear();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              'Contraseña incorrecta',
              style: TextStyle(fontSize: 18),
            ),
          ));
        }
      }
    }
  }

  bool isValidEmail(String email) {
    // Simple regex for email validation
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
