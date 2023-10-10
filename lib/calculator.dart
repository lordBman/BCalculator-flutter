import 'package:bcalculator/components/display.dart';
import 'package:bcalculator/components/keypad.dart';
import 'package:flutter/material.dart';

class Calculator extends StatefulWidget{
  const Calculator({super.key});

    @override
    State<StatefulWidget> createState() => __CalculatorState();
}

class __CalculatorState extends State<Calculator>{
    bool proceed = false;
    String problem = "";
    
    void add(String character){
       setState(() {
          problem += character;
          proceed = false;
       });
    }

    void solve() => setState(() {
      proceed = true;
    });

    void clear(){
        setState(() {
            problem = "";
            proceed = false;
        });
    }

    void backspace(){
        if(problem.isNotEmpty){
            setState(() {
                problem = problem.substring(0, problem.length - 1);
                proceed = false;
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
            Expanded(child: Display(solve: proceed, problem: problem,)),
            Keypad(add: add, solve: solve, clear: clear, backspace: backspace)
        ]);
    }
}

