// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 5),
      () {
        Navigator.pushReplacementNamed(context, "/home");
      },
    );
    return SafeArea(
        child: Scaffold(
      body: AnimateGradient(
        primaryColors: const [
          Color.fromARGB(255, 37, 126, 194),
          Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 80, 239, 160),
        ],
        secondaryColors: const [
          Color.fromARGB(255, 80, 239, 160),
          Colors.white,
          Color.fromARGB(255, 37, 126, 194),
        ],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Image.asset('images/player.png'),
            )
          ],
        ),
      ),
    ));
  }
}
