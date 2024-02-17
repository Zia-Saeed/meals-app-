import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals_screen.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:meals_app/provider/favourites_provider.dart';
import 'package:meals_app/provider/filters_provider.dart';

const kInitialFilter = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String indentifier) async {
    Navigator.of(context).pop();

    if (indentifier == "Filters") {
      // the data coming from the filter screen using pop method will be stored here in result when using await kwarg.

      await Navigator.of(context).push<Map<Filter, bool>>(MaterialPageRoute(
        builder: (context) => const FiltersScreen(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final meals = ref.watch(mealsProvider);
    final availableMeals = ref.watch(filteredMealsProvider);
    Widget _activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    String _activePageTitle = "Categories";

    if (_selectedPageIndex == 1) {
      final _favouriteMeals =
          ref.watch(favouriteMealsProvider); // getting favourite meals here.

      _activePage = MealsScreen(
        meals: _favouriteMeals,
      );
      _activePageTitle = "Your Favourite";
    }
    return Scaffold(
      drawer: MainDrawer(onSelectScreen: _setScreen),
      appBar: AppBar(
        title: Text(
          _activePageTitle,
        ),
      ),
      body: _activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favourite"),
        ],
        onTap: _selectPage,
      ),
    );
  }
}
