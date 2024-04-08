class LoginModel {
  final String id, password;

  LoginModel({
    required this.id,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
    };
  }
}
