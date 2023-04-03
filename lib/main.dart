import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_flutter_mds/components/appbar.dart';
import 'package:projet_flutter_mds/repositories/arrets_repository.dart';
import 'package:projet_flutter_mds/repositories/lignes_repository.dart';
import 'package:projet_flutter_mds/ui/screens/home_screen.dart';

import 'ui/screens/lignes_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
        '/lignes': (context) => LignesScreen(lignesRepository: LignesRepository(),),
        '/appbar': (context) => BottomAppBarWidget()
      },
      initialRoute: '/appbar',
    );
  }
}
