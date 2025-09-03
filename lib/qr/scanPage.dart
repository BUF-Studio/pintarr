import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pintarr/after/afterNavi.dart';
import 'package:pintarr/color.dart';
import 'package:pintarr/content/unit/detail/unitDetailMobile.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/importFile.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({
    Key? key,
    // required this.checkin,
  }) : super(key: key);

  // final bool checkin;

  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String? qrText = '';

  // var flashState = flashOn;
  // var cameraState = frontCamera;
  // // QRViewController? controller;

  MobileScannerController controller = MobileScannerController();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  alert(text) {
    return Alert.box(context, 'Error', Text(text), <Widget>[
      Alert.ok(context, () {
        Navigator.of(context).pop();
      }, 'Try Again'),
    ]);
  }

  success(text) {
    return Alert.box(context, 'Success', Text(text), <Widget>[
      Alert.ok(context, () {
        Navigator.of(context).pop();
      }, 'Ok'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // Shared shared = Provider.of<Shared>(context);
    Database database = Provider.of<Database>(context);
    // final UnitsController unitsController = Provider.of<UnitsController>(context);

    read(result) {
      // final UnitsController unitsController = Provider.of<UnitsController>(context,listen: false);

      final list = Provider.of<List<Unit>>(context, listen: false);
      final navi = Provider.of<AfterNavi>(context, listen: false);
      final unitNavi = Provider.of<UnitNavi>(context, listen: false);
      final Unit? unit = list.firstWhereOrNull((e) => e.id == result);

      if (unit != null) {
        controller.stop();
        if (!Responsive.isMobile(context)) {
          navi.updatePage(AfterPages.unit);
          unitNavi.updateUnit(UnitPages.detail, ut: unit, backk: unitNavi.unit);
          if (Platform.isAndroid || Platform.isIOS) {
            Navigator.of(context).pop();
          }
        }

        if (Responsive.isMobile(context)) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => UnitDetailMobile(unit)),
          );
        }
      }
    }

    pic() async {
      String? path;
      if (Platform.isAndroid || Platform.isIOS) {
        try {
          XFile? image = await ImagePicker().pickImage(
            source: ImageSource.gallery,
          );
          path = image?.path;
        } catch (e) {
          print(e);
        }
      } else {
        path = await ImportFile.choose();
      }
      try {
        final result = await controller.analyzeImage(path!);

        if (result!.barcodes.isNotEmpty) {
          String? res = result.barcodes.first.rawValue;

          if (res != null) {
            setState(() {
              qrText = res;
            });
            read(qrText);
          } else {
            // Handle the case where the rawValue is null
            setState(() {
              qrText = 'No data found in QR code';
            });
            alert('No data found in QR code.');
          }
        } else {
          // Handle the case where no barcodes are detected
          setState(() {
            qrText = 'No QR code found in image';
          });
          alert('No QR code found in the image.');
        }
      } catch (e) {
        setState(() {
          qrText = 'Error';
        });
        alert('Error while interpreting QR code from image.');
        print(e);
      }
    }

    const double a = 0.25;
    const BorderSide b = BorderSide(color: darkBlue, width: 4);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          controller.start();
        },
        child: Stack(
          children: <Widget>[
            MobileScanner(
              // allowDuplicates: false,
              controller: controller,
              // fit: ,
              onDetect: (barcode) {
                // controller.stop();

                // bool ctn = false;

                if (barcode.barcodes.first.rawValue == null) {
                  alert('Failed to interpret QR code.');
                } else {
                  String read = barcode.barcodes.first.rawValue!;

                  setState(() {
                    qrText = read;
                  });
                  final list = Provider.of<List<Unit>>(context, listen: false);
                  final navi = Provider.of<AfterNavi>(context, listen: false);
                  final unitNavi = Provider.of<UnitNavi>(
                    context,
                    listen: false,
                  );
                  // final database = Provider.of<Database>(context, listen: false);
                  // final client = Provider.of<Client>(context, listen: false);
                  try {
                    final Unit? unit = list.firstWhereOrNull(
                      (e) => e.id == read,
                    );
                    if (unit != null) {
                      controller.stop();

                      if (!Responsive.isMobile(context)) {
                        navi.updatePage(AfterPages.unit);
                        unitNavi.updateUnit(
                          UnitPages.detail,
                          ut: unit,
                          backk: unitNavi.unit,
                        );
                        if (Platform.isAndroid || Platform.isIOS) {
                          Navigator.of(context).pop();
                        }
                      }
                      if (Responsive.isMobile(context)) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UnitDetailMobile(unit),
                          ),
                        );
                      }
                    }
                  } catch (e) {}
                }
              },
            ),
            Align(
              alignment: Alignment(0, -0.3),
              // alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  margin: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 25 / 100,
                  ),

                  // height: 300,
                  // width: 400,
                  // decoration: BoxDecoration(
                  //   border: Border()
                  // ),
                  child: LayoutBuilder(
                    builder: (context, con) {
                      return Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(top: b, left: b),
                              ),
                              height: con.maxHeight * a,
                              width: con.maxWidth * a,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(top: b, right: b),
                              ),
                              height: con.maxHeight * a,
                              width: con.maxWidth * a,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(bottom: b, left: b),
                              ),
                              height: con.maxHeight * a,
                              width: con.maxWidth * a,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(bottom: b, right: b),
                              ),
                              height: con.maxHeight * a,
                              width: con.maxWidth * a,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top + 15,
                left: 15,
                right: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: pic,
                    icon: const Icon(Icons.photo_library, color: Colors.white),
                  ),
                ],
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.55),
              child: TorchToggleButton(controller: controller),
              // child: IconButton(
              //   color: Colors.white,
              //   icon: ValueListenableBuilder(
              //     valueListenable: controller.torchState,
              //     builder: (context, state, child) {
              //       switch (state as TorchState) {
              //         case TorchState.off:
              //           return const Icon(Icons.flash_off, color: Colors.grey);
              //         case TorchState.on:
              //           return const Icon(Icons.flash_on, color: Colors.yellow);
              //       }
              //     },
              //   ),
              //   iconSize: 32.0,
              //   onPressed: () => controller.toggleTorch(),
              // ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class TorchToggleButton extends StatefulWidget {
  final MobileScannerController controller;
  const TorchToggleButton({super.key, required this.controller});

  @override
  State<TorchToggleButton> createState() => _TorchToggleButtonState();
}

