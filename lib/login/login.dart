import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:test_empty_1/home/home.dart';
import 'package:test_empty_1/login/register.dart';
import 'package:test_empty_1/services/database_services.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final loginEmail = _emailController.text;
    final loginPassword = _passwordController.text;

    // Add your login logic here
    if (loginEmail.isNotEmpty && loginPassword.isNotEmpty) {
      try {
        var uri = Uri.parse('http://localhost:8080/users?email=$loginEmail&password=$loginPassword');
        var response = await http.get(uri);
        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        } else { 
        _showErrorDialog("email and password combination doesn't exist");
        }
      } catch (e) {
        print('Error fetching data: $e');
      }
    } else {
      _showErrorDialog('Please enter LoginUsername and LoginPassword');
    }
  }
  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Register()),
    );
  }
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login/Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true, // Mask the LoginPassword input
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(onPressed: _login, child: const Text('Login'),),
            ElevatedButton(onPressed: _register, child: const Text('Register'))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
