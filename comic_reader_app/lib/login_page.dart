import 'package:comic_reader_app/handler/authentication_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = true;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final authenticationHandler =
            Provider.of<AuthenticationHandler>(context, listen: false);
        authenticationHandler.login(_username!, _password!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } catch (e) {
        // Handle login error
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Login Failed'),
              content: const Text('Invalid username or password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _continueAsGuest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(username: null),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a username' : null,
                onSaved: (value) => _username = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () => _toggleObscureText(),
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                obscureText: _obscureText,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a password' : null,
                onSaved: (value) => _password = value,
                obscuringCharacter: "*",
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: ElevatedButton(
                      onPressed: _continueAsGuest,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Continue as Guest'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
