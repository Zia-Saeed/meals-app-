import 'package:flutter/material.dart';
import 'package:meals_app/models/meals.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/provider/favourites_provider.dart';

class MealsDetail extends ConsumerWidget {
  const MealsDetail({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteMeals = ref.watch(favouriteMealsProvider);

    final isFavourite = favouriteMeals.contains(meal);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final wasAdded = ref
                  .read(favouriteMealsProvider.notifier)
                  .toggleMealFavouriteStatus(meal);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    wasAdded ? "Meal Added as a Favourite" : "Meal Removed",
                  ),
                  duration: const Duration(
                    seconds: 2,
                  ),
                ),
              );
            },
            icon: AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 300,
              ),
              transitionBuilder: ((child, animation) => RotationTransition(
                    turns: Tween<double>(begin: 0.7, end: 1).animate(
                        animation), // it by default take double but 1 is used as number to takle this use <double with tween> or use double value 0.0 or 1.0 something like that for custom animation use tween,
                    child: child,
                  )),
              child: Icon(
                isFavourite ? Icons.star : Icons.star_border,
                key: ValueKey(
                  isFavourite,
                ), // for flutter to tell to apply trasition
              ),
            ),
          ),
        ],
        title: Text(
          meal.title,
        ),
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
              height: 14,
            ),
            Text(
              "Ingredients",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 14,
            ),
            for (final ingredient in meal.ingredients)
              Text(
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Steps",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            for (final step in meal.steps)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: Text(
                  step,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
