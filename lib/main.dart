import 'package:flutter/material.dart';

import 'features/upload/view/upload_screen.dart';

void main() {
  runApp(const HealtechApp());
}

class HealtechApp extends StatelessWidget {
  const HealtechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealTech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1A73E8),
        useMaterial3: true,
      ),
      home: const UploadScreen(),
    );
  }
}
