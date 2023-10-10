import 'package:bcalculator/components/key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Keypad extends StatelessWidget{
    final void Function(String value) add;
    final void Function() solve;
    final void Function() clear;
    final void Function() backspace;

    const Keypad({super.key, required this.add, required this.solve, required this.clear, required this.backspace});

    void onSolve() => solve();
    void onClear() => clear();
    void onBackSpace() => backspace();
    void onAdd(String value) => add(value);

    @override
    Widget build(BuildContext context) {
        return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(height: 80, child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                CommoandKey(text: "C", onclick: (value)=>clear(),), CommoandKey(text: "\u00F7", onclick: onAdd,), CommoandKey(text: "x", onclick: onAdd,), CancelKey( onclick: backspace),
            ])),
            SizedBox(height: 80, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Keys(text: "1", onclick: onAdd,), Keys(text: "2", onclick: onAdd,), Keys(text: "3", onclick: onAdd,), CommoandKey(text: "-", onclick: onAdd,),
            ])),
            SizedBox(height: 80, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Keys(text: "4", onclick: onAdd,), Keys(text: "5", onclick: onAdd,), Keys(text: "6", onclick: onAdd,), CommoandKey(text: "+", onclick: onAdd,),
            ])),
            SizedBox(height: 160,
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      SizedBox(height: 80, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Keys(text: "7", onclick: onAdd,), Keys(text: "8", onclick: onAdd,), Keys(text: "9", onclick: onAdd),
                      ])),
                      SizedBox(height: 80, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Keys(text: "%", onclick: onAdd,), Keys(text: ".", onclick: onAdd,), Keys(text: "0", onclick: onAdd,),
                      ])),
                  ],)),
                  EqualsKey( onclick: solve)
              ]),
            ),
        ]);
    }
}