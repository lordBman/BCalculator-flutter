import 'package:bcalculator/logic/lexer.dart';
import 'package:bcalculator/utils/result.dart';
import 'package:bcalculator/utils/utils.dart';

/////////////////////////
///Enums              ///
/////////////////////////
enum ExpressionType{ None, Number, Binary, Negation, Coefficient, Bracket }

class Step{
    Expression expression;
    String desc;

    Step({ required this.expression, required this.desc });
}

/////////////////////////
///Expession Class    ///
/////////////////////////
abstract class Expression{
	  double getValue();
	  ExpressionType getType();
	  String display();
	  Step step();
}

/////////////////////////
///None Expession     ///
/////////////////////////
class NoneExpression extends Expression{
    @override
    String display() => "0";

    @override
    ExpressionType getType() => ExpressionType.None;

    @override
    double getValue() => 0;

    @override
    Step step() => Step(expression: NumberExpression( value:0), desc: "");
}

/////////////////////////
///Number Expession   ///
/////////////////////////
class NumberExpression extends Expression{
	  double __value;

    NumberExpression({ required double value}): __value = value;
	  NumberExpression.from({ required String init}): __value = double.parse(init);
  
    @override
    String display() => Utils.trim(__value);
  
    @override
    ExpressionType getType() => ExpressionType.Number;
  
    @override
    double getValue() => __value;
  
    @override
    Step step() => Step(expression: this, desc:"");
}

/////////////////////////
///Coefficient Exp    ///
/////////////////////////
class CoExpression extends Expression{
	  Expression __left;
	  Expression __right;

	  CoExpression({ required Expression left, required Expression right }): __left = left, __right = right;
    
      @override
      String display() => "${__left.display()}${__right.display()}";
    
      @override
      ExpressionType getType() => ExpressionType.Coefficient;
    
      @override
      double getValue() => __left.getValue() * __right.getValue();
    
      @override
      Step step(){
            Step init = __right.step();
            __right = init.expression;
            if(__left.getType() == ExpressionType.Number && __right.getType() == ExpressionType.Number){
              return Step(expression: BinaryExpression(left:__left, op:"x", right: __right), desc: init.desc);
            }
            return Step(expression: this, desc: init.desc);
      }
}

/////////////////////////
///Binary Expession   ///
/////////////////////////
class BinaryExpression extends Expression{
	Expression __left;
	Expression __right;
	String __op;

	BinaryExpression({ required Expression left, required String op, required Expression right }): __left = left, __right = right, __op = op;

   @override
    String display() => "${__left.display()} $__op ${__right.display()}";
  
    @override
    ExpressionType getType() => ExpressionType.Binary;
  
    @override
    double getValue(){
        switch(__op){
          case "-":
            return __left.getValue() - __right.getValue();
          case "+":
            return __left.getValue() + __right.getValue();
          case "x":
            return __left.getValue() * __right.getValue();
          case "\u00f7":
            return __left.getValue() / __right.getValue();
          default:
            return 0;
        }
    }
  
    @override
    Step step(){
        if(__left.getType() == ExpressionType.Number && __right.getType() == ExpressionType.Number){
            double left_value = __left.getValue();
            double right_value = __right.getValue();
            double final_value = getValue();

            String desc = "";
            switch(__op){
              case "+":
                desc = "added ${Utils.trim(left_value)} to ${Utils.trim(right_value)} which equals ${Utils.trim(final_value)}";
                break;
              case "-":
                desc = "substracted ${Utils.trim(left_value)} from ${Utils.trim(right_value)} which equals ${Utils.trim(final_value)}";
                break;
              case "x":
                desc = "multiplied ${Utils.trim(left_value)} with ${Utils.trim(right_value)} which equals ${Utils.trim(final_value)}";
                break;
              case "\u00f7":
                desc = "divided ${Utils.trim(left_value)} with ${Utils.trim(right_value)} which equals ${Utils.trim(final_value)}";
                break;
            }
            return Step(expression: NumberExpression(value:final_value), desc: desc);
          }else if(__left.getType() != ExpressionType.Number){
              Step init = __left.step();
              __left = init.expression;
            
              return Step( expression: this, desc: init.desc);
          }else{
              Step init = __right.step();
              __right = init.expression;
          
            return Step(expression: this, desc: init.desc );
          }
    }
}

/////////////////////////
///Negation Expession ///
/////////////////////////
class NegationExpression extends Expression{
	  Expression __expression;
	  String __operator;

