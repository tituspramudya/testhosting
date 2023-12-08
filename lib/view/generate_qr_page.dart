import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class GenerateQRPage extends StatefulWidget {
  const GenerateQRPage({super.key, 
    required this.harga,
  });

  final String? harga;

  @override
  State<GenerateQRPage> createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage>  {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('QR Generate'),
      ),
      body: Center(
        child: QrImageView(
          data: widget.harga!,
          version: 6,
          padding: const EdgeInsets.all(50),
        ),
      ),
    );
  }
}