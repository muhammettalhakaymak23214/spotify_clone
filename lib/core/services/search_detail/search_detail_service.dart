import 'dart:io';
import 'package:dio/dio.dart';
import 'package:spotify_clone/core/enums/endpoint.dart';
import 'package:spotify_clone/core/services/base_service.dart';
import 'package:spotify_clone/core/services/search_detail/search_query_params.dart';
import 'package:spotify_clone/models/search_detail_model.dart';

abstract class ISearchDetailService {
  Future<List<RecentlyPlayedItem>?> fetchRecentlyPlayed();
  Future<List<SearchResultItem>?> fetchSearchResult(
    String type,
    int limit,
    int offset,
    String q,
  );
}

class SearchDetailService extends BaseService
    implements ISearchDetailService {
  SearchDetailService() : super();

  @override
  Future<List<RecentlyPlayedItem>?> fetchRecentlyPlayed() async {
    try {
      final response = await dio.get(Endpoint.recentlyPlayed.path);

      if (response.statusCode == HttpStatus.ok) {
        final items = response.data['items'];
        if (items is List) {
          return items.map((e) => RecentlyPlayedItem.fromJson(e)).toList();
        }
      }
    } on DioException catch (exception) {
      logError(exception, "RecentlyPlayedService");
    }
    return null;
  }

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
        Endpoint.search.path,
        queryParameters: {
          SearchResultQueryPaths.type.name: type,
          SearchResultQueryPaths.limit.name: limit,
          SearchResultQueryPaths.offset.name: offset,
          SearchResultQueryPaths.q.name: encodedQuery,
        },
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



