class CategoryItem {
  String? name;
  String? imageUrl;
  String? id;
  CategoryItem.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    imageUrl = json["icons"][0]["url"];
    name = json["name"];
  }
}
