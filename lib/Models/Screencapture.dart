import 'package:flutter/material.dart';
import 'Screens/FormScreenWidget.dart';
import 'navBar.dart';

class Screencapture extends StatelessWidget {
  const Screencapture({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Navbar(),
      body: Center(
        child: FormScreenWidget(),
      ),
    );
  }
}
