import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:test_empty_1/login/login.dart';
import 'package:http/http.dart' as http;
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reenterPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final reenterPassword = _reenterPasswordController.text;
    final phoneNumber = _phoneNumberController.text;
    final email = _emailController.text;

    final emailRegExp = RegExp(r'^[^@]+@[^@]+$');
    final passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');
    // Login logic
    if (username.isNotEmpty && password.isNotEmpty && reenterPassword.isNotEmpty && phoneNumber.isNotEmpty) {
      if (password != reenterPassword) { _showErrorDialog('Passwords do not match'); return;} 
      // else if (!emailRegExp.hasMatch(email)) { _showErrorDialog('Email must have @!'); return;}
      // else if (!passwordRegExp.hasMatch(password)) {_showErrorDialog('Password must have at least one uppercase, one lowercase and one alphabet'); return;}
      
      var uri = Uri.parse('http://localhost:8080/register');
      var response = await http.post(
        uri,
        body: {
          'username': username,
          'user_email': email,
          'user_password': password,
          'user_phone_number': phoneNumber,
        },
      );
      if (response.statusCode == 200) {
        print("create user information successfully, return;");
        _showSuccessDialog();
      }
    } else {
      _showErrorDialog('Please check missing input');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register Successful'),
        content: const Text('Redirect to Login Page...'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
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
        title: const Text('Register/Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.catching_pokemon),
            RegistrationForm(
              usernameController: _usernameController,
              passwordController: _passwordController,
              reenterPasswordController: _reenterPasswordController,
              phoneNumberController: _phoneNumberController,
              emailController: _emailController,
            ),
            const SizedBox(height: 16.0), // Add space between form and button
            ElevatedButton(
              onPressed: _register, // Pass the method without parentheses
              child: const Text('Register'),
            ),
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

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      obscureText: obscureText,
    );
  }
}

class RegistrationForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController reenterPasswordController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  const RegistrationForm({
    required this.usernameController,
    required this.passwordController,
    required this.reenterPasswordController,
    required this.phoneNumberController,
    required this.emailController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomTextField(
          controller: usernameController,
          labelText: 'Username',
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          controller: emailController,
          labelText: 'Email',
        ),
        CustomTextField(
          controller: passwordController,
          labelText: 'Password',
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          controller: reenterPasswordController,
          labelText: 'Reenter Password',
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          controller: phoneNumberController,
          labelText: 'Phone Number',
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}