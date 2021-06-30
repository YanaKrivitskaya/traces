class CustomException implements Exception{
  final _message; 

  CustomException([this._message]);

  String toString() {
    return "$_message";
  }  
}

class FetchDataException extends CustomException {
  FetchDataException([String? message])
      : super("Server error: $message");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super("Invalid Request: $message");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super("Unauthorised: $message");
}

class ForbiddenException extends CustomException {
  ForbiddenException([message]) : super("Forbidden: $message");
}