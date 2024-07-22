import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:test_empty_1/home/home.dart';
import 'package:test_empty_1/login/register.dart';
import 'package:test_empty_1/services/database_services.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  void _login() async {
    final loginUsername = _usernameController.text;
    final loginPassword = _passwordController.text;

    // Add your login logic here
    if (loginUsername.isNotEmpty && loginPassword.isNotEmpty) {
      if (loginUsername.isNotEmpty) {
        // Perform login
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } else {
      // Show error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter LoginUsername and LoginPassword'),
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
  }
  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Register()),
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
              controller: _usernameController,
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
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
