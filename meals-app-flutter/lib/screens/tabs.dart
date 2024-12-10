import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/favorites_provider.dart';
import 'package:meals_app/providers/filter_provider.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filter.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_draw.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  var _selectedIndex = 0;
  final List<String> _pageTitles = ['Categories', 'Favorite'];

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
          MaterialPageRoute(builder: (ctx) => const FiltersScreen()));
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final activeFilters = ref.watch(filterProvider);
    final availableMeals = ref.watch(filteredMealsProvider);
    final favoriteMeals = ref.watch(favoriteMealsProvider);
    final pages = [
      CategoriesScreen(availableMeals: availableMeals),
      MealsScreen(meals: favoriteMeals),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
      ),
      drawer: MainDraw(
        onSelectScreen: _setScreen,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            _selectPage(index);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.set_meal), label: 'Categories'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorite')
          ]),
    );
  }
}
