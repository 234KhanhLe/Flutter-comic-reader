class User {
  static int _nextId = 1;
  final int id;
  final String username;
  final String password;
  final UserRole? role;

  User._internal(
      {required this.id,
      required this.username,
      required this.password,
      required this.role});

  factory User(
      {required String username,
      required String password,
      required UserRole role}) {
    final user = User._internal(
      id: _nextId,
      username: username,
      password: password,
      role: role,
    );
    _nextId++;
    return user;
  }
}

enum UserRole { admin, user }
