import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:spotify_clone/models/catogory_model.dart';

class CategoryService {
  final Dio dio = Dio();

  Future<CategoryModel?> fetchCategory(String token, String apiUrl) async {
    try {
      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {"Authorization": token, "Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data);
      } else {
        debugPrint('API ERROR: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('CategoryService : $e');
      return null;
    }
  }
}