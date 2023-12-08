import 'package:flutter/material.dart';

class gridView extends StatefulWidget {
  const gridView({super.key});

  @override
  State<gridView> createState() => _gridViewState();
}

class _gridViewState extends State<gridView> {
  static const jumlahWidget = 8;

  List<bool> statusExpand = List.generate(jumlahWidget, (index) => false);

  Widget animations(double width, int index) {
    bool isExpanded = statusExpand[index];

    String stringStatus = isExpanded ? 'Expanded' : 'TAP';

    return GestureDetector(
      onTap: () {
        setState(() {
          statusExpand[index] = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        margin: const EdgeInsets.all(12.0),
        width: !isExpanded ? width * 0.4 : width * 0.86,
        height: !isExpanded ? width * 0.4 : width * 0.86,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Center(
          child: Text(
            stringStatus,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Align(
        child: SingleChildScrollView(
          child: Wrap(
            children: List.generate(jumlahWidget, (index) {
              return animations(width, index);
            }),
          ),
        ),
      ),
    );
  }
}
