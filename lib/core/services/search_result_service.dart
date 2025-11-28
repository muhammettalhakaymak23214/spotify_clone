import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/models/search_detail_model.dart';

class SearchResultService {
  final Dio dio = Dio();

  Future<SearchResultModel?> fetchSearchResult({
    required String token,
    required String query,
    String type = "track",
    int limit = 10,
    int offset = 0,
  }) async {
    final encodedQuery = Uri.encodeComponent(query);
    final apiQuery = "q=$encodedQuery&type=$type&limit=$limit&offset=$offset";
    final apiUrl = AppStrings.apiSearchResult + apiQuery;

    try {
      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {"Authorization": token, "Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200) {
        return SearchResultModel.fromJson(response.data);
      } else {
        debugPrint('SearchResultService : ${response.statusCode}');
        return null;
      }
    } catch (error) {
      debugPrint('SearchResultService : $error');
      return null;
    }
  }
}
