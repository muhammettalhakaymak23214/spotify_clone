class LibraryModel {

  List<LibraryItem>? librarItem;
  LibraryModel({
    this.librarItem
  });

  LibraryModel.fromAlbumsJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      librarItem = <LibraryItem>[];
      json['items'].forEach((v) {
        librarItem!.add(LibraryItem.fromAlbumsJson(v));
      });
    }
  }
  LibraryModel.fromArtistJson(Map<String, dynamic> json) {
    if (json['artists'] != null) {
      librarItem= <LibraryItem>[];
      json['artists']['items'].forEach((v) {
        librarItem!.add(LibraryItem.fromArtistJson(v));
      });
    }
  }
  LibraryModel.fromPlaylistJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      librarItem = <LibraryItem>[];
      json['items'].forEach((v) {
        librarItem!.add(LibraryItem.fromPlaylistJson(v));
      });
    }
  }
    LibraryModel.fromPodcastJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      librarItem = <LibraryItem>[];
      json['items'].forEach((v) {
        librarItem!.add(LibraryItem.fromPodcastJson(v));
      });
    }
  }
 
}

class LibraryItem {
  String? title; 
  String? subTitle; 
  String? type;
  String? id; 
  String? imagesUrl;
  LibraryItem ({
    this.title,
    this.subTitle,
    this.imagesUrl,
    this.id,
    this.type,
  });

  LibraryItem.fromAlbumsJson(Map<String, dynamic> json) {
    id = json["album"]?["id"];
    imagesUrl = json["album"]?["images"][0]["url"];
    title = json["album"]?["name"];
    subTitle = json["album"]?["artists"][0]["name"];
    type = json["album"]?["type"];
  }
  LibraryItem.fromArtistJson(Map<String, dynamic> json) {
    id = json["id"];
    imagesUrl = json["images"][0]["url"];
    title = json["name"];
    subTitle = "";
    type = json["type"];
  }
  LibraryItem.fromPlaylistJson(Map<String, dynamic> json) {
    id = json["id"];
    imagesUrl = json["images"][0]["url"];
    title = json["name"];
    subTitle = json["owner"]["display_name"];
    type = json["type"];
  }
  LibraryItem.fromPodcastJson(Map<String, dynamic> json) {
    id = json["show"]["id"];
    imagesUrl = json["show"]["images"][0]["url"];
    title = json["show"]["name"];
    subTitle = "";
    type = json["show"]["type"];
  }

}