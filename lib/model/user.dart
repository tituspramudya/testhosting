import 'dart:convert';

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final String? telepon;
  final String? token;
  final String? tanggalLahir;
  final String? usia;
  final String? image;

  User(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.telepon,
      this.token,
      this.tanggalLahir,
      this.usia,
      this.image});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'telepon': telepon,
      'tanggalLahir': tanggalLahir,
      'token': token,
      'usia' : usia,
      'image' : image,
    };
  }
  
  // untuk membuat objek barang dari data json yang diterima dari API
  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    telepon: json["telepon"],
    token: json["token"],
    tanggalLahir: json["tanggalLahir"],
    usia: json["usia"],
    image: json["image"],
  );

  // untuk membuat data json dari objek barang yang dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id": id,
    "name" : name,
    "email" : email,
    "password" : password,
    "telepon" : telepon,
    "token" : token,
    "tanggalLahir" : tanggalLahir,
    "usia" : usia,
    "image" : image,
  };

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, password: $password, telepon: $telepon, tanggallahir: $tanggalLahir, usia: $usia, token: $token, image: $image}';
  }
}
