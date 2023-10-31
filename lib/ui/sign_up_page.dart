import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parking_assist/ui/login_page.dart';
import 'package:parking_assist/utils/utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0), // Add some spacing
              CheckboxListTile(
                  value: _isAdmin,
                  title: const Text('Admin?'),
                  onChanged: (isAdmin) => setState(() => _isAdmin = isAdmin!)),

              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  signUpUser(_emailController.text.trim(),
                      _passwordController.text.trim());
                },
                child: const Text('Sign Up'),
              ),
              TextButton(
                onPressed: () {
                  Utils.pushToNewRoute(context, const LoginPage());
                },
                child: const Text('Already have an account? Log In'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUpUser(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        if (context.mounted) {
          addUserToFireStore(result.user!.uid, email, true);
        } else {
          if (context.mounted) {
            Utils.showCustomAlertDialog(context, 'Error', 'Failed');
          }
        }
      } else {
        debugPrint('Failed');
      }
    } catch (e) {
      if (context.mounted) {
        Utils.showCustomAlertDialog(context, 'Error', e.toString());
      }
    }
  }

  Future<void> addUserToFireStore(
      String uid, String email, bool isAdmin) async {
    try {
      final now = DateTime.now();
      final formatter = DateFormat('dd:MM:yyyy HH:mm:ss.SSS');
      final formattedDate = formatter.format(now);
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email,
        'admin': _isAdmin,
        'createdOn': formattedDate
      }).whenComplete(() {
        Utils.pushToNewRouteAndClearAll(context, const LoginPage());
      });
    } catch (e) {
      debugPrint('Error adding user to FireStore: $e');
    }
  }
}
