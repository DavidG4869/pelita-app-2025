import 'package:flutter/material.dart';
import 'package:pelita_app/service_locator.dart';
import 'package:pelita_app/services/navigation_svc.dart';
import 'package:transparent_image/transparent_image.dart';

class PelitaBottomNavBar extends StatelessWidget {
  int selectedIndex;
  final List<String> _pages = ['/home', '/bookmarks', '/kontak'];

  PelitaBottomNavBar({this.selectedIndex = 7, Key key}) : super(key: key);

  void onTapIndex(int index) {
    if (this.selectedIndex != index) {
      svc<NavigationService>().navigateTo(_pages[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).textSelectionColor,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        elevation: 10,
        onTap: (index) => onTapIndex(index),
        currentIndex: allUnselected ? 0 : this.selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: 'Bookmarks'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Kontak'),
        ],
      ),
    );
  }

  IconThemeData get unselectedStyle => IconThemeData(color: Colors.black, opacity: 0.9);
  IconThemeData get selectedStyle => IconThemeData(color: Colors.grey, opacity: 1);
  Color get selectedColor => Colors.grey;
  Color get unselectedColor => Colors.black;
  bool get allUnselected => this.selectedIndex > 2;
  TextStyle get unselectedFontStyle => TextStyle(fontSize: 13);
}
