import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tankerpcmc/stp/scandatapage.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedData = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      endDrawer: const DrawerWid(),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Center(
          //     child: Text('Scanned Data: $scannedData'),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedData = scanData.code.toString();
      });
      // Pause the camera before navigating to ScannedDataPage
      controller.pauseCamera();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScannedDataPage(
            scannedData: scanData.code.toString(),
          ),
        ),
      );
      // print(scanData.code.toString());

      // scannedData = ''; // Reset scannedData variable
    });
    startScanning();
  }

  void startScanning() async {
    try {
      await Future.delayed(
          Duration.zero); // To avoid setState being called during build.
      // await controller?.flipCamera();
      // controller?.toggleFlash();
      controller?.resumeCamera();
      // ignore: empty_catches
    } catch (ex) {}
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
