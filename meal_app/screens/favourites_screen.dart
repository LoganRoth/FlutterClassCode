import 'package:flutter/material.dart';
import 'package:meal_app/items/meal_item.dart';
import 'package:meal_app/models/meal.dart';

class FavouritesScreen extends StatelessWidget {
  final List<Meal> favMeals;

  FavouritesScreen(this.favMeals);
  
  @override
  Widget build(BuildContext context) {
    if (favMeals.isEmpty) {
      return Center(
        child: Text('You have no favourites yet!'),
      );
    } else {
      return ListView.builder(
        itemBuilder: (ctx, idx) {
          return MealItem(
            id: favMeals[idx].id,
            title: favMeals[idx].title,
            imageUrl: favMeals[idx].imageUrl,
            duration: favMeals[idx].duration,
            complexity: favMeals[idx].complexity,
            affordability: favMeals[idx].affordability,
          );
        },
        itemCount: favMeals.length,
      );
    }
  }
}
