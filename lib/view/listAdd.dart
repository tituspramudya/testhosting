import 'package:example/view/pembayaran.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:example/view/InputPage.dart';
import 'package:example/view/qr_scan/scan_qr_page.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:example/api/pelajaranClient.dart';
import 'package:example/model/matapelajaran.dart';

Map<String, String> subjectImages = {
  "Ilmu Pengetahuan Alam": "assets/subject_1.jpg",
  "Ilmu Pengetahuan Sosial": "assets/subject_2.jpg",
  "Pengolahan Bahasa Alami": "assets/subject_3.jpg",
  "Pemrograman Berbasis Platform": "assets/subject_4.jpg",
  "Penjaminan Mutu Perangkat Lunak": "assets/subject_5.jpg",
};

//variabel global
List<Matapelajaran> matapelajaran = [];

class listAdd extends StatefulWidget {
  const listAdd({Key? key}) : super(key: key);

  @override
  State<listAdd> createState() => _listAddState();
}

class _listAddState extends State<listAdd> {
  final FlutterTts flutterTts = FlutterTts();
  final formKey = GlobalKey<FormState>();

  speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(0.9);
    await flutterTts.speak(text);
  }


  @override
  void initState() {
    refresh();
    printAllPelajaran();
    super.initState();
  }

  void refresh() async {
    List<Matapelajaran> data = await pelajaranClient.fetchAll();
    setState(() {
      matapelajaran = data;
    });
  }

  void printAllPelajaran() {
    for (Matapelajaran pelajaranData in matapelajaran) {
      print(pelajaranData.toString());
    }
  }

  
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: GFColors.LIGHT,
        appBar: AppBar(
          title: const Text("Materi Pembelajaran"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InputPage(
                      title: 'INPUT ',
                      id: null,
                      name: null,
                      guru: null,
                      deskripsi: null,
                    ),
                  ),
                ).then((_) => refresh());
              },
            ),
            IconButton(
              icon: const Icon(Icons.camera),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => 
                      const BarcodeScannerPageView(),
                  ),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: matapelajaran.length,
          itemBuilder: (context, index) {
            int displayIndex = index + 1;
            Matapelajaran currentMatapelajaran = matapelajaran[index];
            String subjectName = currentMatapelajaran.name ?? "";
            String guruName = currentMatapelajaran.guru ?? "";
            String deskripsi = currentMatapelajaran.deskripsi ?? "";
            String imageAsset =
                subjectImages[subjectName] ?? "assets/default_image.jpg";

            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0) +
                      const EdgeInsets.only(top: 28.0, bottom: 5.0),
                  child: Text("Materi Pelajaran - Item #$displayIndex",
                      style: const TextStyle(fontSize: 18)),
                ),
                GFCard(
                  boxFit: BoxFit.cover,
                  titlePosition: GFPosition.end,
                  image: Image.asset(
                    imageAsset,
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  padding: const EdgeInsets.only(bottom: 9),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 26.0, vertical: 8.0),
                        child: Text(
                          deskripsi,
                          textAlign: TextAlign.justify,
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
                            onTap: () async {
                              try {
                                await pelajaranClient.destroy(currentMatapelajaran.id);
                              } catch (error) {
                                print('Error during delete : $error');
                              }
                            },
                            child: const GFAvatar(
                              backgroundColor: GFColors.DANGER,
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              "Delete",
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
                                    builder: (context) => InputPage(
                                        title: 'Input Mata Pelajaran',
                                        id: currentMatapelajaran.id,
                                        name: currentMatapelajaran.name,
                                        guru: currentMatapelajaran.guru,
                                        deskripsi: currentMatapelajaran.deskripsi)),
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
                              "Update",
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
                                    builder: (context) => pembayaranView(
                                        name: currentMatapelajaran.name,
                                        guru: currentMatapelajaran.guru,
                                        deskripsi: currentMatapelajaran.deskripsi,
                                        imageAsset: 'subjectImages[subjectName]',
                                    )),
                              ).then((_) => refresh());
                            },
                            child: const GFAvatar(
                              backgroundColor: Colors.amber,
                              child: Icon(
                                Icons.money,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              "Beli",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              speak(currentMatapelajaran.name ?? "What's up, the text is blank");
                            },
                            child: const GFAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.speaker,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              "Speak",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
}
