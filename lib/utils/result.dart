class Result<T>{
    T? value;
    String message;

    Result({this.value, this.message = "" });

    Result.Ok(T value): this(value: value);
    Result.Error(String message): this(message: message);

    bool isError(){
        return this.message.isNotEmpty || this.value == null;
    }

    T unwrap(){ return this.value as T; }

    getMessage(){ return this.message; }
}