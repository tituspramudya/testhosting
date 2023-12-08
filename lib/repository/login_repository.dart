import 'package:example/model/user.dart';
import 'package:example/repository/register_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:example/api/userClient.dart';

class FailedLogin implements Exception {
  String errorMessage() {
    return "Login Failed";
  }
}

class LoginRepository {

  void saveUserDataToSharedPreferences(
    int id, String name, String email, String password, String telepon, String tanggalLahir, String usia) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('id', id);
    prefs.setString('name', name);
    prefs.setString('email', email);
    prefs.setString('password', password);
    prefs.setString('telepon', telepon);
    prefs.setString('tanggalLahir', tanggalLahir);
    prefs.setString('usia', usia);
  }


  Future<User> login(String username, String password) async {
    print("Login in...");
    User userData = User();
    await Future.delayed(const Duration(seconds: 3), () async {
      try{
        await userClient.login(User(
          name: username,
          password: password,
        ));
        for (User userDetail in users) {
          if (userDetail.name == username && userDetail.password == password) {
              userData = User(
              id: userDetail.id,
              name: userDetail.name,
              email: userDetail.email,
              password: userDetail.password,
              telepon: userDetail.telepon,
              tanggalLahir: userDetail.tanggalLahir,
              token: userDetail.token,
              usia: userDetail.usia,
            );
            saveUserDataToSharedPreferences(userDetail.id ?? 0, userDetail.name ?? "", userDetail.email ?? "", userDetail.password ?? "", userDetail.telepon ?? "", 
            userDetail.tanggalLahir ?? "", userDetail.usia ?? "");

            return userData;
          }
        }
      } catch(e) {
        print('Gagal Login. Username: $username, Password: $password. Error: $e');
        throw FailedLogin();
      }
    });
    return userData;
  }
}

