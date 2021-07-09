class CustomException implements Exception{
  final Error errorType;
  final _message; 

  CustomException(this.errorType, [this._message]);

  String toString() {
    return "$_message";
  }  
}

class FetchDataException extends CustomException {
  FetchDataException([String? message])
      : super(Error.FetchData ,"Server error: $message");
}

class ConnectionException extends CustomException {
  ConnectionException([message]) : super(Error.Connection, message);
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(Error.BadRequest, "Invalid Request: $message");
}

class UnauthorizedException extends CustomException {
  UnauthorizedException([message]) : super(Error.Unauthorized, "Unauthorized: $message");
}

class ForbiddenException extends CustomException {
  ForbiddenException([message]) : super(Error.Forbidden, "Forbidden: $message");
}

enum Error{
  Connection,
  BadRequest,
  Unauthorized,
  Forbidden,
  FetchData,
  Default
}