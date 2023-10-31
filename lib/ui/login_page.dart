import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking_assist/ui/home_admin_page.dart';
import 'package:parking_assist/ui/home_user_page.dart';
import 'package:parking_assist/ui/sign_up_page.dart';
import 'package:parking_assist/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
              const SizedBox(height: 16.0), // Add some spacing
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Password is hidden
              ),
              const SizedBox(height: 16.0), // Add some spacing
              ElevatedButton(
                onPressed: () {
                  loginUser(_emailController.text.trim(),
                      _passwordController.text.trim());
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Utils.pushToNewRoute(context, const SignUpPage());
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginUser(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        fetchAdminStatus(result.user!.uid);
      } else {
        if (context.mounted) {
          Utils.showCustomAlertDialog(context, 'Error', 'Failed');
        }
      }
    } catch (e) {
      if (context.mounted) {
        Utils.showCustomAlertDialog(context, 'Error', e.toString());
      }
    }
  }

  Future<void> fetchAdminStatus(String uid) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        final isAdmin = data['admin'] ?? false;
        if (context.mounted) {
          if (isAdmin) {
            Utils.pushToNewRouteAndClearAll(context, const HomeAdminPage());
          } else {
            Utils.pushToNewRouteAndClearAll(context, const HomeUserPage());
          }
        }
      } else {
        if (context.mounted) {
          Utils.showCustomAlertDialog(context, 'Error', 'User does not exits');
        }
      }
    } catch (e) {
      if (context.mounted) {
        Utils.showCustomAlertDialog(
            context, 'Error', 'Error fetching admin status: $e');
      }

      debugPrint('Error fetching admin status: $e');
    }
  }
}
