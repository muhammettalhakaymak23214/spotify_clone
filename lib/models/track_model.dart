class TrackModel {
  String? trackName;
  String? id;
  String? artistName;
  String? image;

  TrackModel.fromJson(Map<String, dynamic> json) {
    id = json["id"]??"";
    trackName = json["name"]??"No Name";
    artistName = json["artists"][0]["name"] ?? "No name";
    image = json["album"]["images"][0]["url"] ?? "NoUrl";
  }

  TrackModel.addedToPlaylistFromJson(Map<String, dynamic> json) {
    id = json["track"]["id"]??"";
    trackName = json["track"]["name"]??"No Name";
    artistName = json["track"]["artists"][0]["name"] ?? "No name";
    image = json["track"]["album"]["images"][0]["url"] ?? "NoUrl";
  }
}