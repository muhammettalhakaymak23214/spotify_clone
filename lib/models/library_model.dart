import 'package:spotify_clone/core/enums/media_type.dart';

class LibraryItem {
  String? title; 
  String? subTitle; 
  MediaType? type;
  String? id; 
  String? imagesUrl;
}
class AlbumItem extends LibraryItem {

  AlbumItem.fromJson(Map<String, dynamic> json) {
    id = json["album"]?["id"];
    imagesUrl = json["album"]?["images"][0]["url"];
    title = json["album"]?["name"];
    subTitle = json["album"]?["artists"][0]["name"];
    type = MediaTypeText.fromString(json["album"]?["type"]);
  }
}
class ArtistItem extends LibraryItem {

  ArtistItem.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    imagesUrl = json["images"][0]["url"];
    title = json["name"];
    subTitle = "";
    type =  MediaTypeText.fromString(json["type"]);
  }
}
class PlaylistItem extends LibraryItem {

  PlaylistItem.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    imagesUrl = json["images"]?[0]["url"];
    title = json["name"];
    subTitle = json["owner"]["display_name"];
    type = MediaTypeText.fromString(json["type"]);;
  }
}

class PodcastItem extends LibraryItem {

  PodcastItem.fromJson(Map<String, dynamic> json) {
    id = json["show"]["id"];
    imagesUrl = json["show"]["images"][0]["url"];
    title = json["show"]["name"];
    subTitle = "";
    type = MediaTypeText.fromString(json["show"]["type"]);
  }
}

