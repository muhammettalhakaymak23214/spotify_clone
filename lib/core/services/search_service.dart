import 'package:dio/dio.dart';
import 'package:spotify_clone/core/constants/api_endpoints.dart';
import 'package:spotify_clone/models/catogory_model.dart';
import 'dart:io';
import 'package:spotify_clone/core/services/base_service.dart';

abstract class ISearchService {
  Future<List<CategoryItem>?> fetchCategory();
}

class SearchService extends BaseService implements ISearchService {
  SearchService() : super();

  @override
  Future<List<CategoryItem>?> fetchCategory() async {
    try {
      final response = await dio.get(Endpoint.category.path);

      if (response.statusCode == HttpStatus.ok) {
        final items = response.data['categories']['items'];
        if (items is List) {
          return items.map((e) => CategoryItem.fromJson(e)).toList();
        }
      }
    } on DioException catch (exception) {
      logError(exception, "CategoryService");
    }
    return null;
  }
}
