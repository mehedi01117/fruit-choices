import 'package:flutter/material.dart';

class BottmHome extends StatefulWidget {
  final String name;

  const BottmHome({super.key, required this.name});

  @override
  State<BottmHome> createState() => _BottmHomeState();
}

class _BottmHomeState extends State<BottmHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(widget.name)));
  }
}