	NegationExpression({required String operator, required Expression expression }): __expression = expression, __operator = operator;

  @override
  String display() => "-${__expression.display()}";

  @override
  ExpressionType getType() => ExpressionType.Negation ;

  @override
  double getValue() =>  -1 * __expression.getValue();

  @override
  Step step(){
      Step init = __expression.step();
      __expression = init.expression;
      if(__expression.getType() == ExpressionType.Number){
        double final_value = getValue();
        String desc = "multiply -1 with ${__expression.getValue()} to ${Utils.trim(final_value)}";

        return Step(expression: NumberExpression(value: final_value), desc: desc );
      }
      return Step( expression: this, desc: init.desc);
  }
}

/////////////////////////
///Bracket Expession  ///
/////////////////////////
class BracketExpression extends Expression{ 
    Expression __expression;
    String __open;
    String __close;

    BracketExpression({required String open, required Expression expression, required String close }): __expression = expression, __open = open, __close = close;

    @override
    String display() => "$__open${__expression.display()}$__close";

    @override
    ExpressionType getType() => ExpressionType.Bracket;

    @override
    double getValue() => __expression.getValue();

    @override
    Step step(){
        if(__expression.getType() == ExpressionType.Number){
          double value = __expression.getValue();
          return Step(expression:  NumberExpression(value: value), desc: "removed bracket ${display()} to $value");
        }

        Step init = __expression.step();
        __expression = init.expression;
      
        return Step(expression: this, desc: init.desc);
    }
}

/////////////////////////
///Parser   		  ///
/////////////////////////
class Parser{
	Lexer __lexer;
	List<String> __errors;
	Token __current;

	Parser(String data): __lexer = Lexer(data: data), __errors = [], __current = Token.None();

	Token __pop(){
		Token init = __current;
		while(__lexer.hasNext()){
			Result<Token> result = __lexer.getNextToken();
			if(!result.isError()){
				__current = result.unwrap();
				return init;
			}else{
				__errors.add(result.getMessage());
			}
		}
		__current = Token.None();
		return init;
	}

	bool __has(){
		return __current.ttype != TokenType.None;
	}

	Expression solve(){
		while(__lexer.hasNext()){
			Result<Token> result = __lexer.getNextToken();
			if(!result.isError()){
				__current = result.unwrap();
				return __sum();
			}else{
				__errors.add(result.getMessage());
			}
		}
		return NoneExpression();
	}

	Expression __sum(){
		Expression left = __factor();
		while(__has()){
			if(__current.ttype == TokenType.Sub){
				left = BinaryExpression(left: left, op:__pop().value!, right:__sum());
			}else{
				break;
			}
		}
		return left;
	}

  Expression __factor(){
		Expression left = __others();
		while(__has()){
			if(__current.ttype == TokenType.Factor){
				left = BinaryExpression(left: left, op:__pop().value!, right:__sum());
			}else{
				break;
			}
		}
		return left;
	}

	Expression __others(){
		if(__has() && __current.ttype == TokenType.OpenBracket){
			Token open = __pop();
			Expression exp = __sum();
			if(__has() && __current.ttype == TokenType.CloseBracket){
				  Token close = __pop();
				return BracketExpression(open: open.value!, expression: exp, close: close.value!);
			}else{
				  __errors.add("expected a closing bracket instead got: ${__current.value}"); 
			}
		}else if(__has() && (__current.ttype == TokenType.Number || __current.ttype == TokenType.Sub)){
			Expression left = __number();
			while(__has() && __current.ttype == TokenType.OpenBracket){
				left = CoExpression(left: left, right: __others());
			}
			return left;
		}else{
			  __errors.add("expected end of expression"); 
		}
		return NoneExpression();
	}

	Expression __number(){
		if(__current.ttype == TokenType.Number){
			return NumberExpression.from(init: __pop().value!);
		}else if(__current.ttype == TokenType.Sub){
			if(__current.value == '-'){
				Token op_token = __pop();
				if(__has()){
					Expression init = __others();
					if(init.getType() == ExpressionType.Number){
						return NumberExpression(value: init.getValue() * 1);
					}
					return NegationExpression(operator: op_token.value!, expression: init);
				}
				__pop();
				return __number(); 
			}
		}else{
			__errors.add("expected a number instead got: ${__pop()}"); 
		}
		return NoneExpression();
	}

	List<String> showErrors() => __errors;
}