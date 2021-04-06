class User {
  final String _email;
  final String _username;
  final String _token;
  final bool _isAdmin;

  User(this._email, this._username, this._token, this._isAdmin);

  get email => _email;
  get username => _username;
  get token => _token;
  get admin => _isAdmin;
}
