class JoinModel {
  final String id, nick, password;

  JoinModel({
    required this.id,
    required this.nick,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nick': nick,
      'password': password,
    };
  }
}
