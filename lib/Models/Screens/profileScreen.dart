import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:capture/spreedsheets/user_sheets_api.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  String _email = '';
  String _phone = '';
  String _imageUrl = '';
  bool _showProfile = false;
  bool _hasProfileData = false;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchProfileData() async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      try {
        final data = await UserSheetsApi.getProfileDataByName(name);
        if (data != null) {
          setState(() {
            _name = data['name'] ?? '';
            _email = data['email'] ?? '';
            _phone = data['phone'] ?? '';
            _imageUrl = data['image'] ?? '';
            _showProfile = true;
            _hasProfileData = true;
          });
        } else {
          setState(() {
            _name = 'No data found';
            _email = '';
            _phone = '';
            _imageUrl = '';
            _showProfile = true;
            _hasProfileData = false;
          });
        }
      } catch (e) {
        print('Error fetching data: $e');
        setState(() {
          _name = 'Error';
          _email = '';
          _phone = '';
          _imageUrl = '';
          _showProfile = true;
          _hasProfileData = false;
        });
      }
    }
  }

  Future<void> _deleteProfile() async {
    try {
      await UserSheetsApi.deleteProfileByName(_name);
      setState(() {
        _name = '';
        _email = '';
        _phone = '';
        _imageUrl = '';
        _showProfile = false;
        _hasProfileData = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Profile deleted successfully'),
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting profile: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error deleting profile'),
      ));
    }
  }

  Future<void> _showUpdateForm() async {
    final updateNameController = TextEditingController(text: _name);
    final updateEmailController = TextEditingController(text: _email);
    final updatePhoneController = TextEditingController(text: _phone);
    String? updateImageUrl = _imageUrl;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: updateNameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: updateEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: updatePhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                updateImageUrl != null
                    ? Image.memory(base64Decode(updateImageUrl!))
                    : const Icon(Icons.account_circle, size: 100),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      final bytes = await pickedFile.readAsBytes();
                      setState(() {
                        updateImageUrl = base64Encode(bytes);
                      });
                    }
                  },
                  child: const Text('Pick Image'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateProfile(
                  updateNameController.text,
                  updateEmailController.text,
                  updatePhoneController.text,
                  updateImageUrl,
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateProfile(String name, String email, String phone, String? imageUrl) async {
    try {
      final updatedData = {
        'name': name,
        'email': email,
        'phone': phone,
        'image': imageUrl ?? '',
      };
      await UserSheetsApi.updateProfileByName(_name, updatedData);
      setState(() {
        _name = name;
        _email = email;
        _phone = phone;
        _imageUrl = imageUrl ?? '';
        _showProfile = true;
        _hasProfileData = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Profile updated successfully'),
      ));
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error updating profile'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_showProfile) ...[
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchProfileData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text('Search'),
                  ),
                ] else ...[
                  _imageUrl.isNotEmpty
                      ? Image.memory(base64Decode(_imageUrl))
                      : const Icon(Icons.account_circle, size: 100),
                  const SizedBox(height: 16),
                  Text('Name: $_name'),
                  Text('Email: $_email'),
                  Text('Phone: $_phone'),
                  const SizedBox(height: 16),
                  if (_hasProfileData) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _deleteProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                          ),
                          child: const Text('Delete'),
                        ),
                        ElevatedButton(
                          onPressed: _showUpdateForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                          ),
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
