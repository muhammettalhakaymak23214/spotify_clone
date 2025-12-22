class RecentlyPlayedItem {
  String? name;
  String? artistName;
  String? imageUrl;
  String? id;
  RecentlyPlayedItem.fromJson(Map<String, dynamic> json) {
    id = json["track"]["id"];
    imageUrl = json["track"]["album"]["images"]?[0]["url"];
    name = json["track"]["name"];
    artistName = json["track"]["artists"][0]["name"];
  }
}

class SearchResultItem {
  String? name;
  String? artistName;
  String? imageUrl;
  String? id;
  SearchResultItem.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    imageUrl = json["album"]["images"][0]["url"];
    name = json["name"];
    artistName = json["album"]["artists"][0]["name"];
  }
}

