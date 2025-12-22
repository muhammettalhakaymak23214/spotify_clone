import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();

      if (bytes.lengthInBytes > 150 * 1024) {
        return null;
      }

      selectedImage = File(image.path);

      return selectedImage ;
    }
    return null;
  }

  Future<File> assetToFile(String assetPath) async {
    ByteData byteData = await rootBundle.load(assetPath);
    Uint8List bytes = byteData.buffer.asUint8List();

    final directory = await Directory.systemTemp.createTemp();
    final file = File('${directory.path}/temp_image.jpg'); 
    await file.writeAsBytes(bytes); 

    return file; 
  }
}
