import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../spreedsheets/UserFileds.dart';
import '../../spreedsheets/user_sheets_api.dart';
import 'ButtonWidget.dart';
import 'PreviewScreen.dart'; // Ensure the correct path

class FormScreenWidget extends StatefulWidget {
  const FormScreenWidget({super.key});

  @override
  _FormScreenWidgetState createState() => _FormScreenWidgetState();
}

class _FormScreenWidgetState extends State<FormScreenWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else if (kDebugMode) {
        print('No image selected.');
      }
    });
  }

  String generateUniqueId() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('ddMMyy').format(now);
    int sequenceNumber = getNextSequenceNumberForDate(formattedDate);

    return '$formattedDate$sequenceNumber';
  }

  int getNextSequenceNumberForDate(String date) {
    if (!_sequenceMap.containsKey(date)) {
      _sequenceMap[date] = 1;
    } else {
      _sequenceMap[date] = _sequenceMap[date]! + 1;
    }
    return _sequenceMap[date]!;
  }

  final Map<String, int> _sequenceMap = {};

  Future<void> insertUsers() async {
    try {
      String? base64Image;
      if (_image != null) {
        final bytes = await _image!.readAsBytes();
        img.Image? originalImage = img.decodeImage(bytes);
        if (originalImage != null) {
          img.Image resizedImage = img.copyResize(originalImage, width: 400, height: 400);
          base64Image = base64Encode(img.encodeJpg(resizedImage, quality: 70));

          if (base64Image.length > 50000) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image is too large to be saved. Please select a smaller image.')),
            );
            return;
          }
        }
      }

      final newUser = user(
        id: int.parse(generateUniqueId()), // Generate the unique ID
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        image: base64Image,
      );

      final jsonUser = newUser.toJson();
      await UserSheetsApi.insert([jsonUser]);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting users: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving data.')),
      );
    }
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PreviewDialog(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          image: _image,
          onConfirm: () async {
            Navigator.of(context).pop();
            if (_formKey.currentState!.validate()) {
              await insertUsers();
            }
          },
          onEdit: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_image == null)
              Center(
                child: Text(
                  'No image selected.',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    _image!,
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Capture Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Select from Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextFormField(
                    controller: _nameController,
                    label: 'Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextFormField(
                    controller: _emailController,
                    label: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextFormField(
                    controller: _phoneController,
                    label: 'Phone',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ButtonWidget(
              text: 'Save',
              onClicked: _showPreviewDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
