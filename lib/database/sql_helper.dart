import 'dart:typed_data';
import 'package:sqflite/sqflite.dart' as sql;

  // final String? name;
  // final String? email;
  // final String? password;
  // final String? telepon;
  // final String? token;
  // final String? tanggalLahir;
  // final String? usia;

class SQLHelper{
  //create db
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE user(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      email TEXT,
      password TEXT,
      telepon TEXT,
      token TEXT,
      tanggalLahir TEXT,
      usia TEXT,
      profileImage BLOB
      )
    """);
  }
  
  //panggil db
  static Future<sql.Database> db() async {
    return sql.openDatabase('user.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
      });
  }

  //insert user
  static Future<int> addUser(String name, String email, String password, String telepon, String token, String tanggalLahir, String usia) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'telepon': telepon,
      'token': token,
      'tanggalLahir': tanggalLahir,
      'usia': usia,
    };
    return await db.insert('user', data);
  }

  //read user
  static Future<List<Map<String, dynamic>>> getUser() async {
    final db = await SQLHelper.db();
    return db.query('user');
  }

  //update user
  static Future<int> editUser(int id, String name, String email, String password, String telepon, String token, String tanggalLahir, String usia) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'telepon': telepon,
      'token': token,
      'tanggalLahir': tanggalLahir,
      'usia': usia,
    };
    return await db.update('user', data, where: "id = $id");
  }

  //delete user
  static Future<int> deleteUser(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('user', where: "id = $id");
  }

  static Future<int> updateImage({String? email, Uint8List? profileImageBytes}) async {
    final db = await SQLHelper.db();

    final data = {
      'email': email,
      'profileImage': profileImageBytes,
    };

    return await db.update('user', data, where: "email = ?", whereArgs: [email]);
  }

}

