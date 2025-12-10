import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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

enum PlayerTitleType { playlist, album, artist }

extension PlayerTitle on PlayerTitleType {
  String get title {
    switch (this) {
      case PlayerTitleType.playlist:
        return "Çalma listesinden çalıyor";
      case PlayerTitleType.album:
        return "Albümden çalıyor";
      case PlayerTitleType.artist:
        return "Sanatçıdan çalıyor";
    }
  }
}
