class User {
  User({
    this.idUser,
    this.name,
    this.email,
    this.password,
    this.createdAt,
    this.updateAt,
  });

  String? idUser;
  String? name;
  String? email;
  String? password;
  String? createdAt;
  String? updateAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        idUser: json["id_user"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        createdAt: json["created_at"],
        updateAt: json["update_at"],
      );

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "name": name,
        "email": email,
        "password": password,
        "created_at": createdAt,
        "update_at": updateAt,
      };
}
