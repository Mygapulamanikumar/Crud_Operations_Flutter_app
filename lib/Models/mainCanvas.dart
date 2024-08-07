import 'package:capture/Models/Screens/ButtonWidget.dart';
import 'package:capture/Models/Screencapture.dart';
import 'package:flutter/material.dart';

class MainCanvas extends StatelessWidget {
  const MainCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    body: Screencapture(),
    );
  }
}
