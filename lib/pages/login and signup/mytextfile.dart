import 'package:flutter/material.dart';

class Mytextfile extends StatefulWidget {
  final TextEditingController controller;
  final String lavelText;
  final bool obscureText;
  final IconData? icon;

  const Mytextfile({
    super.key,
    required this.controller,
    required this.lavelText,
    required this.obscureText,
    this.icon,
  });

  @override
  State<Mytextfile> createState() => _MytextfileState();
}

class _MytextfileState extends State<Mytextfile> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      decoration: InputDecoration(
        labelText: widget.lavelText,

        suffixIcon: Icon(
          widget.icon,
          color: Color.fromARGB(255, 255, 255, 255),
        ),

        labelStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(129, 247, 247, 247),
            width: 2,
          ),
        ),
      ),
    );
  }
}
