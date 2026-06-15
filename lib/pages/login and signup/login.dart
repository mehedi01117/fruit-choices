import 'dart:ui';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:fruit_choices/Home/home_page.dart';
import 'package:fruit_choices/main.dart';

import 'package:fruit_choices/pages/login%20and%20signup/mytextfile.dart';
import 'package:fruit_choices/pages/login%20and%20signup/signup.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all the fields.")),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try{
      final Account account = Account(client);
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      print("Login successful. Session ID: ${session.$id}");
      final user = await account.get();
      
      var authBox = Hive.box('authBox');
      authBox.put('user_name', user.name);
      authBox.put('user_email', user.email);
      authBox.put('isloggedin', true);
      Get.offAll(() =>  HomePage());
    }
    catch (error) {
      print("Login failed: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed. Please try again.")),
      );

    }
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/login.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                          color: const Color.fromARGB(122, 255, 255, 255),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "Login Page",
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            Mytextfile(
                              controller: _emailController,
                              lavelText: "Email",
                              icon: Icons.email,
                              obscureText: false,
                            ),
                            Mytextfile(
                              controller: _passwordController,
                              lavelText: "Password",
                              icon: Icons.lock,
                              obscureText: true,
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(
                                  55,
                                  255,
                                  255,
                                  255,
                                ),
                              ),
                              onPressed: _handleLogin,
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      )
                                      : Text("Login"),
                            ),

                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.off(() => SignupScreen());
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
