class RecentlyPlayedTarckModel {
  String? name;
  String? artistName;
  String? imageUrl;
  String? id;
  String? playedAt;
  RecentlyPlayedTarckModel.fromJson(Map<String, dynamic> json) {
    id = json["track"]["id"];
    imageUrl = json["track"]["album"]["images"]?[0]["url"];
    name = json["track"]["name"];
    artistName = json["track"]["artists"][0]["name"];
    playedAt = json["played_at"];
  }
}