import 'package:example/model/user.dart';

import 'dart:convert';
import 'package:http/http.dart';

class userClient {
  // untuk emulator
  // static final String url = '10.0.2.2:8000';
  // static final String endpoint ='/api/user';

  //untuk hp
  static const String url = '192.168.100.147';
  static const String endpoint = '/PBPTubesUserAPI/public/api/userData';

  // mengambil semua data user dari API
  static Future<List<User>> fetchAll() async {
    try{
      var response = await get(
        Uri.http(url, endpoint) //request ke api dan menyimpan responsenya 
      );

      if (response.statusCode != 200) {
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(response.reasonPhrase);
      }

      // mengambil bagian data dari response body
      Iterable list = json.decode(response.body)['data'];

      // list.map untuk membuat list objek User berdasarkan tiap elemen dari list
      return list.map((e) => User.fromJson(e)).toList(); 
    }catch (e) {
      return Future.error(e.toString());
    }
  }
  

  // mengambil data User dari API sesuai id
  static Future<User> find(id) async {
    try{
      var response = await get(Uri.http(url, '$endpoint/$id')); //request ke api

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      // membuat objek User berdasarkan bagian data dari response body
      return User.fromJson(json.decode(response.body)['data']);
    }catch (e) {
      return Future.error(e.toString());
    }
  }

  // membuat data User baru
  static Future<Response> register(User user) async {
    try {
      var response = await post(Uri.http(url, endpoint),
          headers: {"Content-Type" : "application/json"},
          body: user.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    }catch (e) {
      return Future.error(e.toString());
    }
  }

    static Future<Response> login(User user) async {
      String apiURL = 'http://192.168.100.147/PBPTubesUserAPI/public/api/login';

      try {
        var response = await post(Uri.parse(apiURL),
            headers: {"Content-Type" : "application/json"},
            body: user.toRawJson());

        if (response.statusCode != 200) throw Exception(response.reasonPhrase);

        return response;
      }catch (e) {
        return Future.error(e.toString());
      }
    }

  // mengubah data user sesuai ID
  static Future<Response> update(User user) async {
    try{
      var response = await put(Uri.http(url, '$endpoint/${user.id}'),
          headers: {"Content-Type" : "application/json"},
          body: user.toRawJson());
      
      if (response.statusCode != 200) {
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(response.reasonPhrase);
      }

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // menghapus data user sesuai ID
  static Future<Response> destroy(id) async {
    try{
      var response = await delete(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}