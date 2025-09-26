class User {
  final int id;
  final String username;
  final String token;

  const User({
    required this.id,
    required this.username,
    required this.token,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.username == username &&
        other.token == token;
  }

  @override
  int get hashCode {
    return id.hashCode ^ username.hashCode ^ token.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, token: $token)';
  }
}
