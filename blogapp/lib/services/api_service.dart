import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';

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
  
  Future<http.Response> getBlogPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/blogposts/'));
    return response;
  }

  Future<http.Response> createBlogPost(String title, String content, File imageFile, String? imageName) async {
    var uri = Uri.parse('$baseUrl/blogposts/');
    var request = http.MultipartRequest('POST', uri)
      ..fields['title'] = title
      ..fields['content'] = content;
    
    var multipartFile = await http.MultipartFile.fromPath('image', imageFile.path);
    request.files.add(multipartFile);

    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  Future<http.Response> updateBlogPost(int id, String title, String content, Uint8List? imageData, String? imageName) async {
    var uri = Uri.parse('$baseUrl/blogposts/$id/');
    var request = http.MultipartRequest('PUT', uri)
      ..fields['title'] = title
      ..fields['content'] = content;
    if (imageData != null && imageName != null) {
      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageData,
        filename: imageName,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);
    }
    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  Future<http.Response> deleteBlogPost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/blogposts/$id/'));
    return response;
  }
}
