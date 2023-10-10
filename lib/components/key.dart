import 'package:flutter/material.dart';

class Keys extends StatelessWidget{
    final String text;
    final void Function(String) onclick;

    const Keys({super.key,  required this.text, required this.onclick});

    void clicked(){
        onclick(text);
    }

    @override
    Widget build(BuildContext context) {
        return Expanded(
          child: SizedBox( height: 80,
            child: Center(
              child: TextButton(onPressed: clicked,
                  child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 28),),),
            ),
          ),
        );
    }
}

class CommoandKey extends StatelessWidget{
    final String text;
    final void Function(String) onclick;

    const CommoandKey({super.key,  required this.text, required this.onclick});

    void clicked(){
        onclick(text);
    }

    @override
    Widget build(BuildContext context) {
        return Expanded(
          child: SizedBox( height: 80,
            child: Center(
              child: TextButton(onPressed: clicked,
                  child: Text(text, style: TextStyle(color: Color(0xFF0288D1), fontSize: 28),),),
            ),
          ),
        );
    }
}

class CancelKey extends StatelessWidget{
    final void Function() onclick;

    const CancelKey({super.key, required this.onclick});

    @override
    Widget build(BuildContext context) {
        return Expanded(
          child: SizedBox( height: 80,
            child: Center(
              child: IconButton(onPressed: onclick,
                  icon: Icon(Icons.backspace_outlined, color: Colors.lightBlue.shade700, size: 28),),
            ),
          ),
        );
    }
}

class EqualsKey extends StatelessWidget{
    final void Function() onclick;

    const EqualsKey({super.key, required this.onclick});

    @override
    Widget build(BuildContext context) {
        return Expanded(
          child: SizedBox( height: 160,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: MaterialButton(onPressed: onclick, color: Colors.lightBlue.shade700, shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(12)),
                  child: const Text("=", style: TextStyle(color: Colors.white70, fontSize: 28),),),
            ),
          ),
        );
    }
}