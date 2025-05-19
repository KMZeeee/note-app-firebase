import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorCode = "";

  void navigateRegister() {
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, 'register');
  }

  void navigateHome() {
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, 'home');
  }

  void signIn() async {
    setState(() {
      _isLoading = true;
      _errorCode = "";
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      navigateHome();
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: 'Login Successful',
          body: 'Welcome back, ${_emailController.text}!',
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorCode = e.code;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to your account'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ListView(
            children: [
              const SizedBox(height: 48),
              Icon(Icons.login_outlined, size: 100),
              const SizedBox(height: 48),
              TextFormField(
                controller: _emailController,
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                  label: Text('Email'),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  floatingLabelStyle: TextStyle(color: Colors.blue),
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                cursorColor: Colors.blue,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text('Password'),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  floatingLabelStyle: TextStyle(color: Colors.blue),
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 24),
              _errorCode != ""
                  ? Column(
                    children: [Text(_errorCode), const SizedBox(height: 24)],
                  )
                  : const SizedBox(height: 0),
              FilledButton(
                onPressed: signIn,
                style: FilledButton.styleFrom(backgroundColor: Colors.black),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: navigateRegister,
                    child: const Text(
                      'Register here!',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
