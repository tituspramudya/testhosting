import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:example/bloc/form_submission_state.dart';
import 'package:example/bloc/login_event.dart';
import 'package:example/bloc/login_state.dart';
import 'package:example/bloc/login_bloc.dart';
import 'package:example/repository/register_repository.dart';
import 'package:example/view/login_page.dart';
import 'package:example/api/userClient.dart';
import 'package:example/model/user.dart';
import 'package:getwidget/getwidget.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key, this.id});
  final int? id;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  bool value = false;
  bool isLoading = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController usiaController = TextEditingController();

  void printAllUsers(List<User> users) {
    for (User user in users) {
      print('Name: ${user.name}, Age: ${user.email}');
    }
  }

  void refresh() async {
    List<User> data = await userClient.fetchAll();
    setState(() {
      users = data;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    printAllUsers(users);
    // aksi ketika form disubmit
    void onSubmit() async {
      if (!_formKey.currentState!.validate()) return;

      // objek barang berdasarkan input
      User input = User(
        id: widget.id ?? 0,
        name: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        telepon: notelpController.text,
        token: "",
        tanggalLahir: dateController.text,
        usia: usiaController.text,
      );

      try {
        if (widget.id == null) {
          await userClient.register(input);
        } else {
          await userClient.update(input);
        }

        showSnackBar(context, 'Success', Colors.green);
        Navigator.pop(context);
      } catch (err) {
        showSnackBar(context, err.toString(), Colors.red);
        Navigator.pop(context);
      }
    }

    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.formSubmissionState is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Register Success'),
              ),
            );
            Map<String, dynamic> formData = {};
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LoginView(data: formData),
              ),
            ).then((_) => refresh());
          }
          if (state.formSubmissionState is SubmissionFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text((state.formSubmissionState as SubmissionFailed)
                    .exception
                    .toString()),
              ),
            );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: [
                  Image.asset(
                    'assets/default_image.jpg',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  Center(
                    child: Container(
                      width: 500,
                      height: 500,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Scaffold(
                        body: Center(
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/logo.png',
                                      height: 50,
                                      width: 250,
                                    ),
                                    TextFormField(
                                      key: const Key('usernames'),
                                      controller: usernameController,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        labelText: 'Username',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Masukkan Username';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      key: const Key('email'),
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        labelText: 'Email',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Masukkan Email';
                                        }
                                        if (!value.contains('@')) {
                                          return 'Email harus menggunakan @';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      key: const Key('passwords'),
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.lock),
                                        labelText: 'Password',
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            context.read<LoginBloc>().add(
                                                  isPasswordVisibleChanged(),
                                                );
                                          },
                                          icon: Icon(
                                            state.isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: state.isPasswordVisible
                                                ? Colors.blue
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                      obscureText: !state.isPasswordVisible,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Masukkan Password';
                                        }
                                        if (value.length < 5) {
                                          return 'Password mminimal 5 digit';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      key: const Key('telepon'),
                                      controller: notelpController,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.phone_android),
                                        labelText: 'Nomor Telepon',
                                      ),
                                      //hanya bisa menerima angka
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Masukkan Nomor Telepon';
                                        }
                                        if (value.length < 10) {
                                          return 'Nomor Telepon minimal 10 angka';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      key: const Key('tanggal'),
                                      controller: dateController,
                                      decoration: const InputDecoration(
                                        labelText: "Tanggal Lahir",
                                        prefixIcon: Icon(Icons.calendar_today),
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Tanggal Tidak Boleh Kosong';
                                        }
                                        return null;
                                      },
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2024),
                                        );

                                        if (pickedDate != null) {
                                          print(pickedDate);
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          print(formattedDate);

                                          setState(() {
                                            dateController.text = formattedDate;
                                          });
                                        }
                                      },
                                    ),
                                    TextFormField(
                                      key: const Key('usia'),
                                      controller: usiaController,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.create),
                                        labelText: 'Usia',
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Masukkan Usia';
                                        }
                                        if (value == '0') {
                                          return 'Usia tidak boleh nol';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        key: const Key('register'),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<LoginBloc>().add(
                                                  FormRegisterSubmitted(
                                                    name:
                                                        usernameController.text,
                                                    email: emailController.text,
                                                    password:
                                                        passwordController.text,
                                                    telepon:
                                                        notelpController.text,
                                                    tanggalLahir:
                                                        dateController.text,
                                                    usia: usiaController.text,
                                                  ),
                                                );
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0, horizontal: 16.0),
                                          child: state.formSubmissionState
                                                  is FormSubmitting
                                              ? const GFLoader(type: GFLoaderType.ios)
                                              : Text(widget.id == null
                                                  ? 'Register'
                                                  : 'Edit'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Untuk menampilkan snackbar
void showSnackBar(BuildContext context, String msg, Color bg) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: bg,
      action: SnackBarAction(
          label: 'hide', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}
