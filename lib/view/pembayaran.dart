import 'package:example/view/generate_qr_page.dart';
import 'package:example/view/home.dart';
import 'package:example/view/listAdd.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/position/gf_position.dart';
import 'package:local_auth/local_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:example/view/pdf/pdf_view.dart';
import 'dart:io';
import 'package:example/api/pelajaranClient.dart';
import 'package:example/model/matapelajaran.dart';

class pembayaranView extends StatefulWidget {
  const pembayaranView({super.key, 
    required this.name,
    required this.guru,
    required this.deskripsi,
    required this.imageAsset,
  });

  final String? name, guru, deskripsi;
  final String imageAsset;

  @override
  State<pembayaranView> createState() => _pembayaranViewState();
}

class _pembayaranViewState extends State<pembayaranView> {
  //untuk biometric
  late final LocalAuthentication auth;
  bool _supportState = false;
  String id = const Uuid().v1();

  @override
  void refresh() async {
    List<Matapelajaran> data = await pelajaranClient.fetchAll();
    setState(() {
      matapelajaran = data;
    });
  }

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }
  //set biometric sampe sini

@override
Widget build(BuildContext context) {
  int index = 0; // Replace with the desired index from matapelajaran
  String subjectName = widget.name!;
  String guruName = widget.guru!;
  String deskripsi = widget.deskripsi!;
  String imageAsset = subjectImages[subjectName] ?? "assets/default_image.jpg";
  TextEditingController nameController = TextEditingController(text: subjectName);
  TextEditingController guruController = TextEditingController(text: guruName);
  TextEditingController deskripsiController = TextEditingController(text: deskripsi);

  return Scaffold(
    backgroundColor: GFColors.LIGHT,
    extendBodyBehindAppBar: true,
    extendBody: true,
    appBar: AppBar(
      title: const Text("Pembayaran"),
      foregroundColor: Colors.black,
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.green,
      elevation: 0,
      leading: Container(),
    ),
    body: Center(
      child:GFCard(
          height: 500,
          boxFit: BoxFit.cover,
          titlePosition: GFPosition.end,
          image: Image.asset(
            imageAsset,
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          padding: const EdgeInsets.only(top: 9),
          showImage: true,
          title: GFListTile(
            avatar: const GFAvatar(
              backgroundImage: AssetImage('assets/app_icon.png'),
            ),
            titleText: subjectName,
            subTitleText: guruName,
          ),
          content: Column(
            children: <Widget>[
              Container(
                width: 330.0,
                alignment: Alignment.center,
                child: const Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
                child: Text(
                  deskripsi,
                  textAlign: TextAlign.justify,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  "Biaya: Rp25,000.00",
                  textAlign: TextAlign.left,
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
          buttonBar: GFButtonBar(
            padding: const EdgeInsets.only(top: 12),
            children: <Widget>[
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      _authenticate().then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeView(),
                            ),
                          ));
                    },
                    child: GFAvatar(
                      backgroundColor: Colors.blue[800],
                      child: const Icon(
                        Icons.fingerprint,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "Fingerprint",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GenerateQRPage(
                                harga: '25000'
                                )),
                      ).then((_) => refresh());
                    },
                    child: const GFAvatar(
                      backgroundColor: GFColors.SUCCESS,
                      child: Icon(
                        Icons.update,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "QR",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  InkWell(  
                    onTap: () {
                      File imageFile = File(imageAsset);

                      createPdf(nameController, guruController, deskripsiController, id, imageFile, context);
                      setState(() {
                        const uuid = Uuid();
                        id = uuid.v1();
                      });
                    },
                    child: const GFAvatar(
                      backgroundColor: GFColors.FOCUS,
                      child: Icon(
                        Icons.update,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "PDF",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    )
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
          biometricOnly: true,
        ),
      );
      print("Authenticated : $authenticated");
    } on PlatformException catch (e) {
      print(e);
    }
  }
}

class PembayaranHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final String? subtitle;
  final List<Widget>? actions;

  const PembayaranHeader(
      {Key? key,
      required this.coverImage,
      // required this.title,
      this.subtitle,
      this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: coverImage as ImageProvider<Object>, fit: BoxFit.cover),
          ),
        ),
        Ink(
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.black38,
          ),
        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            ),
          ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(
                    top: 10.0), // Adjust the top padding value as needed
                // child: Text(
                //   title,
                //   style: Theme.of(context).textTheme.titleLarge,
                // ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}
