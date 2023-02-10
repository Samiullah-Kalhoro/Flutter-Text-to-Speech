import 'package:flutter/material.dart';

import 'routes/read_orator.dart';
import 'theming/color_schemes.g.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme, fontFamily: 'BillyHatter'),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme,fontFamily: 'BillyHatter'),
      home: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Text('Read Orator'),
        ),
        body: const ReadOrator(),
      ),
    );
  }
}
