enum MediaType { playlist, album, artist ,show , downloaded }

extension MediaTypeText on MediaType {
  String get title {
    switch (this) {
      case MediaType.playlist:
        return "ÇALMA LİSTESİNDEN ÇALINIYOR";
      case MediaType.album:
        return "ALBUMDEN ÇALINIYOR";
      case MediaType.artist:
        return "SANATÇILARDAN ÇALINIYOR";
      case MediaType.show:
        return "PODCAST'TEN ÇALINIYOR";
      case MediaType.downloaded:
        return "İNDİRİLENLERDEN ÇALINIYOR";
    }
  }

  static MediaType fromString(String value) {
    return MediaType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MediaType.show, 
    );
  }
}