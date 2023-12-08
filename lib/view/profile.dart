import 'dart:convert';
import 'package:example/api/userClient.dart';
import 'package:example/view/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:example/view/login_page.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:example/repository/register_repository.dart';
import 'package:example/model/user.dart';
import 'package:path_provider/path_provider.dart';

File? imageFile;
User? temporaryUser;
String? imageData;

  class ProfilePage extends StatelessWidget {
    
    final int? id;
    final String? nama;
    final String? email;
    final String? password;
    final String? telepon;
    final String? tanggalLahir;
    final String? usia;
    
    const ProfilePage({super.key, required this.id, required this.nama, this.email, required this.password, required this.telepon, required this.tanggalLahir, required this.usia});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          backgroundColor: Colors.grey.shade100,
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ProfileHeader(
                  email:email,
                  avatar: const NetworkImage('assets/subject_1'),
                  coverImage: const AssetImage('assets/coverImage.jpg'),
                  title: nama ?? "-",
                  subtitle: "Admin",
                  actions: <Widget>[
                    MaterialButton(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 0,
                      child: const Icon(Icons.edit),
                      onPressed: () async {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => editProfile(
                            title: 'INPUT EMPLOYEE', 
                            id: id, 
                            name: nama, 
                            email: email,
                            password: password,
                            telepon: telepon,
                            tanggalLahir: tanggalLahir,
                            usia: usia)),
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10.0),
                UserInfo(nama:nama, email:email, telepon:telepon, tanggalLahir: tanggalLahir, usia: usia),
                Container(
                  width: MediaQuery.of(context).size.width * 0.94,
                  height: MediaQuery.of(context).size.height * 0.1,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginView(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Red button color
                    ),
                    child: const Text('Logout', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ));
    }
  }

  class UserInfo extends StatelessWidget {
    final String? nama;
    final String? email;
    final String? telepon;
    final String? tanggalLahir;
    final String? usia;

    const UserInfo({super.key, required this.nama, this.email, required this.telepon, required this.tanggalLahir, required this.usia});

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              alignment: Alignment.topLeft,
              child: const Text(
                "User Information",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Card(
              child: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      leading: const Icon(Icons.face),
                      title: const Text("Usia"),
                      subtitle: Text(usia ?? "-"),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text("Email"),
                      subtitle: Text(email ?? "-"),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text("Phone"),
                      subtitle: Text(telepon ?? "-"),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.date_range),
                      title: const Text("Tanggal Lahir"),
                      subtitle: Text(tanggalLahir ?? "-"),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  class ProfileHeader extends StatelessWidget {
    final ImageProvider<dynamic> coverImage;
    final ImageProvider<dynamic> avatar;
    final String title;
    final String? subtitle;
    final List<Widget>? actions;
    final String? email;

    ProfileHeader(
        {Key? key,
        required this.email,
        required this.coverImage,
        required this.avatar,
        required this.title,
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
                InkWell(
                  onTap: () async {
                      Map<Permission, PermissionStatus> statuses = await [
                      Permission.storage, Permission.camera,
                    ].request();
                    if(statuses[Permission.storage]!.isGranted && statuses[Permission.camera]!.isGranted){
                      showImagePicker(context);
                    } else {
                      print('no permission provided');
                    }
                  },
                  child: Avatar(
                    image: imageFile == null
                        ? const AssetImage('assets/avatar.jpg')
                        : FileImage(File(imageFile!.path)) as ImageProvider,
                        
                    radius: 40,
                    backgroundColor: Colors.white,
                    borderColor: Colors.grey.shade300,
                    borderWidth: 4.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0), // Adjust the top padding value as needed
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
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

    final picker = ImagePicker();

    void showImagePicker(BuildContext context) async {
      showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 5.2,
              margin: const EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      child: const Column(
                        children: [
                          Icon(Icons.image, size: 60.0),
                          SizedBox(height: 12.0),
                          Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                      onTap: () async {
                        _imgFromGallery();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(Icons.camera_alt, size: 60.0),
                            SizedBox(height: 12.0),
                            Text(
                              "Camera",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      onTap: () async {
                        _imgFromCamera();
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    }

    _imgFromGallery() async {
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 50).then((value) {
        if (value != null) {
          _cropImage(File(value.path));
        }
      });
    }

    _imgFromCamera() async {
      await picker.pickImage(source: ImageSource.camera, imageQuality: 50).then((value) {
        if (value != null) {
          _cropImage(File(value.path));
        }
      });
    }

    _cropImage(File imgFile) async {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
          ? [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ] : [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio16x9
          ],
        uiSettings: [AndroidUiSettings(
          toolbarTitle: "Image Cropper",
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
          IOSUiSettings(
            title: "Image Cropper",
          )
        ],
      );

      if (croppedFile != null) {
        imageCache.clear();
        imageFile = File(croppedFile.path);
        imageData = base64Encode(imageFile!.readAsBytesSync());

        try {
          await userClient.update(User(
            id: temporaryUser!.id ?? 0,
            name: temporaryUser!.name ?? "",
            email: temporaryUser!.email ?? "",
            password: temporaryUser!.password ?? "",
            telepon: temporaryUser!.telepon ?? "",
            token: temporaryUser!.token ?? "",
            tanggalLahir: temporaryUser!.tanggalLahir ?? "",
            usia: temporaryUser!.usia ?? "",
            image: imageData ?? "",
          ));
        } catch (error) {
          print('Error during image update: $error');
        }
        // Uint8List bytes = await imageFile!.readAsBytes();
        // await SQLHelper.updateImage(email: email, profileImageBytes: bytes);
      }

    }

    // Future<int> updateImage({String? email, Uint8List? profileImageBytes}) async {
    //   final db = await SQLHelper.db();

    //   final data = {
    //     'email': email,
    //     'profileImage': profileImageBytes,
    //   };
      
    //   return await db.update('user', data, where: "email = $email", whereArgs: [email]);
    // }
  }

  class Avatar extends StatelessWidget {
    final ImageProvider<dynamic> image;
    final Color borderColor;
    final Color? backgroundColor;
    final double radius;
    final double borderWidth;

    const Avatar(
        {Key? key,
        required this.image,
        this.borderColor = Colors.grey,
        this.backgroundColor,
        this.radius = 30,
        this.borderWidth = 5})
        : super(key: key);

    @override
    Widget build(BuildContext context) {
      return CircleAvatar(
        radius: radius + borderWidth,
        backgroundColor: borderColor,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          child: CircleAvatar(
            radius: radius - borderWidth,
            backgroundImage: image as ImageProvider<Object>?,
          ),
        ),
      );
    }
  }

  class ProfilHalaman extends StatefulWidget {
    const ProfilHalaman({super.key});

    @override
    State<ProfilHalaman> createState() => _ProfilHalamanState();
  }

  class _ProfilHalamanState extends State<ProfilHalaman> {
    int? id0;
    String? name0 = '';
    String? email0 = '';
    String? password0 = '';
    String? telepon0 = '';
    String? tanggalLahir0 = '';
    String? usia0 = '';

    @override
    void initState() {
      super.initState();
      refresh();
      setUserImage();
      accessUserDataFromSharedPreferences();
    }

    void accessUserDataFromSharedPreferences() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        id0 = prefs.getInt('id');
        name0 = prefs.getString('name');
        email0 = prefs.getString('email');
        password0 = prefs.getString('password');
        telepon0 = prefs.getString('telepon');
        tanggalLahir0 = prefs.getString('tanggalLahir');
        usia0 = prefs.getString('usia');
      });
    }

    void findLoggedUser() async {
      for (User userDetail in users) {
        if (userDetail.name == name0) {
          temporaryUser = userDetail;
        }
      }
    }

    void setUserImage() async {
      if (temporaryUser != null && temporaryUser!.image != null) {
        List<int> imageBytes = base64Decode(temporaryUser!.image!);
        imageFile = await _writeBytesToFile(imageBytes);
      }
    }

    Future<File> _writeBytesToFile(List<int> bytes) async {
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = await File('${tempDir.path}/temp_image_file_$timestamp').create();
      await tempFile.writeAsBytes(bytes);
      return tempFile;
    }

    void refresh() async {
      List<User> data = await userClient.fetchAll();
      setState(() {
        users = data;
      });
    }

    @override
    Widget build(BuildContext context) {
      accessUserDataFromSharedPreferences();
      findLoggedUser();

      return ProfilePage(
        id: id0,
        nama: name0,
        email: email0,
        password: password0,
        telepon: telepon0,
        tanggalLahir: tanggalLahir0,
        usia: usia0,
      );
    }
  }