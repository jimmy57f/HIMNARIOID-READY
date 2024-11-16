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
          style: TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 255, 5, 5),
              fontWeight: FontWeight.bold),
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
