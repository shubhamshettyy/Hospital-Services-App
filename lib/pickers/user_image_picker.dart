import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
  final String sentPickedImage;

  UserImagePicker(
    this.imagePickFn, {
    this.sentPickedImage,
  });
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    final pickedImageFile = File(imageFile.path);

    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: (_pickedImage == null)
              ? (widget.sentPickedImage != null
                  ? NetworkImage(widget.sentPickedImage)
                  : null)
              : FileImage(_pickedImage),
          backgroundColor: Colors.grey,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add an Image'),
        ),
      ],
    );
  }
}
