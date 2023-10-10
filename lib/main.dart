import 'package:bcalculator/calculator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BCalculator());
}

class BCalculator extends StatelessWidget {
  const BCalculator({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bsoft Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: Scaffold(body: SafeArea(child: Calculator())),
    );
  }
}

