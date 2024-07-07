import 'package:blogapp/screens/homepage.dart';
import 'package:blogapp/screens/register_page.dart';
import 'package:blogapp/services/api_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final ApiService apiService = ApiService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                print('Login button pressed');
                try {
                  final response = await apiService.login(
                    usernameController.text,
                    passwordController.text,
                  );
                  print('API response: ${response.statusCode}');
                  if (response.statusCode == 200) {
                    print('Login successful, navigating to homepage');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login successful')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  } else {
                    print('Login failed');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login failed')),
                    );
                  }
                } catch (e) {
                  print('Error during login: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('An error occurred')),
                  );
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
