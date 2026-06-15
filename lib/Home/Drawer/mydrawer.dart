import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:fruit_choices/Home/home_page.dart';
import 'package:fruit_choices/main.dart';
import 'package:fruit_choices/pages/login%20and%20signup/login.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class Mydrawer extends StatefulWidget {
  

  const Mydrawer({super.key, });

  @override
  State<Mydrawer> createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  String? name;
  String? email;
  Uint8List? _profileImage;
  bool _isLoadingUserData = true;
  // Load the profile image from the Hive box.
  Future<void> _loadProfileImage() async {
    var authBox = await Hive.openBox('authBox');
    setState(() {
      _profileImage =
          authBox.get('profileImage') ?? authBox.get('profileImage');
    });
  }

  // Update the state of the app.
  Future<void> _updateProfileImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedImage != null) {
      Uint8List imageBytes = await pickedImage.readAsBytes();

      var authBox = await Hive.openBox('authBox');
      authBox.put('profileImage', imageBytes);
      setState(() {
        _profileImage = imageBytes;
      });
    }
  }

  Future<void> _fetchUserData() async {
    try {
      var authBox = await Hive.openBox('authBox');
      setState(() {
        name = authBox.get('user_name', defaultValue: 'Null');
        email = authBox.get('user_email', defaultValue: 'Null');
        _isLoadingUserData = false;
      });
      
    } catch (e) {
      print("Error fetching user data in Drawer: $e");
      setState(() {
        _isLoadingUserData = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _fetchUserData();
  }

 void _handleLogout() async {
    try {
      // Appwrite সেশন ডিলিট করা
      final account = Account(client);
      await account.deleteSession(sessionId: 'current');
      
      // Hive বক্স ক্লিয়ার করা
      var authBox = Hive.box('authBox');
      await authBox.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logout Successfully")),
      );
      Get.offAll(() => const Login());
    } catch (e) {
      print("Logout failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
   final Uint8List? profileImage = _profileImage;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(193, 2, 19, 32)),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _updateProfileImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.amber,
                    backgroundImage: profileImage != null ? MemoryImage(profileImage) : null,
                    child: profileImage == null
                        ? Text(
                            // নাম লোড হওয়ার পর প্রথম অক্ষর দেখাবে, না হলে 'U' দেখাবে
                            name != null && name!.isNotEmpty ? name![0].toUpperCase() : "U",
                            style: const TextStyle(
                              fontSize: 26,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                      
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(name ?? "User", style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          SizedBox(width: 10),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Get.offAll(() => HomePage());
              },
              child: Row(
                children: [
                  Text(
                    "1.",
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(width: 10),

                  Text(
                    "Home",
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const Spacer(),
                  Icon(Icons.home, color: Colors.black),
                ],
              ),
            ),
          ),
          Divider(
            color: const Color.fromARGB(92, 0, 0, 0),
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: _handleLogout,
              child: Row(
                children: [
                  Text(
                    "2.",
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(width: 10),

                  Text(
                    "Logout",
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const Spacer(),
                  Icon(Icons.logout_outlined, color: Colors.black),
                ],
              ),
            ),
          ),
          Divider(
            color: const Color.fromARGB(92, 0, 0, 0),
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: _handleLogout,
              child: Row(
                children: [
                  Text(
                    "3.",
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(width: 10),

                  Text(
                    "Logout",
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const Spacer(),
                  Icon(Icons.logout_outlined, color: Colors.black),
                ],
              ),
            ),
          ),
          Divider(
            color: const Color.fromARGB(92, 0, 0, 0),
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: _handleLogout,
              child: Row(
                children: [
                  Text(
                    "4.",
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(width: 10),

                  Text(
                    "Logout",
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const Spacer(),
                  Icon(Icons.logout_outlined, color: Colors.black),
                ],
              ),
            ),
          ),
          Divider(
            color: const Color.fromARGB(92, 0, 0, 0),
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: _handleLogout,
              child: Row(
                children: [
                  Text(
                    "5.",
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(width: 10),

                  Text(
                    "Logout",
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const Spacer(),
                  Icon(Icons.logout_outlined, color: Colors.black),
                ],
              ),
            ),
          ),
          Divider(
            color: const Color.fromARGB(92, 0, 0, 0),
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: _handleLogout,
              child: Row(
                children: [
                  Text(
                    "6.",
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(width: 10),

                  Text(
                    "Logout",
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ),
                  const Spacer(),
                  Icon(Icons.logout_outlined, color: Colors.red),
                ],
              ),
            ),
          ),
          Divider(
            color: const Color.fromARGB(92, 0, 0, 0),
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
        ],
      ),
      // Update the state of the app.
    );
  }
}
