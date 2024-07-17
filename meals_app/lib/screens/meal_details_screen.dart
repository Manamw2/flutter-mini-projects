import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/favourites_provider.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({super.key, required this.meal});
  final Meal meal;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isFavourite = ref.watch(favouritesProvider).contains(meal);
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
            onPressed: () {
              final isFavourite =
                  ref.read(favouritesProvider.notifier).editFavourites(meal);
              final snackText = !isFavourite
                  ? "Meal is added to favourites"
                  : "Meal is removed from favourites";
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(snackText)));
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isFavourite ? Icons.star : Icons.star_border,
                key: ValueKey(isFavourite),
              ),
              transitionBuilder: (child, animation) => RotationTransition(
                turns: Tween(
                  begin: 0.8,
                  end: 1.0
                ).animate(animation),
                child: child,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: meal.id,
              child: Image.network(
                meal.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Ingredients",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 14,
            ),
            for (final i in meal.ingredients)
              Padding(
                padding: const EdgeInsets.all(2),
                child: Text(
                  i,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "Steps",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 14,
            ),
            for (final i in meal.steps)
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  i,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              )
          ],
        ),
      ),
    );
  }
}
