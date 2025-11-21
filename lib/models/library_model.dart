class LibraryItem {
  String? id;
  String? title;
  String? subTitle;
  String? imageUrl;
  LibraryItemType? type;

  LibraryItem({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.imageUrl,
    required this.type,
  });

  LibraryItem.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    subTitle = json["subtitle"];
    imageUrl = json["imageUrl"];
    type = LibraryItemType.values.firstWhere((e) => e.name == json['type']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["title"] = title;
    data["subTitle"] = subTitle;
    data["imageUrl"] = imageUrl;
    data["type"] = type?.name ?? "";
    return data;
  }
}

enum LibraryItemType { playlists, albums, likedSongs, podcasts }
