import 'package:flutter/material.dart';
import 'package:projet_flutter_mds/components/appbar.dart';
import 'package:projet_flutter_mds/models/arrets.dart';
import 'package:projet_flutter_mds/repositories/arrets_repository.dart';
import 'package:projet_flutter_mds/ui/screens/home_screen.dart';

import 'ui/screens/lignes_screen.dart';

void main() {
  runApp(const MyApp());
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
        '/lignes': (context) => Lignes(),
        '/appbar': (context) => BottomAppBarWidget()
      },
      initialRoute: '/appbar',
    );
  }
}
