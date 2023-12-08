import 'package:example/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:example/bloc/form_submission_state.dart';
import 'package:example/bloc/login_event.dart';
import 'package:example/bloc/login_state.dart';
import 'package:example/bloc/login_bloc.dart';
import 'package:example/repository/register_repository.dart';
import 'package:example/view/register_page.dart';
import 'package:local_auth/local_auth.dart';
import 'package:getwidget/getwidget.dart';
import 'package:example/api/userClient.dart';
import 'package:example/model/user.dart';

class LoginView extends StatefulWidget {
  final Map? data;

  const LoginView({super.key, this.data});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //untuk biometric
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    refresh();
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }
  //set biometric sampe sini

  final formKey = GlobalKey<FormState>();
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  void refresh() async {
    List<User> data = await userClient.fetchAll();
    setState(() {
      users = data;
    });
  }

  void printAllUsers() {
    for (User userData in users) {
      print(userData.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    printAllUsers();
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.formSubmissionState is SubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Success'),
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeView(),
              ),
            ).then((value) => refresh());
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
                      width: 400,
                      height: 400,
                      padding: const EdgeInsets.all(25),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            height: 50,
                            width: 250,
                          ),
                          TextFormField(
                            key: const Key('username'),
                            controller: usernameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                              ),
                              labelText: 'Username',
                            ),
                            validator: (value) => value == ''
                                ? 'Please enter your Username'
                                : null,
                          ),
                          TextFormField(
                            key: const Key('password'),
                            controller: passwordController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock,
                              ),
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
                            validator: (value) => value == ''
                                ? 'Please enter your Password'
                                : null,
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              key: const Key('login'),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<LoginBloc>().add(
                                        FormSubmitted(
                                            username: usernameController.text,
                                            password: passwordController.text),
                                      );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                child:
                                    state.formSubmissionState is FormSubmitting
                                        ? const GFLoader(type: GFLoaderType.ios)
                                        : const Text('Login'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          const Text(
                            "Belum punya akun?",
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GFButton(
                                type: GFButtonType.transparent,
                                onPressed: () {
                                  Map<String, dynamic> formData = {};
                                  formData['username'] =
                                      usernameController.text;
                                  formData['password'] =
                                      passwordController.text;
                                  pushRegister(context);
                                },
                                text: 'Daftar di sini',
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                        ],
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

  void pushRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterView(),
      ),
    );
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    print("List of availableBiometrics : $availableBiometrics");
    if (!mounted) {
      return;
    }
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: '-',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      print("Authenticated : $authenticated");
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
