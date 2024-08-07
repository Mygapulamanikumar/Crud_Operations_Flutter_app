
import 'package:flutter/material.dart';
import '../../Capture/lib/Models/mainCanvas.dart';

class MainUIWidget extends StatelessWidget {
  const MainUIWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title', // Add a title for your app
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainCanvas(),
    );
  }
}