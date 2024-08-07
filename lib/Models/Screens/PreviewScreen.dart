import 'package:flutter/material.dart';
import 'dart:io';

class PreviewDialog extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final File? image;
  final VoidCallback onConfirm;
  final VoidCallback onEdit;

  const PreviewDialog({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.onConfirm,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Data'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            image != null
                ? Image.file(image!, height: 100, width: 100, fit: BoxFit.cover)
                : const Text('No image selected.'),
            const SizedBox(height: 10),
            Text('Name: $name'),
            const SizedBox(height: 10),
            Text('Email: $email'),
            const SizedBox(height: 10),
            Text('Phone: $phone'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onEdit,
          child: const Text('Edit'),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
