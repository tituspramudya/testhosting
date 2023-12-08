import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:example/api/userClient.dart';
import 'package:example/model/user.dart';

class editProfile extends StatefulWidget {
  const editProfile({
    super.key,
    required this.title,
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.telepon,
    required this.tanggalLahir,
    required this.usia
  });

  final String? title, name, email, password, telepon, tanggalLahir, usia;
  final int? id;

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerTelepon = TextEditingController();
  TextEditingController controllerTanggal = TextEditingController();
  TextEditingController controllerUsia = TextEditingController();

  int? id0;
  String? name0 = '';
  String? email0 = '';
  String? password0 = '';
  String? telepon0 = '';
  String? tanggalLahir0 = '';
  String? usia0 = '';

  void saveUserDataToSharedPreferences(
    String name, String email, String password, String telepon, String tanggalLahir, String usia) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    prefs.setString('name', name);
    prefs.setString('email', email);
    prefs.setString('password', password);
    prefs.setString('telepon', telepon);
    prefs.setString('tanggalLahir', tanggalLahir);
    prefs.setString('usia', usia);
  }
  
  @override
  void dispose() {
    super.dispose();
    accessUserDataFromSharedPreferences();
  }

  void accessUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    id0 = prefs.getInt('id');
    name0 = prefs.getString('name');
    email0 = prefs.getString('email');
    password0 = prefs.getString('password');
    telepon0 = prefs.getString('telepon');
    tanggalLahir0 = prefs.getString('tanggalLahir');
    usia0 = prefs.getString('usia');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      controllerName.text = widget.name!;
      controllerEmail.text = widget.email!;
      controllerPassword.text = widget.password!;
      controllerTelepon.text = widget.telepon!;
      controllerTanggal.text = widget.tanggalLahir!;
      controllerUsia.text = widget.usia!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ganti Data"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const SizedBox(height: 12),
          TextField(
            controller: controllerName,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Nama',
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerEmail,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerPassword,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerTelepon,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Telepon',
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerTanggal,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Tanggal',
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerUsia,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Usia',
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              // editEmployee(widget.id!);
              try{
                await userClient.update(User(
                  id: widget.id,
                  name: controllerName.text,
                  email: controllerEmail.text,
                  password: controllerPassword.text,
                  telepon: controllerTelepon.text,
                  token: "Hi",
                  tanggalLahir: controllerTanggal.text,
                  usia: controllerUsia.text,
                ));
              }catch(e){
                  print('Error during user update: $e');
              }
              saveUserDataToSharedPreferences(
                controllerName.text,
                controllerEmail.text,
                controllerPassword.text,
                controllerTelepon.text,
                controllerTanggal.text,
                controllerUsia.text,
              );
              
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }


  // Future<void> editEmployee(int id) async {
  //   await SQLHelper.editUser(id, controllerName.text, controllerEmail.text, controllerPassword.text, controllerTelepon.text, "-", controllerTanggal.text, controllerUsia.text);
  // }
}