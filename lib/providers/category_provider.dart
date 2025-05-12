import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_cart/models/category.dart';

class CategoryProvider extends StateNotifier<List<Category>>{
  CategoryProvider() : super([]);
  // Set the list of categories
  void setCategories(List<Category> categories) {
    state = categories;
  }

  
}

final categoryProvider =
    StateNotifierProvider<CategoryProvider, List<Category>>((ref) => CategoryProvider());
