import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Picture {
  final String url;
  final String name;
  final String description;
  bool isExpanded;

  Picture({
    required this.url,
    required this.name,
    required this.description,
    this.isExpanded = false,
  });
}

class gridView extends StatefulWidget {
  const gridView({super.key});

  @override
  State<gridView> createState() => _gridViewState();
}

class _gridViewState extends State<gridView> {
  static const jumlahWidget = 2;

  String username = "Belum Dipanggil"; // Replace with actual username

  List<Picture> pictures = [
    Picture(
      url: 'assets/subject_1.jpg',
      name: 'Subject 1',
      description: 'This is the description of subject 1.',
    ),
    Picture(
      url: 'assets/subject_2.jpg',
      name: 'Subject 2',
      description: 'This is the description of subject 2.',
    ),
    Picture(
      url: 'assets/subject_3.jpg',
      name: 'Subject 3',
      description: 'This is the description of subject 3.',
    ),
    Picture(
      url: 'assets/subject_4.jpg',
      name: 'Subject 4',
      description: 'This is the description of subject 4.',
    ),
  ];

  int _currentlyExpandedIndex = -1;

  List<bool> statusExpand = List.generate(jumlahWidget, (index) => false);

  Widget welcomeText() {
    return Text(
      "Home of, $username",
      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    );
  }

  Widget animations(double width, int index) {
    bool isExpanded = pictures[index].isExpanded;

    if (index == _currentlyExpandedIndex) {
      isExpanded = true;
    } else {
      isExpanded = false;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_currentlyExpandedIndex == index) {
            _currentlyExpandedIndex = -1;
          } else {
            _currentlyExpandedIndex = index;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        margin: const EdgeInsets.all(12.0),
        width: !isExpanded ? width * 0.4 : width * 0.87,
        height: !isExpanded
            ? width * 0.4
            : width * 0.7, // Adjust height based on content
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(pictures[index].url),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: isExpanded ? 2 : 3,
              child: Container(),
            ),
            Visibility(
              visible: isExpanded,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        pictures[index].name,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Center(
                      child: Text(
                        pictures[index].description,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> teacherNames = [
    'Teacher 1',
    'Teacher 2',
    'Teacher 3',
    'Teacher 4'
  ];

  Widget teacherSquare(String name) {
    return Container(
      width: double.infinity,
      height: 50.0, // Adjust height as needed
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        name,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap the Column with SingleChildScrollView
          child: Column(
            children: [
              welcomeText(),
              const Divider(
                thickness: 2.0,
                color: Colors.white,
              ), // Add divider to separate sections
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                margin: const EdgeInsets.only(left: 25.00),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Materi', // Replace with your actual title
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                spacing: 10.0,
                children: List.generate(
                  pictures.length,
                  (index) => animations(width, index),
                ), // Add spacing between widgets
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                margin: const EdgeInsets.only(left: 25.00),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Latihan Soal', // Replace with your actual title
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                spacing: 10.0,
                children: List.generate(
                  pictures.length,
                  (index) => animations(width, index),
                ), // Add spacing between widgets
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                margin: const EdgeInsets.only(left: 25.00),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Pengajar', // Replace with your actual title
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                children: [
                  ...List.generate(teacherNames.length,
                      (index) => teacherSquare(teacherNames[index])),
                  // You can add teacher squares here if needed
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
