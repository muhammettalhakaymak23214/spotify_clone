class HomeModel {
  List<HomeItem>? homeItem;
  HomeModel({this.homeItem});

  HomeModel.fromPlaylistJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      homeItem = <HomeItem>[];
      json['items'].forEach((v) {
        homeItem!.add(HomeItem.fromPlaylistJson(v));
      });
    }
  }
  HomeModel.fromNewReleases(Map<String, dynamic> json) {
    if (json['albums'] != null) {
      homeItem = <HomeItem>[];
      json['albums']['items'].forEach((v) {
        homeItem!.add(HomeItem.fromNewReleases(v));
      });
    }
  }
    HomeModel.fromUserTopArtists(Map<String, dynamic> json) {
    if (json['items'] != null) {
      homeItem = <HomeItem>[];
      json['items'].forEach((v) {
        homeItem!.add(HomeItem.fromUserTopArtists(v));
      });
    }
  }
}

class HomeItem {
  String? title;
  String? subTitle;
  String? type;
  String? id;
  String? imagesUrl;
  HomeItem({this.title, this.subTitle, this.imagesUrl, this.id, this.type});

  HomeItem.fromPlaylistJson(Map<String, dynamic> json) {
    id = json["id"];
    imagesUrl = json["images"][0]["url"];
    title = json["name"];
    subTitle = json["owner"]["display_name"];
    type = json["type"];
  }
  HomeItem.fromNewReleases(Map<String, dynamic> json) {
    id = json["id"];
    imagesUrl = json["images"][0]["url"];
    title = json["name"];
    subTitle = json["artists"][0]["name"];
    type = json["type"];
  }
    HomeItem.fromUserTopArtists(Map<String, dynamic> json) {
    id = json["id"];
    imagesUrl = json["images"][0]["url"];
    title = json["name"];
    subTitle = "";
    type = json["type"];
  }
}
