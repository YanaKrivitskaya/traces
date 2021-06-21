
class Validator{

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static final RegExp _usernameRegExp = RegExp(
    r'[a-zA-Z0-9.!#$&%`*_|-~+]+$'
  );

  static final RegExp _stringValueRegExp = RegExp(
      r'[a-zA-Z0-9.!#$&%`*_|-~+]+$'
  );

  static isValidEmail(String email){
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password){
    return _passwordRegExp.hasMatch(password);
  }

  static isValidUsername(String username){
    return _usernameRegExp.hasMatch(username);
  }

  static isValidString(String value){
    return _stringValueRegExp.hasMatch(value);
  }

}