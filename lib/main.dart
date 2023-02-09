import 'package:flutter/material.dart';
import 'package:introducao_bloc/pages/home_single_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeSinglePage(),
    );
  }
}
