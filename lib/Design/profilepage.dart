import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';
import 'package:flutter_proyecto_final/components/profilProvider.dart';
import 'dart:typed_data';
import 'package:flutter_proyecto_final/entity/AuthService.dart';
import 'package:flutter_proyecto_final/components/pickerImage.dart';
import 'package:flutter_proyecto_final/utils/ajustar_brillo_color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  bool _isEditingText = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Uint8List? image;

  void _toggleEditing(bool isEditing) {
    setState(() {
      _isEditingText = isEditing;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAndSetUserInfo();
  }

  Future<void> fetchAndSetUserInfo() async {
    final userData =
        await AuthService.getUserData(FirebaseAuth.instance.currentUser?.uid);
    final imageUrl = userData?['imageLink'];
    final name = userData?['name'];
    final email = userData?['email'];

    if (imageUrl != null && name != null && email != null) {
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      userDataProvider.setImageUrl(imageUrl);
      userDataProvider.setNombre(name);
      userDataProvider.setCorreo(email);
    }
  }

  Future<bool> requestPermissions() async {
    // Solicita los permisos y espera el resultado
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    // Verifica si todos los permisos fueron concedidos
    bool allPermissionsGranted =
        statuses.values.every((status) => status == PermissionStatus.granted);

    return allPermissionsGranted;
  }

// En tu función donde quieres solicitar permisos y seleccionar una imagen
  void trySelectImage() async {
    // Asegúrate de que todos los permisos fueron concedidos
    bool permissionsGranted = await requestPermissions();
    if (permissionsGranted) {
      // Todos los permisos fueron concedidos, procede a seleccionar la imagen
      selectImage();
    } else {
      // Maneja el caso donde no todos los permisos fueron concedidos
      // Por ejemplo, mostrando un diálogo al usuario explicando por qué necesitas los permisos
      print("No se concedieron todos los permisos necesarios.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);

    final bool isSignedInWithGoogle = FirebaseAuth
            .instance.currentUser?.providerData
            .any((userInfo) => userInfo.providerId == 'google.com') ??
        false;

    return FutureBuilder<Map<String, dynamic>?>(
      future: AuthService.getUserData(AuthService.getUserId()),
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        } else {
          if (snapshot.hasError || snapshot.data == null) {
            return Text('Error al obtener los datos del usuario');
          } else {
            final userData = snapshot.data!;
            final name = userData['name'] ?? 'Nombre de usuario no disponible';
            final photoUrl = userData['imageLink'];
            final email = userData['email'];
            nameController.text =
                name; // Establecer el nombre actual como el valor inicial
            emailController.text =
                email; // Establecer el correo electrónico actual como el valor inicial

            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(80.0),
                child: Container(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  decoration: BoxDecoration(
                    color: Color(0xFF2773B9),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                  child: Center(
                    child: CustomAppBar(titleText: "Perfil"),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Container(
                          height: 120.0,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2773B9),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.elliptical(800.0, 120.0),
                              bottomRight: Radius.elliptical(800.0, 120.0),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -40.0, // Ajusta según sea necesario
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage:
                                Provider.of<UserDataProvider>(context)
                                            .imageUrl !=
                                        null
                                    ? NetworkImage(
                                        Provider.of<UserDataProvider>(context)
                                            .imageUrl!)
                                    : null,
                            child:
                                isSignedInWithGoogle // Condición basada en si el usuario inició sesión con Google
                                    ? Container(
                                        // Si es usuario de Google, muestra el ícono sin GestureDetector
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors
                                              .black45, // Fondo semi-transparente para el ícono
                                        ),
                                        child: const Icon(
                                          Icons.add_a_photo_rounded,
                                          color: Color.fromARGB(
                                              160, 255, 255, 255),
                                          size: 32,
                                        ),
                                      )
                                    : GestureDetector(
                                        // Si no es usuario de Google, permite clickear el ícono
                                        onTap: trySelectImage,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors
                                                .black45, // Fondo semi-transparente para el ícono
                                          ),
                                          child: const Icon(
                                            Icons.add_a_photo_rounded,
                                            color: Color.fromARGB(
                                                160, 255, 255, 255),
                                            size: 32,
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 100.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            width: 300,
                            child: TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 3),
                                  labelText: 'Nombre',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: name,
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              readOnly: isSignedInWithGoogle,
                              onChanged: (newValue) {
                                userDataProvider.setNombre(newValue);
                              },
                            ),
                          ),
                          SizedBox(height: 25.0),
                          Container(
                            width: 300,
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 3),
                                  labelText: 'Correo',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: email,
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              readOnly: isSignedInWithGoogle,
                              onChanged: (newValue) {
                                // Actualiza el nombre en el provider cuando el usuario modifica el texto
                                userDataProvider.setNombre(newValue);
                              },
                            ),
                          ),
                        ],
                      ),
                    ), //aqui
                    SizedBox(height: 40.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xFF2773B9),
                                shape: StadiumBorder(),
                              ),
                              onPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.infoReverse,
                                  dialogBackgroundColor: Colors.transparent,
                                  headerAnimationLoop: true,
                                  animType: AnimType.bottomSlide,
                                  title: '  Cambiar datos del usuario',
                                  titleTextStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  reverseBtnOrder: true,
                                  btnOkOnPress: () {
                                    // Muestra un diálogo para que el usuario confirme su contraseña
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.infoReverse,
                                      animType: AnimType.bottomSlide,
                                      title: 'Confirmación',
                                      desc:
                                          'Por favor, confirma tu contraseña actual para actualizar tus datos.',
                                      body: Column(
                                        children: <Widget>[
                                          Text(
                                            'Para asegurar tu cuenta, ingresa tu contraseña actual antes de actualizar tus datos.',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(height: 20),
                                          TextField(
                                            controller:
                                                passwordController, // Controlador para el campo de contraseña
                                            obscureText:
                                                true, // Asegura que el texto esté oculto
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Contraseña Actual',
                                            ),
                                          ),
                                        ],
                                      ),
                                      btnOkOnPress: () async {
                                        // Verifica si el usuario ha ingresado nuevos datos
                                        String newName =
                                            nameController.text.trim();
                                        String newEmail =
                                            emailController.text.trim();
                                        String currentPassword =
                                            passwordController.text.trim();

                                        try {
                                          if (newName.isNotEmpty) {
                                            // Actualiza el nombre en Firestore
                                            await updateNameInFirestore(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                newName);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Nombre actualizado con éxito.")));
                                          }

                                          if (newEmail.isNotEmpty) {
                                            // Proceso para actualizar el correo electrónico
                                            AuthCredential credential =
                                                EmailAuthProvider.credential(
                                                    email: FirebaseAuth.instance
                                                        .currentUser!.email!,
                                                    password: currentPassword);

                                            // Reautentica al usuario con sus credenciales actuales
                                            await FirebaseAuth
                                                .instance.currentUser!
                                                .reauthenticateWithCredential(
                                                    credential);

                                            // Actualiza el correo electrónico en Firebase Auth y envía verificación
                                            await FirebaseAuth
                                                .instance.currentUser!
                                                .verifyBeforeUpdateEmail(
                                                    newEmail);
                                            await updateEmailInFirestore(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                newEmail);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Correo electrónico actualizado. Por favor verifica tu nuevo correo.")));
                                          }
                                        } catch (e) {}
                                      },
                                      btnCancelOnPress: () {},
                                    ).show();
                                  },
                                  btnCancelOnPress: () {},
                                  desc:
                                      "¿Estás seguro que quieres actualizar los datos del usuario?",
                                  descTextStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  btnOkText: 'Aceptar',
                                  btnCancelText: 'Cancelar',
                                ).show();
                              },
                              child: Text(
                                'Guardar',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
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
      },
    );
  }

  void selectImage() async {
    Uint8List? img = await pickerImage(ImageSource.gallery);
    if (img != null) {
      // Sube la imagen a Firebase Storage y obtén la URL.
      String? imageUrl = await uploadImageToFirebaseStorage(img);
      if (imageUrl != null) {
        // Obtiene la instancia del provider y actualiza la URL de la imagen.
        final userDataProvider =
            Provider.of<UserDataProvider>(context, listen: false);
        userDataProvider.setImageUrl(imageUrl);

        // Opcional: Actualizar la URL de la imagen en Firestore y/o Firebase Auth si es necesario.
        await updateUserProfileImage(imageUrl);
      }
    }
  }

  Future<void> updateNameInFirestore(String userId, String newName) async {
    var userDocument =
        FirebaseFirestore.instance.collection('user').doc(userId);

    // Verifica si el documento existe
    var docSnapshot = await userDocument.get();
    if (docSnapshot.exists) {
      // Si el documento existe, actualiza el nombre
      return userDocument.update({
        'name': newName,
      }).then((_) {
        print("Nombre actualizado con éxito en Firestore.");
      }).catchError((error) {
        print("Error al actualizar el nombre en Firestore: $error");
      });
    } else {
      // El documento no existe
      print("Documento no encontrado en Firestore. nombe");
    }
  }

  Future<void> updateEmailInFirestore(String userId, String newEmail) async {
    var userDocument =
        FirebaseFirestore.instance.collection('user').doc(userId);

    // Primero, verifica si el documento existe
    var docSnapshot = await userDocument.get();
    if (docSnapshot.exists) {
      // Si el documento existe, actualiza el correo electrónico
      return userDocument.update({
        'email': newEmail,
      }).then((_) {
        print("Correo electrónico actualizado con éxito en Firestore.");
      }).catchError((error) {
        print("Error al actualizar el correo electrónico en Firestore: $error");
      });
    } else {
      // El documento no existe
      print("Documento no encontrado en Firestore.email");
    }
  }

  Future<String?> uploadImageToFirebaseStorage(Uint8List img) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Reference ref =
          FirebaseStorage.instance.ref().child('profileImages').child(userId);
      UploadTask uploadTask = ref.putData(img);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateUserProfileImage(String imageUrl) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // Actualizar en Firestore
    await FirebaseFirestore.instance.collection('user').doc(userId).update({
      'imageLink': imageUrl,
    });
    // Opcional: Actualizar en Firebase Auth
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);
  }
}
