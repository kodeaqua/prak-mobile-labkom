import 'package:flutter/material.dart';
import 'package:sqflite_crud/screens/home.dart';

void main(List<String> args) => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff6f010c),
            brightness: Brightness.dark,
          )),
      home: const HomeScreen(),
    );
  }
}
