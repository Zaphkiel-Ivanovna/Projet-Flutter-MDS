import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herewego/components/appbar.dart';

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
