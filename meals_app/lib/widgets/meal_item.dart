import 'package:flutter/material.dart';
import 'package:meals_app/screens/meal_details_screen.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal});
  final Meal meal;

  void _onSelectMeal(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => MealDetailsScreen(meal: meal)));
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: (){
          _onSelectMeal(context);
        },
        child: Stack(
          children: [
            Hero(
              tag: meal.id,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
                height: 200,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                color: Colors.black54,
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                        ),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                      MealItemTrait(icon: Icons.schedule, data: '${meal.duration.toString()} min'),
                      const SizedBox(width: 12,),
                      MealItemTrait(icon: Icons.work, data: meal.complexity.name),
                      const SizedBox(width: 12,),
                      MealItemTrait(icon: Icons.attach_money, data: meal.affordability.name),
                    ],)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
