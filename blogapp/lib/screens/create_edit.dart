import 'package:blogapp/services/api_service.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      titleController.text = widget.title!;
      contentController.text = widget.content!;
    }
  }

  Future<void> saveBlogPost() async {
    if (widget.id == null) {
      await apiService.createBlogPost(titleController.text, contentController.text);
    } else {
      await apiService.updateBlogPost(widget.id!, titleController.text, contentController.text);
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
