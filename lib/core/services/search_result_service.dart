import 'dart:io';
import 'package:dio/dio.dart';
import 'package:spotify_clone/core/services/base_service.dart';
import 'package:spotify_clone/models/search_detail_model.dart';

abstract class ISearchResultService {
  Future<List<SearchResultItem>?> fetchSearchResult(
    String type,
    int limit,
    int offset,
    String q,
  );
}

class SearchResultService extends BaseService implements ISearchResultService {
  SearchResultService() : super();

  @override
  Future<List<SearchResultItem>?> fetchSearchResult(
    String type,
    int limit,
    int offset,
    String q,
  ) async {
    final encodedQuery = Uri.encodeComponent(q);
    try {
      final response = await dio.get(
        _SearchResultServicePaths.search.name,
        queryParameters: {
          _SearchResultQueryPaths.type.name: type,
          _SearchResultQueryPaths.limit.name: limit,
          _SearchResultQueryPaths.offset.name: offset,
          _SearchResultQueryPaths.q.name: encodedQuery,
        },
        options: authHeader(),
      );

      if (response.statusCode == HttpStatus.ok) {

        final tracks = response.data['tracks']['items'];
        if (tracks != null && tracks is List) {
          return tracks.map((e) => SearchResultItem.fromJson(e)).toList();
        }
      }
    } on DioException catch (exception) {
       logError(exception, "SearchResultService");
    }
    return null;
  }
}

enum _SearchResultServicePaths { search }

enum _SearchResultQueryPaths { q, type, limit, offset }

  

