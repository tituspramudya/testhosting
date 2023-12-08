import 'dart:convert';

class Matapelajaran {
  final int? id;
  final String? name;
  final String? guru;
  final String? deskripsi;

  Matapelajaran({
    this.id,
    this.name,
    this.guru,
    this.deskripsi,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'guru': guru,
      'deskripsi': deskripsi,
    };
  }
  
  // untuk membuat objek barang dari data json yang diterima dari API
  factory Matapelajaran.fromRawJson(String str) => Matapelajaran.fromJson(json.decode(str));
  factory Matapelajaran.fromJson(Map<String, dynamic> json) => Matapelajaran(
    id: json["id"],
    name: json["name"],
    guru: json["guru"],
    deskripsi: json["deskripsi"],
  );

  // untuk membuat data json dari objek barang yang dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id": id,
    "name" : name,
    "guru" : guru,
    "deskripsi" : deskripsi
  };

  @override
  String toString() {
    return 'Matapelajaran{id: $id, name: $name, guru: $guru, deskripsi: $deskripsi}';
  }
}
