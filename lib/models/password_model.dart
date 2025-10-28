class PasswordModel {
  int? id;
  String title;
  String username;
  String password; // decrypted/plain text in the app layer

  PasswordModel({
    this.id,
    required this.title,
    required this.username,
    required this.password,
  });

  factory PasswordModel.fromJson(Map<String, dynamic> json) {
    return PasswordModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      title: json['title'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '', // backend returns decrypted (or encrypted depending on design)
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'username': username,
      'password': password,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
