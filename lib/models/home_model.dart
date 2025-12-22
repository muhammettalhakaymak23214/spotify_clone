class HomeItem {
  String? title;
  String? subTitle;
  String? type;
  String? id;
  String? imagesUrl;
}
class PlaylistItem extends HomeItem {

  PlaylistItem.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    imagesUrl = json["images"]?[0]["url"];
    title = json["name"];
    subTitle = json["owner"]["display_name"];
    type = json["type"];
  }
}
class NewReleasesItem extends HomeItem {

  NewReleasesItem.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    imagesUrl = json["images"][0]["url"];
    title = json["name"];
    subTitle = json["artists"][0]["name"];
    type = json["type"];
  }
}
class UserTopArtistsItem extends HomeItem {

  UserTopArtistsItem.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    imagesUrl = json["images"][0]["url"];
    title = json["name"];
    subTitle = "";
    type = json["type"];
  }
}

