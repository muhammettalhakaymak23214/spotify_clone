import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/services/search_service.dart';
import 'package:spotify_clone/models/catogory_model.dart';

class SearchViewModel {
  //Services
  final SearchService categoryService = SearchService();
  //items
  ObservableList<CategoryItem> itemsCategory = ObservableList<CategoryItem>();
  //isLoading
  final Observable<bool> isLoading = Observable(false);

  SearchViewModel();

  void _changeLoading(bool isSearchingTorF) {
    runInAction(() {
      isLoading.value = isSearchingTorF;
    });
  }

  Future<void> fetchCategory() async {
    _changeLoading(true);
    final data = await categoryService.fetchCategory();
    runInAction(() {
      if (data != null) {
        itemsCategory.clear();
        itemsCategory.addAll(data);
      } else {
        debugPrint("-- fetchCategory : data null --");
      }
      _changeLoading(false);
    });
  }
}
