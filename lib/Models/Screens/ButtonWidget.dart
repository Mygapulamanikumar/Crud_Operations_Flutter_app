import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Makes the button as wide as its parent
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal, // Set background color
          minimumSize: const Size.fromHeight(50), // Minimum height
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          elevation: 5, // Add shadow for elevation
          padding: const EdgeInsets.all(16), // Uniform padding
        ),
        onPressed: onClicked,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18, // Adjust font size
            fontWeight: FontWeight.bold, // Bold text
            color: Colors.white, // Text color
          ),
          textAlign: TextAlign.center, // Center align text
        ),
      ),
    );
  }
}
