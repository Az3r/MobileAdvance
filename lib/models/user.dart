class User {
  final String name;
  final String id;
  final String password;
  final DateTime createdOn;

  User({
    this.name,
    this.id,
    this.password,
    this.createdOn,
  });

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        password = json['password'],
        createdOn = json['created_on'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'password': password,
      'created_on': createdOn,
    };
  }
}
