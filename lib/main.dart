import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herewego/components/appbar.dart';
import 'package:herewego/repositories/arrets_repository.dart';
import 'package:herewego/repositories/lignes_repository.dart';
import 'package:herewego/ui/screens/home_screen.dart';

import 'ui/screens/lignes_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus stop',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => Home(arretsRepository: ArretsRepository()),
        '/lignes': (context) => LignesScreen(
              lignesRepository: LignesRepository(),
            ),
        '/appbar': (context) => BottomAppBarWidget()
      },
      initialRoute: '/appbar',
    );
  }
}
