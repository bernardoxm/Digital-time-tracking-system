// CONTROLLER DA IMAGEM DO USUARIO, UTILIZA O PICK IMAGE PARA SALVAR LOCALMENTE. 

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageSelectController {
  late SharedPreferences _prefs;

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<File?> pickImage(BuildContext context) async {
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final Directory profileDir = Directory('${appDir.path}/profile');

        if (!await profileDir.exists()) {
          await profileDir.create(recursive: true);
        }

        final String savedPath = '${profileDir.path}/photoprofile.png';
        final File savedImage = await File(pickedFile.path).copy(savedPath);

        // Save the image path to SharedPreferences
        _prefs.setString('profile_image_path', savedPath);

        return savedImage;
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nenhuma imagem selecionada')),
        );
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao escolher imagem: $e");
      return null;
    }
  }

  Future<File?> getSavedImage() async {
    String? imagePath = _prefs.getString('profile_image_path');
    if (imagePath != null) {
      return File(imagePath);
    }
    return null;
  }
}
