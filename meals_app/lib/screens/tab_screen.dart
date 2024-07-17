import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/favourites_provider.dart';
import 'package:meals_app/screens/categories_screen.dart';
import 'package:meals_app/screens/meals_screen.dart';
import 'package:meals_app/widgets/my_drawer.dart';

class TabScreen extends ConsumerStatefulWidget {
  const TabScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TabScreenState();
  }
}
class _TabScreenState extends ConsumerState<TabScreen>{
  int _screenIndex = 0;
  void _onTab(int idx){
      setState(() {
        _screenIndex = idx;
      });
    }
  @override
  Widget build(BuildContext context) {
    String title = 'Meals Cateories';
    Widget content = const CategoriesScreen();
    
    if(_screenIndex == 1){
      final favouriteMeals = ref.watch(favouritesProvider);
      content =  MealsScreen(favouriteMeals: favouriteMeals, isFavourites: true,);
      title = 'Favourites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _screenIndex,
        onTap: _onTab,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites'),
        ],
      ),
      drawer: const MyDrawer(),
      body: content,
    );
  }
}
