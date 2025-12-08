import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/helpers/palette_helper.dart';

class PlayerViewModel {
    Observable<Color> bgColor = Observable<Color>(Colors.black);

  Future<void> updateBackground(String imageUrl) async {
    final color = await PaletteHelper.getBackgroundColor(imageUrl);

    runInAction(() {
      bgColor.value = color;
    });
  }
}