import 'package:flutter/material.dart';
import 'package:fruit_choices/Home/home_page.dart';
import 'package:fruit_choices/pages/login%20and%20signup/login.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isloading = true;
  String? name;
  String? email;
  bool isloggedin = false;
   Future<void> cheackloginStatus() async {
     var authBox = await Hive.openBox('authBox');
     setState(() {
       name = authBox.get('user_name');
       email = authBox.get('user_email');
       isloggedin = authBox.get('isloggedin', defaultValue: false);
       isloading = false;
     });
   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cheackloginStatus();
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!isloggedin || name == null || email == null) {
      return Login();
    }
    return HomePage();
  }
}
 