class _TorchToggleButtonState extends State<TorchToggleButton> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerValueChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerValueChanged);
    super.dispose();
  }

  void _onControllerValueChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final torchState = widget.controller.value.torchState;
    final isOn = torchState == TorchState.on;

    return IconButton(
      icon: Icon(
        isOn ? Icons.flash_on : Icons.flash_off,
        color: isOn ? Colors.yellow : Colors.grey,
      ),
      iconSize: 32.0,
      onPressed: () => widget.controller.toggleTorch(),
      tooltip: 'Toggle Flashlight',
    );
  }
}

// class ScanPage extends StatefulWidget {
//   const ScanPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _ScanPageState();
// }

// class _ScanPageState extends State<ScanPage> {
//   String? qrText = '';
//   var flashState = flashOn;
//   var cameraState = frontCamera;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

//   pic() async {
//     String? path;
//     if (Platform.isAndroid || Platform.isIOS) {
//       try {
//         PickedFile? image =
//             await ImagePicker().getImage(source: ImageSource.gallery);
//         path = image?.path;
//       } catch (e) {
//         print(e);
//       }
//     } else {
//       path = await ImportFile.choose();
//     }
//     try {
//       var result = await FlutterQrReader.imgScan(File(path!));
//       setState(() {
//         qrText = result;
//       });
//       final list = Provider.of<List<Unit>>(context, listen: false);
//       final navi = Provider.of<AfterNavi>(context, listen: false);
//       final unitNavi = Provider.of<UnitNavi>(context, listen: false);

//       final Unit? unit = list!.firstWhere((e) => e!.id == result);
//       if (unit != null) {
//         controller!.pauseCamera();
//         if (!Responsive.isMobile(context)) {
//           navi.updatePage(AfterPages.unit);
//           unitNavi.updateUnit(UnitPages.detail, unit, backk: unitNavi.unit);
//           if (Platform.isAndroid || Platform.isIOS) Navigator.of(context).pop();
//         }

//         if (Responsive.isMobile(context))
//           Navigator.of(context).push(
//               MaterialPageRoute(builder: (context) => UnitDetailMobile(unit)));
//       }
//     } catch (e) {
//       setState(() {
//         qrText = 'Error';
//       });
//       Alert.box(context, 'Error',
//           const Text('Error while interprting qrcode from image.'), <Widget>[
//         Alert.ok(context, () {
//           Navigator.of(context).pop();
//         }, 'Try Again')
//       ]);
//       print(e);
//     }
//   }

//   flash() {
//     if (controller != null) {
//       controller!.toggleFlash();
//       if (_isFlashOn(flashState)) {
//         setState(() {
//           flashState = flashOff;
//         });
//       } else {
//         setState(() {
//           flashState = flashOn;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () {
//           controller!.resumeCamera();
//         },
//         child: Stack(
//           children: <Widget>[
//             QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//               overlay: QrScannerOverlayShape(
//                 borderColor: lightBlue,
//                 borderRadius: 10,
//                 borderLength: 30,
//                 borderWidth: 10,
//                 cutOutSize: 300,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                   top: MediaQuery.of(context).viewPadding.top + 15,
//                   left: 15,
//                   right: 15),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     icon: const Icon(
//                       Icons.arrow_back,
//                       color: Colors.white,
//                     ),
//                   ),
//                   IconButton(
//                       onPressed: pic,
//                       icon: const Icon(
//                         Icons.photo_library,
//                         color: Colors.white,
//                       )),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: const Alignment(0, 0.6),
//               child: IconButton(
//                 onPressed: flash,
//                 icon: const Icon(
//                   Icons.emoji_objects,
//                   color: Colors.white,
//                   size: 50,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   bool _isFlashOn(String current) {
//     return flashOn == current;
//   }

//   // bool _isBackCamera(String current) {
//   //   return backCamera == current;
//   // }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         qrText = scanData.code;
//       });
//       final list = Provider.of<List<Unit>>(context, listen: false);
//       final navi = Provider.of<AfterNavi>(context, listen: false);
//       final unitNavi = Provider.of<UnitNavi>(context, listen: false);
//       // final database = Provider.of<Database>(context, listen: false);
//       // final client = Provider.of<Client>(context, listen: false);
//       try {
//         final Unit? unit = list!.firstWhere((e) => e!.id == scanData.code);
//         if (unit != null) {
//           controller.pauseCamera();

//           if (!Responsive.isMobile(context)) {
//             navi.updatePage(AfterPages.unit);
//             unitNavi.updateUnit(UnitPages.detail, unit, backk: unitNavi.unit);
//             if (Platform.isAndroid || Platform.isIOS)
//               Navigator.of(context).pop();
//           }
//           if (Responsive.isMobile(context))
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => UnitDetailMobile(unit)));
//         }
//       } catch (e) {}
//     });
//   }

//   @override
//   void dispose() {
//     controller!.dispose();
//     super.dispose();
//   }
// }
