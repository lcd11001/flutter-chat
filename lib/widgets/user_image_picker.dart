import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File image) pickedImage;
  final double radius;

  const UserImagePicker({
    super.key,
    required this.pickedImage,
    this.radius = 200,
  });

  @override
  State<StatefulWidget> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: widget.radius * 2,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.pickedImage(_pickedImageFile!);
  }

  dynamic _getImageProvider() {
    if (_pickedImageFile != null) {
      return FileImage(_pickedImageFile!);
    }

    return const AssetImage('assets/images/user.png');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.onPrimary,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: widget.radius,
                  backgroundColor: Colors.grey,
                  foregroundImage: _getImageProvider(),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.tertiary,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: colorScheme.onTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
