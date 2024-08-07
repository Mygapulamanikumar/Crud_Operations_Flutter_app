import 'package:flutter/material.dart';

class DeleteDataScreen extends StatelessWidget {
  const DeleteDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Data'),
      ),
      body: const Center(
        child: Text('Delete Data Screen'),
      ),
    );
  }
}
