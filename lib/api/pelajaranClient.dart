import 'package:example/model/matapelajaran.dart';

import 'dart:convert';
import 'package:http/http.dart';

class pelajaranClient{
  // untuk emulator
  // static final String url = '10.0.2.2:8000';
  // static final String endpoint ='/api/mataPelajaran';

  //untuk hp
  static const String url = '192.168.100.147';
  static const String endpoint = '/PBPTubesUserAPI/public/api/mataPelajaran';

  // mengambil semua data Matapelajaran dari API
  static Future<List<Matapelajaran>> fetchAll() async {
    try{
      var response = await get(
        Uri.http(url, endpoint) //request ke api dan menyimpan responsenya 
      );

      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      // mengambil bagian data dari response body
      Iterable list = json.decode(response.body)['data'];

      // list.map untuk membuat list objek Matapelajaran berdasarkan tiap elemen dari list
      return list.map((e) => Matapelajaran.fromJson(e)).toList(); 
    }catch (e) {
      return Future.error(e.toString());
    }
  }

  // mengambil data MataPelajaran dari API sesuai id
  static Future<Matapelajaran> find(id) async {
    try{
      var response = await get(Uri.http(url, '$endpoint/$id')); //request ke api

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      // membuat objek Matapelajaran berdasarkan bagian data dari response body
      return Matapelajaran.fromJson(json.decode(response.body)['data']);
    }catch (e) {
      return Future.error(e.toString());
    }
  }

  // membuat data Matapelajaran baru
  static Future<Response> create(Matapelajaran matapelajaran) async {
    try {
      var response = await post(Uri.http(url, endpoint),
          headers: {"Content-Type" : "application/json"},
          body: matapelajaran.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    }catch (e) {
      return Future.error(e.toString());
    }
  }

  // mengubah data matapelajaran sesuai ID
  static Future<Response> update(Matapelajaran matapelajaran) async {
    try{
      var response = await put(Uri.http(url, '$endpoint/${matapelajaran.id}'),
          headers: {"Content-Type" : "application/json"},
          body: matapelajaran.toRawJson());
      
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // menghapus data Matapelajaran sesuai ID
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