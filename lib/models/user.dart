class User {
  final String _email;
  final String _username;
  final String _token;

  User(this._email, this._username, this._token);

  get email => _email;
  get username => _username;
  get token => _token;
}
