import 'package:sqflite/sqflite.dart' as sql;

class SQLBelajar{
  //create db
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE matapelajaran(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nama TEXT,
      guru TEXT,
      deskripsi TEXT
      )
    """);
  }
  
  //panggil db
  static Future<sql.Database> db() async {
    return sql.openDatabase('matapelajaran.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
      });
  }

  //insert matapelajaran
  static Future<int> addmatapelajaran(String nama, String guru, String deskripsi) async {
    final db = await SQLBelajar.db();
    final data = {
      'nama': nama,
      'guru': guru,
      'deskripsi': deskripsi,
    };
    return await db.insert('matapelajaran', data);
  }

  //read matapelajaran
  static Future<List<Map<String, dynamic>>> getmatapelajaran() async {
    final db = await SQLBelajar.db();
    return db.query('matapelajaran');
  }

  //update matapelajaran
  static Future<int> editmatapelajaran(int id, String nama, String guru, String deskripsi) async {
    final db = await SQLBelajar.db();
    final data = {
      'nama': nama,
      'guru': guru,
      'deskripsi': deskripsi,
    };
    return await db.update('matapelajaran', data, where: "id = $id");
  }

  //delete user
  static Future<int> deleteUser(int id) async {
    final db = await SQLBelajar.db();
    return await db.delete('matapelajaran', where: "id = $id");
  }
}

