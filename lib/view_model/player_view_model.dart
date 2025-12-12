import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/helpers/palette_helper.dart';

class PlayerViewModel {
  Observable<Color> bgColor = Observable<Color>(Colors.black);

  Future<void> updateBackground(String imageUrl , {bool isPath = false}) async {
    final color = await PaletteHelper.getBackgroundColor(imageUrl , isPath: isPath);

    runInAction(() {
      bgColor.value = color;
    });
  }
}
