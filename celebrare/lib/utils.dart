import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  Utils._();

  /// Open image gallery and pick an image
  static Future<XFile?> pickImageFromGallery() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  /// Pick Image From Gallery and return a File
  static Future<CroppedFile?> cropSelectedImage(String filePath) async {
    return await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          minimumAspectRatio: 1.0,
          aspectRatioPickerButtonHidden: true,
        ),
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
        ),
      ],
    );
  }
}