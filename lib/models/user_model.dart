class UserModel {
  String? id;
  String? displayName;
  String? imageUrl;
  int? total;

  UserModel({
    this.id,
    this.displayName,
    this.imageUrl,
    this.total
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    total = json["followers"]?["total"] ?? 0;
    id = json["id"];
    displayName = json["display_name"] ?? json["name"] ?? "No Data";
    imageUrl = (json["images"] != null && json["images"].isNotEmpty) ? json["images"][0]["url"] : null;
  }
}

