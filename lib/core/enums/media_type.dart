import 'package:flutter/material.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';

enum MediaType { playlist, album, artist ,show , downloaded }

extension MediaTypeText on MediaType {
  String  title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      
      case MediaType.playlist:
        return l10n.mediaTypePlaylist;
      case MediaType.album:
        return l10n.mediaTypeAlbum;
      case MediaType.artist:
        return l10n.mediaTypeArtist;
      case MediaType.show:
        return l10n.mediaTypeShow;
      case MediaType.downloaded:
        return l10n.mediaTypeDownloaded;
    }
  }

  static MediaType fromString(String value) {
    return MediaType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MediaType.show, 
    );
  }
}