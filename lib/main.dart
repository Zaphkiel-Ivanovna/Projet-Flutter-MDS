import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herewego/components/appbar.dart';
import 'package:herewego/repositories/arrets_repository.dart';
import 'package:herewego/repositories/lignes_repository.dart';
import 'package:herewego/ui/screens/home_screen.dart';

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
        '/appbar': (context) => BottomAppBarWidget()
      },
      initialRoute: '/appbar',
    );
  }
}
