import 'package:image_picker/image_picker.dart';

pickerImage(ImageSource Imageurl) async {
  final ImagePicker _image = ImagePicker();
  XFile? file = await _image.pickImage(source: Imageurl);

  if (file != null) {
    return await file.readAsBytes();
  }
  print('No seleccionaste una imagen');
}
