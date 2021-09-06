import 'package:flutter/material.dart';
import 'package:meal_app/dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';

  final Function toggleFav;
  final Function isMealFav;

  MealDetailScreen(this.toggleFav, this.isMealFav);

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }

  Widget buildSection(Widget childWidget) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      height: 200,
      width: 300,
      child: childWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final mealID = routeArgs['id'];
    final pickedMeal = DUMMY_MEALS.firstWhere((meal) {
      bool select;
      if (meal.id.compareTo(mealID) == 0) {
        select = true;
      } else {
        select = false;
      }
      return select;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('${pickedMeal.title}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(pickedMeal.imageUrl, fit: BoxFit.cover),
            ),
            buildSectionTitle(context, 'Ingredients'),
            buildSection(ListView.builder(
                itemBuilder: (ctx, idx) => Card(
                      color: Theme.of(context).accentColor,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Text(pickedMeal.ingredients[idx]),
                      ),
                    ),
                itemCount: pickedMeal.ingredients.length)),
            buildSectionTitle(context, 'Steps'),
            buildSection(ListView.builder(
                itemBuilder: (ctx, idx) => Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            child: Text('# ${(idx + 1)}'),
                          ),
                          title: Text(pickedMeal.steps[idx]),
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                      ],
                    ),
                itemCount: pickedMeal.steps.length)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          isMealFav(mealID) ? Icons.star : Icons.star_border,
        ),
        onPressed: () => toggleFav(mealID),
      ),
    );
  }
}
