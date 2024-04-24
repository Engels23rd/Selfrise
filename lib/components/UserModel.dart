import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

class UserModel {
  final String? id;
  final String name;
  final String lastname;
  final String birthday;
  final String email;
  final String password;
  final Uint8List? file;

  const UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.lastname,
    required this.birthday,
    required this.file,
  });

  Future<String> uploadImageStorage(String childname, Uint8List? file) async {
    if (file == null) {
      throw ArgumentError("El parámetro 'file' no puede ser nulo.");
    }

    Reference ref = _storage.ref().child(childname);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
