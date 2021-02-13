class User {
  final String _email;
  final String _username;
  final String _token;

  User(this._email, this._username, this._token);

  String get email => _email;
  String get username => _username;
  String get token => _token;
}
