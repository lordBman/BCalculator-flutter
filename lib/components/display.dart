import 'package:auto_size_text/auto_size_text.dart';
import 'package:bcalculator/logic/parser.dart';
import 'package:flutter/material.dart';

class Display extends StatelessWidget{
    final double fontSize = 40;
    final bool solve;
    final String problem;

    const Display({super.key, required this.problem, this.solve = false});

    @override
    Widget build(BuildContext context) {
        String answer = "";
        String finalAnswer = "";

        if(problem.isNotEmpty){
            Parser parser = Parser(problem);
            if(parser.showErrors().isNotEmpty){
                parser.showErrors().forEach((error)=>answer += error);
            }else if(problem.isNotEmpty && solve){
                answer = problem;
                var step =  parser.solve().step();
                while(step.expression.getType() != ExpressionType.Number){
                    answer += step.desc.isNotEmpty ? "\n${step.desc}" : "";
                    answer += "\n${step.expression.display()}";
                    step = step.expression.step();
                }
                answer += step.desc.isNotEmpty ? "\n${step.desc}" : "";
                answer += "\nanswer: ${step.expression.display()}";
                finalAnswer = "answer: ${ step.expression.display()}";
            }
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(child: ListView(children: [
                  Text(answer, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, letterSpacing: 1.7, color: Colors.grey[600]))])),
              Text(finalAnswer, style: TextStyle(fontSize: 24, color: Colors.grey[500], height: 1, fontWeight: FontWeight.w600),),
              SizedBox(width: MediaQuery.of(context).size.width - 16, 
                  child: AutoSizeText(problem, stepGranularity: 5, minFontSize: 25, textAlign: TextAlign.end, maxFontSize: 65, maxLines: 1, style: TextStyle( color: Colors.grey[500], fontSize: 62, fontWeight: FontWeight.w700, height: 1),))
          ]),
        );
    }
}