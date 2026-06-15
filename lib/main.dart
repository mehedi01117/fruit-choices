import 'package:flutter/material.dart';

import 'package:fruit_choices/pages/wrapper.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:appwrite/appwrite.dart' show Client;

final Client client = Client();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  var authBox = await Hive.openBox('authBox');
        

  client
      .setEndpoint('https://fra.cloud.appwrite.io/v1')
      .setProject('6a297cb400054ed90d6a')
      .setSelfSigned(status: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fruit Choices',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:  Wrapper(),
    );
  }
}
