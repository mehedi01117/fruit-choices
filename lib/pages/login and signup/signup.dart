import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // আপনার সঠিক Vercel URL (এখানে কোনো ভুল নেই)
  final String baseUrl = "https://fruit-apps.vercel.app/api";

  void _handleSignup() async {
    // ইমেইল বা পাসওয়ার্ড খালি থাকলে মেসেজ দেখাবে
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("দয়া করে ইমেইল এবং পাসওয়ার্ড লিখুন"), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final url = Uri.parse('$baseUrl/signup');
      print("Sending data to: $url");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      ).timeout(const Duration(seconds: 15)); // ১৫ সেকেন্ডের মধ্যে রেসপন্স না আসলে টাইমআউট হবে

      print("Vercel Response Status: ${response.statusCode}");
      print("Vercel Response Body: ${response.body}");

      final responseData = jsonDecode(response.body);

      setState(() { _isLoading = false; });

      if (response.statusCode == 201) {
        // রেজিস্ট্রেশন সফল হলে সবুজ রঙের মেসেজ আসবে
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? "রেজিস্ট্রেশন সফল হয়েছে!"), backgroundColor: Colors.green),
        );
        
        // সফল হওয়ার পর টেক্সট ফিল্ডগুলো খালি করে দেওয়া
        _emailController.clear();
        _passwordController.clear();
      } else {
        // কোনো সার্ভার এরর হলে লাল মেসেজ দেখাবে
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['error'] ?? "ব্যর্থ হয়েছে!"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() { _isLoading = false; });
      print("Catch Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("কানেকশন সমস্যা: ${e.toString()}"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signup Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            _isLoading 
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleSignup,
                    child: const Text("Sign Up", style: TextStyle(fontSize: 18)),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}