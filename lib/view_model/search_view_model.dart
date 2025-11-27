import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/services/category_service.dart';
import 'package:spotify_clone/models/catogory_model.dart';

class SearchViewModel {
  //Services
  final CategoryService categoryService = CategoryService();
  //items
  final ObservableList<CategoryItem> itemsCategory =
      ObservableList<CategoryItem>();
  final Observable<bool> isLoading = Observable(false);
  //dio
  final Dio dio = Dio();
  //token
  final String token;

  SearchViewModel({required this.token});

  Future<void> fetchCategory() async {
    runInAction(() {
      isLoading.value = true;
    });


    try {
      final category = await categoryService.fetchCategory(
        token,
        AppStrings.apiCategoris,
      );
      runInAction(() {
        if (category != null) {
          itemsCategory.addAll(category.categories ?? []);
        }
      });
    } catch (e) {
      print("$e");
    } finally {
          runInAction(() {
      isLoading.value = false;
    });
;
    }
  }
}
