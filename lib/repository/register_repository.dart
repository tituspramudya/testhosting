import 'package:example/model/user.dart';
import 'package:example/api/userClient.dart';

//variabel global
List<User> users = [];

class RegisterRepository{

  String generateToken() {
    return "generated_token";
  }
  
  void clearUsers() {
    users.clear();
  }

  void printAllUsers() {
    for (User userData in users) {
      print(userData.toString());
    }
  }

  Future<void> register(String name, String email, String password, String telepon, String tanggalLahir, String usia) async {
    print("Registering...");
    await Future.delayed(const Duration(seconds: 5), () async {
      if (users.any((user) => user.email == email)) {
        throw 'Email telah dipakai user lain';
      } else if (name.isEmpty || password.isEmpty || email.isEmpty || telepon.isEmpty) {
        throw 'Field harus diisi semua';
      } else {
        try {
          await userClient.register(User(
            name: name,
            email: email,
            password: password,
            telepon: telepon,
            token : "Hi",
            tanggalLahir: tanggalLahir,
            usia: usia,
          ));
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          
          // prefs.setString('username', name);
          // prefs.setString('email', email);
          // prefs.setString('password', password);
          // prefs.setString('telepon', telepon);
          // prefs.setString('tanggalLahir', tanggalLahir);
          // prefs.setString('usia', usia); 

        } catch (error) {
          // Handle any errors that might occur during user creation
          print('Error during user creation: $error');
        }
      }
    });
  }
}