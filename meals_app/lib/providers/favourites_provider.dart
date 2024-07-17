import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

class FavouritesNotifier extends StateNotifier<List<Meal>> {
  FavouritesNotifier() : super([]);

  bool editFavourites(Meal meal) {
    bool isFavourite = state.contains(meal);
    if (isFavourite) {
      state = state.where((m) => m.id != meal.id).toList();
    } else {
      state = [...state, meal];
    }
    return isFavourite;
  }
}

final favouritesProvider =
    StateNotifierProvider<FavouritesNotifier, List<Meal>>((ref) {
  return FavouritesNotifier();
});
