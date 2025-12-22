class UserProfileModel {
  String? displayName;
  String? id;

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    id = json["id"]??"";
    displayName = json["display_name"]??"";
  }
}