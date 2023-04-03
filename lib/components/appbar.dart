import 'package:flutter/material.dart';
import 'package:projet_flutter_mds/repositories/arrets_repository.dart';
import 'package:projet_flutter_mds/repositories/lignes_repository.dart';
import 'package:projet_flutter_mds/ui/screens/lignes_screen.dart';

import '../ui/screens/favorites_screen.dart';
import '../ui/screens/home_screen.dart';

class BottomAppBarW extends StatelessWidget {
  const BottomAppBarW({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: BottomAppBarWidget(),
    );
  }
}

class BottomAppBarWidget extends StatefulWidget {
  const BottomAppBarWidget({super.key});

  @override
  State<BottomAppBarWidget> createState() => BottomAppBarWidgetState();
}

class BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [];
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  void initState() {
    super.initState();
    _widgetOptions.addAll([
      Home(arretsRepository: ArretsRepository()),
      LignesScreen(lignesRepository: LignesRepository()),
      Favorite()
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Carte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: 'Lignes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favories',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF8B0000),
        onTap: _onItemTapped,
      ),
    );
  }
}
