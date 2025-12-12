import 'dart:io';

import 'package:flutter/material.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

class PaletteHelper {
  static Future<Color> getBackgroundColor(
    String imageUrl, {
    bool isPath = false,
  }) async {
    try {

      late PaletteGeneratorMaster  palette;
      if (isPath == false) {
        palette = await PaletteGeneratorMaster.fromImageProvider(
          // NetworkImage(imageUrl),
          FileImage(File(imageUrl)),
          maximumColorCount: 100,
        );
      } else {
        palette = await PaletteGeneratorMaster.fromImageProvider(
           NetworkImage(imageUrl),
          //FileImage(File(imageUrl)),
          maximumColorCount: 100,
        );
      }
          
      final colors = palette.paletteColors;

      if (colors.isEmpty) return Colors.black;
      final filteredColors = colors.where((c) {
        final hsl = HSLColor.fromColor(c.color);
        return hsl.saturation > 0.2 && hsl.lightness > 0.1;
      }).toList();

      PaletteColorMaster selectedColor;

      if (filteredColors.isNotEmpty) {
        filteredColors.sort((a, b) => b.population.compareTo(a.population));
        selectedColor = filteredColors.first;
      } else {
        selectedColor = colors.first;
      }
      final hslSelected = HSLColor.fromColor(selectedColor.color);
      if (hslSelected.saturation < 0.2 && colors.length > 1) {
        selectedColor = colors[1];
      }

      return selectedColor.color;
    } catch (e) {
      debugPrint("[PaletteHelper] : $e");
      return Colors.black;
    }
  }
}
