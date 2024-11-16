// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Himnario ID",
          style: TextStyle(color: Colors.black),
        ),
        const SizedBox(
          height: 35,
        ),
        Center(
          child: Image.asset(
            "assets/BAUTIZOS.png",
            width: 350,
          ),
        ),
      ],
    );
  }
}
