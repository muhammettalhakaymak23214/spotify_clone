class PlaylistModel {
  String? id;
  String? playlistName;
  String? playlistDesciription;
  String? playlistCoverImage;
  bool? collaborative;

  PlaylistModel({
    this.id,
    this.playlistName,
    this.playlistDesciription,
    this.playlistCoverImage,
    required this.collaborative,
    
  });

  PlaylistModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? "";
    playlistName = json["name"] ?? "No Name";
    playlistDesciription = json["description"] ?? "No name";
    playlistCoverImage = json["images"]?[0]["url"] ?? "";
    collaborative = json["collaborative"] ?? true;
  } 
}
