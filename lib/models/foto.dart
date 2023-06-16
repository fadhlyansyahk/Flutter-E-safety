class InputFoto {
  Foto? foto;
  User? user;

  InputFoto({this.foto, this.user});

  InputFoto.fromJson(Map<String, dynamic> json) {
    foto = json['foto'] != null ? new Foto.fromJson(json['foto']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.foto != null) {
      data['foto'] = this.foto!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Foto {
  int? idUser;
  String? kasus;
  String? lokasi;
  String? tanggal;
  String? deskripsi;
  String? foto;
  String? updatedAt;
  String? createdAt;
  int? id;

  Foto(
      {this.idUser,
      this.kasus,
      this.lokasi,
      this.tanggal,
      this.deskripsi,
      this.foto,
      this.updatedAt,
      this.createdAt,
      this.id});

  Foto.fromJson(Map<String, dynamic> json) {
    idUser = json['id_user'];
    kasus = json['kasus'];
    lokasi = json['lokasi'];
    tanggal = json['tanggal'];
    deskripsi = json['deskripsi'];
    foto = json['foto'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_user'] = this.idUser;
    data['kasus'] = this.kasus;
    data['lokasi'] = this.lokasi;
    data['tanggal'] = this.tanggal;
    data['deskripsi'] = this.deskripsi;
    data['foto'] = this.foto;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['level'] = this.level;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
