import 'package:blogapp/screens/create_edit.dart';
import 'package:blogapp/services/api_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';


class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ApiService apiService = ApiService();
  List<dynamic> blogPosts = [];

  @override
  void initState() {
    super.initState();
    fetchBlogPosts();
  }

  Future<void> fetchBlogPosts() async {
    final response = await apiService.getBlogPosts();
    if (response.statusCode == 200) {
      setState(() {
        blogPosts = jsonDecode(response.body);
      });
    } else {
      // Handle error
    }
  }

  Future<void> deleteBlogPost(int id) async {
    final response = await apiService.deleteBlogPost(id);
    if (response.statusCode == 204) {
      fetchBlogPosts();
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Posts'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Navigator.pop(context);
            print('Logged out Successfully!');
          },
        )
      ),
      body: ListView.builder(
        itemCount: blogPosts.length,
        itemBuilder: (context, index) {
          final post = blogPosts[index];
          return ListTile(
            title: Text(post['title']),
            subtitle: Text(post['content']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateEditBlogPost(
                          id: post['id'],
                          title: post['title'],
                          content: post['content'],
                        ),
                      ),
                    ).then((value) => fetchBlogPosts());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteBlogPost(post['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEditBlogPost(),
            ),
          ).then((value) => fetchBlogPosts());
        },
      ),
    );
  }
}
