// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpay_clone/resources/utils.dart';
import 'package:gpay_clone/screens/payment_screen.dart';
import 'package:gpay_clone/screens/register_new_user_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanPage extends StatefulWidget {
  final bool readQr;
  const ScanPage({Key? key, this.readQr = false}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String id = '';

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller!.resumeCamera();
  //   }
  // }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  buildQrView(context),
                  Positioned(bottom: 50, child: buildResult()),
                  // Positioned(top: 60, child: scanAnyQR()),

                  //child: Text('Hi'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget scanAnyQR() => Container(
        child: Column(
          children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 60),
                Text(
                  'Scan Any QR Code',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(width: 65),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    const IconData(
                      0xf645,
                      fontFamily: 'MaterialIcons',
                      matchTextDirection: true,
                    ),
                    size: 30,
                  ),
                ),
                //Icon(const IconData(0xf645, fontFamily: 'MaterialIcons', matchTextDirection: true),size: 15)),
              ],
            ),
          ],
        ),
      );
  Widget buildResult() => Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xfff202126).withOpacity(0.8),
        ),
        child: Text(
          'Show Payment Code',
          style: TextStyle(color: Colors.blue, fontSize: 16),
          maxLines: 3,
        ),
      );
  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: (controller) => onQRViewCreated(controller, context),

        overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          // overlayColor: Colors.red,
          borderWidth: 10,
          borderLength: 40,
          borderRadius: 20,
          cutOutBottomOffset: 70,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
        //onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );
  void onQRViewCreated(
      QRViewController controller, BuildContext context) async {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      if (result != null && scanData != null) {
        id = '${result!.code}';
        if (widget.readQr) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => RegisterNewUserScreen(
              scanID: urlEncode(id),
            ),
          ));
        } else {
          try {
            String upiID = "";
            final FirebaseFirestore firebaseFirestore =
                FirebaseFirestore.instance;

            DocumentReference scanLinkDoc =
                firebaseFirestore.collection("scan_id_link").doc(urlEncode(id));
            DocumentSnapshot scanLinkSnap = await scanLinkDoc.get();
            if (scanLinkSnap.exists) {
              upiID = scanLinkSnap['upiID'];
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => PaymentScreen(
                  upiID: upiID,
                ),
              ));
            } else {
              throw Exception();
            }
          } on Exception catch (e) {
            showSnackBar(context, "User Not Found");
          }
        }
      }

      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => PaymentPage(),
      // ));
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }
}

// class QRScannerOverlayPainter extends CustomPainter {
//   final QrScannerOverlayShape overlayShape = QrScannerOverlayShape(
//     borderColor: Colors.blue,
//     borderWidth: 10,
//     borderLength: 40,
//     borderRadius: 20,
//     cutOutBottomOffset: 70,
//   );

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = overlayShape.borderColor!
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = overlayShape.borderWidth!;

//     final Rect rect = Rect.fromLTWH(
//       0,
//       0,
//       size.width,
//       size.height,
//     );

//     canvas.drawRect(rect, paint);

//     final double cutOutSize = size.width * 0.8; // Adjust as needed
//     final double left = (size.width - cutOutSize) / 2;
//     final double top = (size.height - cutOutSize) / 2;

//     final Rect innerRect = Rect.fromLTWH(
//       left,
//       top,
//       cutOutSize,
//       cutOutSize,
//     );

//     final RRect cutOutRect = RRect.fromRectAndCorners(
//       innerRect,
//       topLeft: Radius.circular(overlayShape.borderRadius!),
//       topRight: Radius.circular(overlayShape.borderRadius!),
//       bottomLeft: Radius.circular(overlayShape.borderRadius!),
//       bottomRight: Radius.circular(overlayShape.borderRadius!),
//     );

//     canvas.drawRRect(cutOutRect, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

// class QrScannerOverlayShape {
//   final Color? borderColor;
//   final double? borderWidth;
//   final double? borderLength;
//   final double? borderRadius;
//   final double? cutOutBottomOffset;

//   QrScannerOverlayShape({
//     this.borderColor,
//     this.borderWidth,
//     this.borderLength,
//     this.borderRadius,
//     this.cutOutBottomOffset,
//   });
// }
