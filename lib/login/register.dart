import 'package:flutter/material.dart';
import 'package:test_empty_1/login/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode
import 'package:test_empty_1/config.dart';

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

    // final emailRegExp = RegExp(r'^[^@]+@[^@]+$');
    // final passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');

    if (username.isNotEmpty &&
        password.isNotEmpty &&
        reenterPassword.isNotEmpty &&
        phoneNumber.isNotEmpty) {
      if (password != reenterPassword) {
        _showErrorDialog('Passwords do not match');
        return;
      } 
      // Uncomment and adjust validation as needed
      // else if (!emailRegExp.hasMatch(email)) {
      //   _showErrorDialog('Email must have @!');
      //   return;
      // } 
      // else if (!passwordRegExp.hasMatch(password)) {
      //   _showErrorDialog('Password must have at least one uppercase, one lowercase, and one digit');
      //   return;
      // }

      var uri = Uri.parse('${Config.baseUrl}/register');
      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
        }),
      );
      if (response.statusCode == 200) {
        print("User information created successfully");
        _showSuccessDialog();
      } else {
        _showErrorDialog('Failed to register. Please try again.');
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
        content: const Text('Redirecting to Login Page...'),
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
        title: const Text('Register'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.person_add,
                size: 100,
                color: Colors.teal,
              ),
              const SizedBox(height: 20.0),
              RegistrationForm(
                usernameController: _usernameController,
                passwordController: _passwordController,
                reenterPasswordController: _reenterPasswordController,
                phoneNumberController: _phoneNumberController,
                emailController: _emailController,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _reenterPasswordController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
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
        prefixIcon: labelText == 'Password' || labelText == 'Reenter Password'
            ? Icon(Icons.lock)
            : Icon(Icons.person),
        labelText: labelText,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        const SizedBox(height: 16.0),
        CustomTextField(
          controller: passwordController,
          labelText: 'Password',
          obscureText: true,
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          controller: reenterPasswordController,
          labelText: 'Reenter Password',
          obscureText: true,
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          controller: phoneNumberController,
          labelText: 'Phone Number',
        ),
      ],
    );
  }
}
