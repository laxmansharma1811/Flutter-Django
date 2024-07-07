import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api';
  final storage = FlutterSecureStorage();

  Future<http.Response> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );
    return response;
  }

  Future<http.Response> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      await storage.write(key: 'access', value: data['access']);
      await storage.write(key: 'refresh', value: data['refresh']);
    }
    return response;
  }

  Future<void> logout() async {
    await storage.deleteAll();
  }
  
  // CRUD 
   Future<http.Response> getBlogPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/blogposts/'));
    return response;
  }

  Future<http.Response> createBlogPost(String title, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/blogposts/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'content': content}),
    );
    return response;
  }

  Future<http.Response> updateBlogPost(int id, String title, String content) async {
    final response = await http.put(
      Uri.parse('$baseUrl/blogposts/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'content': content}),
    );
    return response;
  }

  Future<http.Response> deleteBlogPost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/blogposts/$id/'));
    return response;
  }
}
