import 'package:flutter/material.dart';

class ImageUtils {
  static ImageProvider<Object> getImageProvider(String? thumbnailUrl) {
    if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
      return NetworkImage(thumbnailUrl);
    } else {
      return const AssetImage('assets/iconos/image-default.png');
    }
  }
}

