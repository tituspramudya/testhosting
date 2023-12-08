abstract class LoginEvent {}

class isPasswordVisibleChanged extends LoginEvent {}

class FormSubmitted extends LoginEvent {
  String username;
  String password;

  FormSubmitted({required this.username, required this.password});
}

class FormRegisterSubmitted extends LoginEvent {
  String name;
  String email;
  String password;
  String telepon;
  String tanggalLahir;
  String usia;

  FormRegisterSubmitted(
      {required this.name,
      required this.email,
      required this.password,
      required this.telepon,
      required this.tanggalLahir,
      required this.usia});
}
