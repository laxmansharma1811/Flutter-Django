import 'package:blogapp/screens/create_edit.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:blogapp/services/api_service.dart';

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
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch blog posts'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> deleteBlogPost(int id) async {
    final response = await apiService.deleteBlogPost(id);
    if (response.statusCode == 204) {
      fetchBlogPosts();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to delete blog post'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Posts'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
              print('Logged out Successfully!');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("User Name"),
              accountEmail: Text("user@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "U",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Blog'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateEditBlogPost(),
                  ),
                );
                fetchBlogPosts();
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: blogPosts.length,
        itemBuilder: (context, index) {
          final post = blogPosts[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post['image'] != null)
                  Image.network('http://127.0.0.1:8000${post['image']}'), // Replace with your actual backend URL
                ListTile(
                  title: Text(post['title']),
                  subtitle: Text(post['content']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateEditBlogPost(
                                id: post['id'],
                                title: post['title'],
                                content: post['content'],
                              ),
                            ),
                          );
                          fetchBlogPosts();
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
