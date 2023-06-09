class UserWithToken {
  User? user;
  String? token;
  String? message;

  UserWithToken({this.user, this.token, this.message});

  UserWithToken.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    data['message'] = message;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? username;
  String? level;
  String? email;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.name,
      this.username,
      this.level,
      this.email,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    level = json['level'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['level'] = level;
    data['email'] = email;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
