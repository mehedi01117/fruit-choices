import 'dart:ui';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:fruit_choices/main.dart';
import 'package:fruit_choices/pages/login%20and%20signup/login.dart';
import 'package:fruit_choices/pages/login%20and%20signup/mytextfile.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';

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

  void _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all the fields.")),
      );
      return;
    }
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be at least 8 characters long."),
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final Account account = Account(client);
      final Databases databases = Databases(client);

      models.User user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      print("Auth Account Created. ID: ${user.$id}");

      await databases.createDocument(
        databaseId: "6a297e78001c34c4281f",
        collectionId: "users",
        documentId: user.$id,
        data: {"name": name, "email": email},
      );

      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      var authBox = await Hive.openBox('authBox');
      await authBox.put('isloggedin', true);
      await authBox.put('user_name', name);
      await authBox.put('user_email', email);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Signup successful!")));
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      Get.offAll(() => const Login());
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print("Appwrite Actual Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceAll("AppwriteException:", "")),
        ),
      );
    }
  }

  @override
  void dispose() {
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
                image: AssetImage("assets/login.jpg"),
                fit: BoxFit.cover,
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
                        border: Border.all(
                          width: 2,
                          color: const Color.fromARGB(122, 255, 255, 255),
                        ),
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
