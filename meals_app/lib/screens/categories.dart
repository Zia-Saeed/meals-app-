import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meals.dart';
import 'package:meals_app/screens/meals_screen.dart';
import 'package:meals_app/widgets/category_grid_item.dart';
import 'package:meals_app/models/category.dart';
// import 'package:flutter/widgets.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.availableMeals,
  });

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController
        .forward(); // starting the animation in initstate() method
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // in statefull widget context is globally availble but in stateless widget context is not globally availble
  void _selectCategory(BuildContext context, CategoryMeals category) {
    // Navigator.push(context, route)
    final filteredMeals = widget.availableMeals
        .where((meals) => meals.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  // void subcategory(BuildContext context, List<String> subCategory) {
  @override
  Widget build(BuildContext context) {
    // builder function will be executed 6o times per second
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing:
              20, // crossAxisSpacing 20px horizentally and mainAxisspacing 20px vertically
          mainAxisSpacing: 20,
        ),
        children: [
          // alternative to availableCategory.map((category)=> CategoryGriditem(category:category)).toList()
          for (final cate in availableCategories)
            CategoryGridItem(
              category: cate,
              onSelectCategory: () {
                _selectCategory(context, cate);
              },
            )
        ], // Gridview is like Listview
        // geiddelegate simply controls the layout of gridview elements
        // child aspect ration is the sizing of the grid child elements 3 to 2 ratio
      ),
      // another good method of transition
      // offset take two arguments on x-axis and y-axis
      builder: (context, child) => SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInCubic,
          ),
        ),
        child: child,
      ),
    );
    // builder: (context, child) => Padding(
    //       padding: EdgeInsets.only(
    //         top: 100 - _animationController.value * 100,
    //         // the animation value will be between 1 and 0 and * 100 means multiply by 100 padding
    //       ),
    //       child: child,
    //     ));
    // gridview will be displayed inside of a padding it will not be rebuild and reevaluated 60 times per seconds but padding will be evaluated 60 times per second
  }
}
