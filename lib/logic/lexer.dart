import 'dart:developer';

import 'package:bcalculator/utils/character.dart';
import 'package:bcalculator/utils/result.dart';

enum TokenType{
    Factor, Sub, Number, OpenBracket, CloseBracket, None
}

class Token{
    TokenType ttype;
    String? value;

    Token({ required this.ttype, this.value});
    Token.None(): this(ttype: TokenType.None);
    Token.Factor(String op): this(ttype: TokenType.Factor, value:op);
    Token.Sub(String op): this(ttype: TokenType.Sub, value: op);
    Token.Number(String value): this(ttype: TokenType.Number, value: value); 
    Token.OpenBracket(String op): this(ttype: TokenType.OpenBracket, value: op);
    Token.CloseBracket(String op): this(ttype: TokenType.CloseBracket, value: op);
}

class Lexer{
    int __index = 0;
    Character __current;
    String data;

    Lexer({ required this.data }):
        __current = Character(value: data.substring(0, 1)),
        __index = 0;

    bool hasNext(){
        if(data.isNotEmpty){
            while(__index < data.length){
                String init = data.substring(__index, __index + 1);
                bool passable = ( init == ' ') || ( init == '\n') || ( init == '\t');
				        if (!passable){
                    __current = Character(value:init);
                    return true;
                }
				        __index+= 1;
            }
        }
        return false;
    }

    String pop(){
		    __index += 1;
		    return __current.value;
	  }

    Result<Token> getNextToken(){
        if(__current.value == '.' || __current.isNumeric()){
            return getNumber();
        }else if(__current.value == '+' || __current.value == '-'){
            return Result.Ok(Token.Sub(pop()));
        }else if(__current.value == '\u00f7' || __current.value == 'x'){
            return Result.Ok(Token.Factor(pop()));
        }else if(__current.value == '('){
            return Result.Ok(Token.OpenBracket(pop()));
        }else if(__current.value == ')'){
            return Result<Token>.Ok(Token.CloseBracket(pop()));
        }else{
            return Result.Error("unexpected token: ${pop()}");
        }
	  }

    Result<Token> getNumber(){
		    String builder = "";
		    while(hasNext() && (__current.isNumeric() || __current.value == '.')){
			      builder+= pop();
		    }

        try{
            log("input:$builder - value: ${double.parse(builder)}");
            return Result<Token>.Ok(Token.Number(builder));
        }catch(ex){
            return Result.Error("Invalid number token: $builder");
        }
	}
}