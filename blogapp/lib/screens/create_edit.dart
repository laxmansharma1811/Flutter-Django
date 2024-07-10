import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:typed_data';
import 'package:blogapp/services/api_service.dart';

class CreateEditBlogPost extends StatefulWidget {
  final int? id;
  final String? title;
  final String? content;

  CreateEditBlogPost({this.id, this.title, this.content});

  @override
  _CreateEditBlogPostState createState() => _CreateEditBlogPostState();
}

class _CreateEditBlogPostState extends State<CreateEditBlogPost> {
  final ApiService apiService = ApiService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  Uint8List? _imageData;
  String? _imageName;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      titleController.text = widget.title!;
      contentController.text = widget.content!;
    }
  }

  Future<void> _pickImage() async {
    final imageFile = await ImagePickerWeb.getImageAsBytes();
    if (imageFile != null) {
      setState(() {
        _imageData = imageFile;
        _imageName = 'uploaded_image.png'; // You can also get the original filename if needed
      });
    }
  }

  Future<void> saveBlogPost() async {
    if (widget.id == null) {
      await apiService.createBlogPost(titleController.text, contentController.text, _imageData as File, _imageName);
    } else {
      await apiService.updateBlogPost(widget.id!, titleController.text, contentController.text, _imageData, _imageName);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Create Blog Post' : 'Edit Blog Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            SizedBox(height: 16),
            _imageData == null
                ? Text('No image selected.')
                : Image.memory(_imageData!),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: saveBlogPost,
              child: Text(widget.id == null ? 'Create' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
