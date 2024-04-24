import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  String _imageUrl;
  String _nombre;
  String _correo;


  UserDataProvider(this._imageUrl, this._correo,this._nombre);

  String get imageUrl => _imageUrl;
    String get nombre => _nombre;
  String get correo => _correo;


  void setImageUrl(String newImageUrl) {
    _imageUrl = newImageUrl;
    notifyListeners();
  }
  void setNombre(String newNombre) {
    _nombre = newNombre;
    notifyListeners();
  }
  void setCorreo(String newEmail) {
    _correo = newEmail;
    notifyListeners();
  }
}