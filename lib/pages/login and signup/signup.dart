import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fruit_choices/pages/login%20and%20signup/login.dart';
import 'package:fruit_choices/pages/login%20and%20signup/mytextfile.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final String baseUrl = "https://fruit-backed.vercel.app/api";

  void _handleSignup() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("দয়া করে নাম, ইমেইল এবং পাসওয়ার্ড লিখুন"),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('$baseUrl/signup');
      print("Sending data to: $url");

      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},

            body: jsonEncode({
              "name": _nameController.text.trim(),
              "email": _emailController.text.trim(),
              "password": _passwordController.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 15));

      print("Vercel Response Status: ${response.statusCode}");
      print("Vercel Response Body: ${response.body}");

      final responseData = jsonDecode(response.body);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? "রেজিস্ট্রেশন সফল হয়েছে!",
            ),
            backgroundColor: Colors.green,
          ),
        );

        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        Get.off(() => Login());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['error'] ?? "plase try again"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Catch Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("connection error ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    // ৫. পরিবর্তন: নেম কন্ট্রোলার ডিসপোজ করা হয়েছে
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 80,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Signup Page",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      width: 400,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Mytextfile(
                              controller: _nameController,
                              lavelText: "Name",
                              obscureText: false,
                              icon: Icons.person,
                            ),
                            Mytextfile(
                              controller: _emailController,
                              lavelText: "Email",
                              obscureText: false,
                              icon: Icons.email,
                            ),
                            Mytextfile(
                              controller: _passwordController,
                              lavelText: "Password",
                              obscureText: true,
                              icon: Icons.lock,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(
                                  122,
                                  255,
                                  255,
                                  255,
                                ),
                              ),
                              onPressed: _handleSignup,
                              child:
                                  _isLoading
                                      ? CircularProgressIndicator()
                                      : Text(
                                        "Signup",
                                        style: TextStyle(color: Colors.white),
                                      ),
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
