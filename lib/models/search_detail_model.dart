class RecentlyPlayedItem {
  String? name;
  String? artistName;
  String? imageUrl;
  String? id;
  RecentlyPlayedItem.fromJson(Map<String, dynamic> json) {
    id = json["track"]["album"]["id"];
    imageUrl = json["track"]["album"]["images"][0]["url"];
    name = json["track"]["album"]["name"];
    artistName = json["track"]["album"]["artists"][0]["name"];
  }
}

class SearchResultItem {
  String? name;
  String? artistName;
  String? imageUrl;
  String? id;
  SearchResultItem.fromJson(Map<String, dynamic> json) {
    id = json["album"]["id"];
    imageUrl = json["album"]["images"][0]["url"];
    name = json["album"]["name"];
    artistName = json["album"]["artists"][0]["name"];
  }
}

