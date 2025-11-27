class CategoryModel {
  List<CategoryItem>? categories;
  CategoryModel({this.categories});
  CategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <CategoryItem>[];
      json['categories']['items'].forEach((v) {
        categories!.add(CategoryItem.fromJson(v));
      });
    }
  }
}

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
