class Character{
    String value;

    Character({required this.value});
    
    bool isAlphabetic(){
        const pattern = r'[A-Za-z]';
        return RegExp(pattern).hasMatch(value);
    }
    
    bool isNumeric(){
        const pattern = r'[0-9.]';
        return RegExp(pattern).hasMatch(value);
    }
    
    bool isAlphanumeric(){
        return isAlphabetic() || isNumeric();
    }
}