import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_flutter_mds/provider/lignes_provider.dart';
import 'package:projet_flutter_mds/repositories/arrets_repository.dart';
import 'package:projet_flutter_mds/repositories/lignes_repository.dart';
import 'package:projet_flutter_mds/ui/screens/lignes_screen.dart';

import '../ui/screens/favorites_screen.dart';
import '../ui/screens/home_screen.dart';

class BottomAppBarW extends ConsumerWidget {
  const BottomAppBarW({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      title: _title,
      home: BottomAppBarWidget(),
    );
  }
}

class BottomAppBarWidget extends ConsumerStatefulWidget {
  const BottomAppBarWidget({super.key});

  @override
  ConsumerState<BottomAppBarWidget> createState() => BottomAppBarWidgetState();
}

class BottomAppBarWidgetState extends ConsumerState<BottomAppBarWidget> {
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
    if (index == 2) {
      ref.watch(lignesProvider.notifier).getLignes();
    }
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
