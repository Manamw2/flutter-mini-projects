import 'package:flutter/material.dart';
import 'package:meals_app/widgets/meal_item.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, this.category, required this.isFavourites, this.favouriteMeals});
  final Category? category;
  final bool isFavourites;
  final List<Meal>? favouriteMeals;
  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Uo oh ...  nothing here!", style: TextStyle(color: Colors.white),),
          const SizedBox(
            height: 16,
          ),
          Text(
            "You can check other Category",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
    final mealsCategory = isFavourites? favouriteMeals : dummyMeals
        .where((meal) => meal.categories.contains(category!.id))
        .toList();
    if(mealsCategory!.isNotEmpty){
      content = ListView.builder(
          itemCount: mealsCategory.length,
          itemBuilder: (ctx, idx) => MealItem(meal: mealsCategory[idx]));
    }
    if(isFavourites){
      return content;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(category!.title),
      ),
      body: content,
    );
  }
}
