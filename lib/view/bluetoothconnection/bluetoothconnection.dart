// // import 'dart:typed_data';
// // import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:flutter/services.dart';
// import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/esc_pos_utils_platform.dart';
// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

// // import 'package:flutter_esc_pos_utils_image_3/flutter_esc_pos_utils_image_3.dart';
// // import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'dart:typed_data' show ByteData, Uint8List;
// import 'package:image/image.dart' as img;
// import 'package:intl/intl.dart';
// import '../billdetails/controller/billdetails.dart';

// // import 'package:intl/intl.dart';
// // import '../billdetails/controller/billdetails.dart';
// //
// // import 'package:screenshot/screenshot.dart';

// class BluetoothConnectionPage extends StatefulWidget {
//   const BluetoothConnectionPage({
//     super.key,
//   });

//   @override
//   State<BluetoothConnectionPage> createState() =>
//       _BluetoothConnectionPageState();
// }

// class _BluetoothConnectionPageState extends State<BluetoothConnectionPage> {
//   BillPrintController billPrintController = Get.put(BillPrintController());
//   // ScreenshotController screenshotController = ScreenshotController();

//   var defaultPrinterType = PrinterType.bluetooth;
//   var _isBle = false;
//   var _reconnect = false;
//   var _isConnected = false;
//   var printerManager = PrinterManager.instance;
//   var devices = <BluetoothPrinter>[];
//   StreamSubscription<PrinterDevice>? _subscription;
//   StreamSubscription<BTStatus>? _subscriptionBtStatus;
//   StreamSubscription<USBStatus>? _subscriptionUsbStatus;
//   StreamSubscription<TCPStatus>? _subscriptionTCPStatus;
//   BTStatus _currentStatus = BTStatus.none;
//   // ignore: unused_field
//   TCPStatus _currentTCPStatus = TCPStatus.none;
//   // _currentUsbStatus is only supports on Android
//   // ignore: unused_field
//   USBStatus _currentUsbStatus = USBStatus.none;
//   List<int>? pendingTask;
//   String _ipAddress = '';
//   String _port = '9100';
//   final _ipController = TextEditingController();
//   final _portController = TextEditingController();
//   BluetoothPrinter? selectedPrinter;

//   String rrNumber = Get.parameters['rrNumber'].toString();
//   String zoneName = GetStorage().read('zoneName');

//   img.Image? _resize1;

//   @override
//   void initState() {
//     if (Platform.isWindows) defaultPrinterType = PrinterType.usb;
//     super.initState();
//     _portController.text = _port;
//     _scan();

//     // subscription to listen change status of bluetooth connection
//     _subscriptionBtStatus =
//         PrinterManager.instance.stateBluetooth.listen((status) {
//       log(' ----------------- status bt $status ------------------ ');
//       _currentStatus = status;
//       if (status == BTStatus.connected) {
//         // hitPrintApi(); // hit api
//         setState(() {
//           _isConnected = true;
//         });
//       }
//       if (status == BTStatus.none) {
//         setState(() {
//           _isConnected = false;
//         });
//       }
//       if (status == BTStatus.connected && pendingTask != null) {
//         if (Platform.isAndroid) {
//           Future.delayed(const Duration(milliseconds: 1000), () {
//             PrinterManager.instance
//                 .send(type: PrinterType.bluetooth, bytes: pendingTask!);
//             pendingTask = null;
//           });
//         } else if (Platform.isIOS) {
//           PrinterManager.instance
//               .send(type: PrinterType.bluetooth, bytes: pendingTask!);
//           pendingTask = null;
//         }
//       }
//     });
//     //  PrinterManager.instance.stateUSB is only supports on Android
//     _subscriptionUsbStatus = PrinterManager.instance.stateUSB.listen((status) {
//       log(' ----------------- status usb $status ------------------ ');
//       _currentUsbStatus = status;
//       if (Platform.isAndroid) {
//         if (status == USBStatus.connected && pendingTask != null) {
//           Future.delayed(const Duration(milliseconds: 1000), () {
//             PrinterManager.instance
//                 .send(type: PrinterType.usb, bytes: pendingTask!);
//             pendingTask = null;
//           });
//         }
//       }
//     });

//     //  PrinterManager.instance.stateUSB is only supports on Android
//     _subscriptionTCPStatus = PrinterManager.instance.stateTCP.listen((status) {
//       log(' ----------------- status tcp $status ------------------ ');
//       _currentTCPStatus = status;
//     });
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     _subscriptionBtStatus?.cancel();
//     _subscriptionUsbStatus?.cancel();
//     _subscriptionTCPStatus?.cancel();
//     _portController.dispose();
//     _ipController.dispose();
//     super.dispose();
//   }

//   // method to scan devices according PrinterType
//   void _scan() {
//     devices.clear();
//     _subscription = printerManager
//         .discovery(type: defaultPrinterType, isBle: _isBle)
//         .listen((device) {
//       devices.add(BluetoothPrinter(
//         deviceName: device.name,
//         address: device.address,
//         isBle: _isBle,
//         vendorId: device.vendorId,
//         productId: device.productId,
//         typePrinter: defaultPrinterType,
//       ));
//       setState(() {});
//     });
//   }

//   void setPort(String value) {
//     if (value.isEmpty) value = '9100';
//     _port = value;
//     var device = BluetoothPrinter(
//       deviceName: value,
//       address: _ipAddress,
//       port: _port,
//       typePrinter: PrinterType.network,
//       state: false,
//     );
//     selectDevice(device);
//   }

//   void setIpAddress(String value) {
//     _ipAddress = value;
//     var device = BluetoothPrinter(
//       deviceName: value,
//       address: _ipAddress,
//       port: _port,
//       typePrinter: PrinterType.network,
//       state: false,
//     );
//     selectDevice(device);
//   }

//   void selectDevice(BluetoothPrinter device) async {
//     if (selectedPrinter != null) {
//       if ((device.address != selectedPrinter!.address) ||
//           (device.typePrinter == PrinterType.usb &&
//               selectedPrinter!.vendorId != device.vendorId)) {
//         await PrinterManager.instance
//             .disconnect(type: selectedPrinter!.typePrinter);
//       }
//     }

//     selectedPrinter = device;
//     setState(() {});
//   }
// //
// // Uint8List textToImage(String text) {
// //   // Define image properties
// //   int width = 200; // Set your desired width (in pixels)
// //   int height = 50; // Set your desired height (in pixels)
// //   img.Image image = img.Image(width, height);

// //   // Fill the image with a white background
// //   img.fill(image, img.getColor(255, 255, 255));

// //   // Define text properties (you may need to adjust these based on your printer's capabilities)
// //   int fontSize = 12;
// //   int textColor = img.getColor(0, 0, 0); // Black color

// //   // Draw the text on the image
// //   img.drawString(
// //     image,
// //     img.arial_24, // You can use a different font if needed
// //     width ~/ 2, // Center the text horizontally
// //     height ~/ 2, // Center the text vertically
// //     text,
// //     color: textColor,
// //     textAlign: img.TextAlign.center,
// //   );

// //   // Encode the image to PNG format (or other formats supported by your printer)
// //   Uint8List pngBytes = Uint8List.fromList(img.encodePng(image));

// //   return pngBytes;
// // }
// // // print test ticket
// //   void printTicket() {
// //     // make a screenshot with data
// //     screenshotController
// //         .captureFromWidget(
// //             const SizedBox(
// //               width: 140,
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   // SizedBox(
// //                   //   width: 140 * 0.5,
// //                   //   child: Image.asset("assets/flutter.png"),
// //                   // ),
// //                   Text(
// //                     "hellpp",
// //                     maxLines: 5,
// //                     style: TextStyle(
// //                       fontSize: 10,
// //                       fontWeight: FontWeight.w400,
// //                       color: Colors.black,
// //                     ),
// //                   ),
// //                   Text(
// //                     "hello",
// //                     maxLines: 5,
// //                     style: TextStyle(
// //                       fontSize: 10,
// //                       fontWeight: FontWeight.w400,
// //                       color: Colors.black,
// //                     ),
// //                   ),
// //                   Text(
// //                     "Hello",
// //                     maxLines: 5,
// //                     style: TextStyle(
// //                       fontSize: 10,
// //                       fontWeight: FontWeight.w400,
// //                       color: Colors.black,
// //                     ),
// //                   ),
// //                   Text(
// //                     "Hello",
// //                     maxLines: 5,
// //                     textAlign: TextAlign.right,
// //                     style: TextStyle(
// //                       fontSize: 10,
// //                       fontWeight: FontWeight.w400,
// //                       color: Colors.black,
// //                     ),
// //                   ),
// //                   SizedBox(height: 16.0),
// //                   // SizedBox(
// //                   //   width: 140 * 0.5,
// //                   //   child: BarcodeWidget(
// //                   //     barcode: barcodeWidget.Barcode.qrCode(),
// //                   //     data: 'Hello Flutter I Love You!',
// //                   //   ),
// //                   // )
// //                 ],
// //               ),
// //             ),
// //             delay: const Duration(milliseconds: 500))
// //         .then(
// //       (capturedImage) async {
// //         // print screenshot data
// //         List<int> bytes = [];
// //         // Using default profile
// //         final profile = await CapabilityProfile.load();
// //         final generator = Generator(PaperSize.mm58, profile);
// //         bytes += generator.reset();
// //         // Handle captured image
// //         // final imageLib.Image? image = imageLib.decodeImage(capturedImage);
// //         // bytes += generator.image(image!);
// //         // bytes += generator.feed(1);
// //         //bytes += generator.cut();
// //         _printEscPos(bytes, generator);
// //       },
// //     );
// //   }

// //   Future<void> printReceiptText(
// //     ReceiptSectionText text, {
// //     PaperSize paperSize = PaperSize.mm80,
// //   }) async {
// //     final Uint8List bytes = await contentToImage(
// //       content: text.content,
// //       duration: 0,
// //     );
// //     final List<int> byteBuffer = await _getBytes(
// //       bytes,
// //       paperSize: paperSize,
// //     );
// //     final _profile = await CapabilityProfile.load();
// //     Generator generator = Generator(PaperSize.mm80, _profile);
// //     _printEscPos(byteBuffer, generator);
// //   }

// //   ///
// //   ///
// //   static const MethodChannel _channel = MethodChannel('blue_print_pos');
// //   static Future<Uint8List> contentToImage({
// //     required String content,
// //     double duration = 0,
// //   }) async {
// //     final Map<String, dynamic> arguments = <String, dynamic>{
// //       'content': content,
// //       'duration': duration,
// //     };
// //     Uint8List results = Uint8List.fromList(<int>[]);
// //     try {
// //       results = await _channel.invokeMethod('contentToImage', arguments) ??
// //           Uint8List.fromList(<int>[]);
// //     } on Exception catch (e) {
// //       log('[method:contentToImage]: $e');
// //       throw Exception('Error: $e');
// //     }
// //     return results;
// //   }

// // //
// //   Future _getBytes(
// //     List<int> data, {
// //     PaperSize paperSize = PaperSize.mm80,
// //   }) async {
// //     List<int> bytes = <int>[];
// //     final CapabilityProfile profile = await CapabilityProfile.load();
// //     final Generator generator = Generator(paperSize, profile);
// //     // if (data != null) {
// //     img.Image? decodedImage = img.decodeImage(Uint8List.fromList(data));

// //     if (decodedImage != null) {
// //       final img.Image _resize = img.copyResize(
// //         decodedImage,
// //         width: 50,
// //       );
// //       bytes += generator.image(_resize);
// //     } else {
// //       print("Failed to decode the image.");
// //     }

// //     return bytes;
// //     // }
// //   }

// // //

//   Future _printReceiveTest() async {
//     List<int> bytes = [];

//     // Xprinter XP-N160I
//     // final profile = await CapabilityProfile.load(name: 'XP-N160I');
//     // default profile
//     final profile = await CapabilityProfile.load();

//     // PaperSize.mm80 or PaperSize.mm58

//     final generator = Generator(PaperSize.mm80, profile);

//     bytes += generator.row([
//       PosColumn(
//         text: 'RURAL WATER SUPPLY BILL : ${GetStorage().read('zoneName')} ',
//         width: 12,
//         styles: const PosStyles(
//           align: PosAlign.center,
//           // height: PosTextSize.size4,s
//           // width: PosTextSize.size4,
//         ),
//       ),
//     ]);

//     // final Uint8List bytes2 = await contentToImage(
//     //   content: receiptSectionText.content,
//     //   duration: duration,
//     // //
//     // final ByteData data = await rootBundle.load('images/nic.png');
//     // final Uint8List bytes1 = data.buffer.asUint8List();

//     // // Uint8List? data1 = Uint8List.fromList([/* Your raw image data here */]);

//     // if (data != null) {
//     //   img.Image? decodedImage = img.decodeImage(bytes1);

//     //   if (decodedImage != null) {
//     //     final img.Image _resize = img.copyResize(
//     //       decodedImage,
//     //       width: 50,
//     //     );
//     //     setState(() {
//     //       _resize1 = _resize;
//     //     });

//     //     final Map<String, dynamic> arguments = <String, dynamic>{
//     //   'content': "Text",// add print text
//     //   'duration':  0,
//     // };
//     // Uint8List results = Uint8List.fromList(<int>[]);

//     //   results = await _channel.invokeMethod('contentToImage', arguments) ??
//     //       Uint8List.fromList(<int>[]);
//     //     // You can now use the resized image stored in _resize variable.
//     //     // For example, you can save it to a file or display it in a Flutter app.
//     //   } else {
//     //     print("Failed to decode the image.");
//     //   }
//     // }
// //     bytes += generator.hr();
// //     bytes += generator.image(_resize1!);
// //     generator.imageRaster(_resize1!);
// // // Using `GS ( L`
// //     generator.imageRaster(_resize1!, imageFn: PosImageFn.graphics);
// //     bytes += generator.text("CUSTOMER DETAILS",
// //         styles: const PosStyles(align: PosAlign.center));

//     bytes += generator.hr();
//     bytes += generator.row([
//       PosColumn(
//           text: 'RR Number',
//           width: 6,
//           styles: const PosStyles(
//             align: PosAlign.left,
//           )),
//       PosColumn(
//           text: ':',
//           width: 1,
//           styles: const PosStyles(
//             align: PosAlign.right,
//           )),
//       PosColumn(
//           text: billPrintController.details[0]['RRNumber'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(
//             align: PosAlign.left,
//           )),
//     ]);
//     bytes += generator.row([
//       PosColumn(
//           text: 'Consumer Number',
//           width: 6,
//           styles: const PosStyles(
//             align: PosAlign.left,
//           )),
//       PosColumn(
//           text: ':',
//           width: 1,
//           styles: const PosStyles(
//             align: PosAlign.right,
//           )),
//       PosColumn(
//           text: billPrintController.details[0]['ConsumerID'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(
//             align: PosAlign.left,
//           )),
//     ]);
//     bytes += generator.row([
//       PosColumn(
//           text: 'Address',
//           width: 6,
//           styles: const PosStyles(
//             align: PosAlign.left,
//           )),
//       PosColumn(
//           text: ':',
//           width: 1,
//           styles: const PosStyles(
//             align: PosAlign.right,
//           )),
//       PosColumn(
//           text:
//               "${billPrintController.details[0]['address'].toString()}, ${billPrintController.details[0]['address1'].toString()}, ${billPrintController.details[0]['city'].toString()} ${billPrintController.details[0]['pincode'].toString()}" ??
//                   '',
//           width: 5,
//           styles: const PosStyles(
//             align: PosAlign.left,
//           )),
//     ]);

//     bytes += generator.hr();

//     bytes += generator.text('BILL DETAILS',
//         styles: const PosStyles(align: PosAlign.center));

//     bytes += generator.hr();
//     bytes += generator.row([
//       PosColumn(
//         text: 'Bill No. ',
//         width: 6,
//         styles: const PosStyles(align: PosAlign.left),
//       ),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//         text: billPrintController.details[0]['BillNumber'].toString() ?? '',
//         width: 5,
//         styles: const PosStyles(align: PosAlign.left),
//       ),
//     ]);

//     bytes += generator.row([
//       PosColumn(
//           text: 'Bill Date',
//           width: 6,
//           styles: const PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: billPrintController.details[0]['BillDate'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);

//     bytes += generator.row([
//       PosColumn(
//           text: 'Tariff',
//           width: 6,
//           styles: const PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: billPrintController.details[0]['tariff'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);
//     bytes += generator.row([
//       PosColumn(
//           text: 'Bill Period',
//           width: 6,
//           styles: const PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: billPrintController.details[0]['Billperiod'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);
//     bytes += generator.row([
//       PosColumn(
//           text: 'Due Date To Pay',
//           width: 6,
//           styles: const PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: billPrintController.details[0]['DueDate'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);

//     bytes += generator.hr();

//     bytes += generator.text("METER DETAILS",
//         styles: const PosStyles(align: PosAlign.center));

//     bytes += generator.hr();
//     bytes += generator.row([
//       PosColumn(
//           text: 'Meter No.',
//           width: 6,
//           styles: const PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: billPrintController.details[0]['meternumber'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);
//     bytes += generator.row([
//       PosColumn(
//           text: 'Meter Reader',
//           width: 6,
//           styles: const PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: billPrintController.details[0]['RRNumber'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);
//     bytes += generator.row([
//       PosColumn(
//           text: 'Present Reading(Ltrs)',
//           width: 6,
//           styles: const PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text:
//               billPrintController.details[0]['presentreading'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);
//     bytes += generator.row([
//       PosColumn(
//           text: 'Previous Reading(Ltrs)',
//           width: 6,
//           styles: const PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: billPrintController.details[0]['prevreading'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);

//     bytes += generator.row([
//       PosColumn(
//           text: 'Consumption(Ltrs)',
//           width: 6,
//           styles: const PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: billPrintController.details[0]['consumption'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);
//     bytes += generator.hr();
//     bytes += generator.text(
//       'BILL DESCRIPTION',
//       styles: const PosStyles(align: PosAlign.center),
//     );

//     bytes += generator.hr();
//     bytes += generator.row([
//       PosColumn(
//         text: 'Water Charge',
//         width: 6,
//         styles: const PosStyles(align: PosAlign.left),
//       ),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: billPrintController.details[0]['watercharges'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);
//     bytes += generator.row([
//       PosColumn(
//           text: 'Other Charges',
//           width: 6,
//           styles: const PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: billPrintController.details[0]['OtherCharges'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);
//     bytes += generator.row([
//       PosColumn(
//           text: 'Arrears',
//           width: 6,
//           styles: const PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: billPrintController.details[0]['Arrears'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);
//     bytes += generator.row([
//       PosColumn(
//           text: 'Int. On Arrears',
//           width: 6,
//           styles: const PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: billPrintController.details[0]['intonArrears'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);
//     bytes += generator.row([
//       PosColumn(
//           text: 'Write Off',
//           width: 6,
//           styles: const PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: billPrintController.details[0]['writeoff'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);
//     bytes += generator.row([
//       PosColumn(
//           text: 'Adj Amount',
//           width: 6,
//           styles: const PosStyles(align: PosAlign.left)),
//       PosColumn(
//           text: ':', width: 1, styles: const PosStyles(align: PosAlign.right)),
//       PosColumn(
//           text: billPrintController.details[0]['adjamount'].toString() ?? '',
//           width: 5,
//           styles: const PosStyles(align: PosAlign.left)),
//     ]);
//     bytes += generator.hr();
//     bytes += generator.row([
//       PosColumn(
//           text: 'TOTAL',
//           width: 6,
//           styles: const PosStyles(
//             align: PosAlign.left,
//             height: PosTextSize.size2,
//             width: PosTextSize.size2,
//           )),
//       PosColumn(
//           text: ":",
//           width: 1,
//           styles: const PosStyles(
//             align: PosAlign.center,
//             height: PosTextSize.size2,
//             width: PosTextSize.size2,
//           )),
//       PosColumn(
//         text: billPrintController.details[0]['totalamount'].toString() ?? "",
//         width: 5,
//         styles: const PosStyles(
//           align: PosAlign.left,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//           bold: true,
//         ),
//       ),
//     ]);

//     // bytes += generator.hr();

//     // bytes += generator.qrcode('Link to pay',
//     //     size: QRSize.Size7, align: PosAlign.center, cor: QRCorrection.H);
//     bytes += generator.hr();
//     //
//     // DateTime now = DateTime.now();
//     // String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
//     // bytes += generator.text(formattedDate,
//     //     styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

//     // bytes += generator.text("Powered by Karnataka NIC",
//     //     styles: const PosStyles(
//     //       align: PosAlign.center,
//     //     ));
//     bytes += generator.hr();
//     bytes += generator.cut();

//     _printEscPos(bytes, generator);
//   }

//   // Future<void> _onPrintReceipt() async {
//   //   /// Example for Print Image
//   //   // final ByteData logoBytes = await rootBundle.load(
//   //   //   'assets/logo.jpg',
//   //   // );

//   //   /// Example for Print Text
//   //   final ReceiptSectionText receiptText = ReceiptSectionText();
//   //   // receiptText.addImage(
//   //   //   base64.encode(Uint8List.view(logoBytes.buffer)),
//   //   //   width: 150,
//   //   // );
//   //   // receiptText.addSpacer();
//   //   receiptText.addText(
//   //     'MY STORE',
//   //     // size: ReceiptTextSizeType.medium,
//   //     // style: ReceiptTextStyleType.bold,
//   //   );
//   //   // receiptText.addText(
//   //   //   'Black White Street, Jakarta, Indonesia',
//   //   //   size: ReceiptTextSizeType.small,
//   //   // );
//   //   // receiptText.addSpacer(useDashed: true);
//   //   // receiptText.addLeftRightText('Time', '04/06/21, 10:00');
//   //   // receiptText.addSpacer(useDashed: true);
//   //   // receiptText.addLeftRightText(
//   //   //   'Apple 1kg',
//   //   //   'Rp30.000',
//   //   //   leftStyle: ReceiptTextStyleType.normal,
//   //   //   rightStyle: ReceiptTextStyleType.bold,
//   //   // );
//   //   // receiptText.addSpacer(useDashed: true);
//   //   // receiptText.addLeftRightText(
//   //   //   'TOTAL',
//   //   //   'Rp30.000',
//   //   //   leftStyle: ReceiptTextStyleType.normal,
//   //   //   rightStyle: ReceiptTextStyleType.bold,
//   //   // );
//   //   // receiptText.addSpacer(useDashed: true);
//   //   // receiptText.addLeftRightText(
//   //   //   'Payment',
//   //   //   'Cash',
//   //   //   leftStyle: ReceiptTextStyleType.normal,
//   //   //   rightStyle: ReceiptTextStyleType.normal,
//   //   // );
//   //   // receiptText.addSpacer(count: 2);

//   //   await printReceiptText(receiptText);

//   //   /// Example for print QR
//   //   // await _bluePrintPos.printQR('www.google.com', size: 250);

//   //   /// Text after QR
//   //   // final ReceiptSectionText receiptSecondText = ReceiptSectionText();
//   //   // receiptSecondText.addText('Powered by ayeee',
//   //   //     size: ReceiptTextSizeType.small);
//   //   // receiptSecondText.addSpacer();
//   //   // await _bluePrintPos.printReceiptText(receiptSecondText, feedCount: 1);
//   // }

//   // print ticket
//   void _printEscPos(List<int> bytes, Generator generator) async {
//     var connectedTCP = false;
//     if (selectedPrinter == null) return;
//     var bluetoothPrinter = selectedPrinter!;

//     switch (bluetoothPrinter.typePrinter) {
//       case PrinterType.usb:
//         bytes += generator.feed(2);
//         bytes += generator.cut();
//         await printerManager.connect(
//             type: bluetoothPrinter.typePrinter,
//             model: UsbPrinterInput(
//                 name: bluetoothPrinter.deviceName,
//                 productId: bluetoothPrinter.productId,
//                 vendorId: bluetoothPrinter.vendorId));
//         pendingTask = null;
//         break;
//       case PrinterType.bluetooth:
//         bytes += generator.cut();
//         await printerManager.connect(
//             type: bluetoothPrinter.typePrinter,
//             model: BluetoothPrinterInput(
//               name: bluetoothPrinter.deviceName,
//               address: bluetoothPrinter.address!,
//               isBle: bluetoothPrinter.isBle ?? false,
//               // autoConnect: _reconnect
//             ));
//         pendingTask = null;
//         if (Platform.isAndroid) pendingTask = bytes;
//         break;
//       case PrinterType.network:
//         bytes += generator.feed(2);
//         bytes += generator.cut();
//         connectedTCP = await printerManager.connect(
//             type: bluetoothPrinter.typePrinter,
//             model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!));
//         if (!connectedTCP) print(' --- please review your connection ---');
//         break;
//       default:
//     }
//     if (bluetoothPrinter.typePrinter == PrinterType.bluetooth &&
//         Platform.isAndroid) {
//       if (_currentStatus == BTStatus.connected) {
//         printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
//         pendingTask = null;
//       }
//     } else {
//       printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
//     }
//   }

//   // conectar dispositivo
//   _connectDevice() async {
//     _isConnected = false;
//     if (selectedPrinter == null) return;
//     switch (selectedPrinter!.typePrinter) {
//       case PrinterType.usb:
//         await printerManager.connect(
//             type: selectedPrinter!.typePrinter,
//             model: UsbPrinterInput(
//                 name: selectedPrinter!.deviceName,
//                 productId: selectedPrinter!.productId,
//                 vendorId: selectedPrinter!.vendorId));
//         _isConnected = true;
//         break;
//       case PrinterType.bluetooth:
//         await printerManager.connect(
//             type: selectedPrinter!.typePrinter,
//             model: BluetoothPrinterInput(
//               name: selectedPrinter!.deviceName,
//               address: selectedPrinter!.address!,
//               isBle: selectedPrinter!.isBle ?? false,
//               // autoConnect: _reconnect
//             ));
//         break;
//       case PrinterType.network:
//         await printerManager.connect(
//             type: selectedPrinter!.typePrinter,
//             model: TcpPrinterInput(ipAddress: selectedPrinter!.address!));
//         _isConnected = true;
//         break;
//       default:
//     }

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("M JALA"),
//         // automaticallyImplyLeading: false,
//         backgroundColor: Color(0xff0E4473),
//       ),
//       body: Center(
//         child: Container(
//           height: double.infinity,
//           constraints: const BoxConstraints(maxWidth: 400),
//           child: SingleChildScrollView(
//             padding: EdgeInsets.zero,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: selectedPrinter == null || _isConnected
//                               ? null
//                               : () {
//                                   _connectDevice();
//                                 },
//                           child: const Text("Connect",
//                               textAlign: TextAlign.center),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: selectedPrinter == null || !_isConnected
//                               ? null
//                               : () {
//                                   if (selectedPrinter != null)
//                                     printerManager.disconnect(
//                                         type: selectedPrinter!.typePrinter);
//                                   setState(() {
//                                     _isConnected = false;
//                                   });
//                                 },
//                           child: const Text("Disconnect",
//                               textAlign: TextAlign.center),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 DropdownButtonFormField<PrinterType>(
//                   value: defaultPrinterType,
//                   decoration: const InputDecoration(
//                     prefixIcon: Icon(
//                       Icons.print,
//                       size: 24,
//                     ),
//                     labelText: "Select Printer Device",
//                     labelStyle: TextStyle(fontSize: 18.0),
//                     focusedBorder: InputBorder.none,
//                     enabledBorder: InputBorder.none,
//                   ),
//                   items: <DropdownMenuItem<PrinterType>>[
//                     // DropdownMenuItem(child: Text('data')),
//                     if (Platform.isAndroid || Platform.isIOS)
//                       const DropdownMenuItem(
//                         value: PrinterType.bluetooth,
//                         child: Text("bluetooth"),
//                       ),
//                     if (Platform.isAndroid || Platform.isWindows)
//                       const DropdownMenuItem(
//                         value: PrinterType.usb,
//                         child: Text("usb"),
//                       ),
//                     const DropdownMenuItem(
//                       value: PrinterType.network,
//                       child: Text("Wifi"),
//                     ),
//                   ],
//                   onChanged: (PrinterType? value) {
//                     setState(() {
//                       if (value != null) {
//                         setState(() {
//                           defaultPrinterType = value;
//                           selectedPrinter = null;
//                           _isBle = false;
//                           _isConnected = false;
//                           _scan();
//                         });
//                       }
//                     });
//                   },
//                 ),
//                 Visibility(
//                   visible: defaultPrinterType == PrinterType.bluetooth &&
//                       Platform.isAndroid,
//                   child: SwitchListTile.adaptive(
//                     contentPadding:
//                         const EdgeInsets.only(bottom: 20.0, left: 20),
//                     title: const Text(
//                       "This device supports ble (low energy)",
//                       textAlign: TextAlign.start,
//                       style: TextStyle(fontSize: 19.0),
//                     ),
//                     value: _isBle,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         _isBle = value ?? false;
//                         _isConnected = false;
//                         selectedPrinter = null;
//                         _scan();
//                       });
//                     },
//                   ),
//                 ),
//                 // Visibility(
//                 //   visible: defaultPrinterType == PrinterType.bluetooth &&
//                 //       Platform.isAndroid,
//                 //   child: SwitchListTile.adaptive(
//                 //     contentPadding:
//                 //         const EdgeInsets.only(bottom: 20.0, left: 20),
//                 //     title: const Text(
//                 //       "reconnect",
//                 //       textAlign: TextAlign.start,
//                 //       style: TextStyle(fontSize: 19.0),
//                 //     ),
//                 //     value: _reconnect,
//                 //     onChanged: (bool? value) {
//                 //       setState(() {
//                 //         _reconnect = value ?? false;
//                 //       });
//                 //     },
//                 //   ),
//                 // ),
//                 Column(
//                     children: devices
//                         .map(
//                           (device) => ListTile(
//                             title: Text('${device.deviceName}'),
//                             subtitle: Platform.isAndroid &&
//                                     defaultPrinterType == PrinterType.usb
//                                 ? null
//                                 : Visibility(
//                                     visible: !Platform.isWindows,
//                                     child: Text("${device.address}")),
//                             onTap: () {
//                               // do something
//                               selectDevice(device);
//                             },
//                             leading: selectedPrinter != null &&
//                                     ((device.typePrinter == PrinterType.usb &&
//                                                 Platform.isWindows
//                                             ? device.deviceName ==
//                                                 selectedPrinter!.deviceName
//                                             : device.vendorId != null &&
//                                                 selectedPrinter!.vendorId ==
//                                                     device.vendorId) ||
//                                         (device.address != null &&
//                                             selectedPrinter!.address ==
//                                                 device.address))
//                                 ? const Icon(
//                                     Icons.check,
//                                     color: Colors.green,
//                                   )
//                                 : null,
//                             trailing: OutlinedButton(
//                               onPressed: selectedPrinter == null ||
//                                       device.deviceName !=
//                                           selectedPrinter?.deviceName
//                                   ? null
//                                   : () async {
//                                       // **********************************
//                                       await _printReceiveTest();

//                                       // _onPrintReceipt();
//                                       // // printReceiptText();

//                                       // printTicket();
//                                     },
//                               child: const Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 2, horizontal: 20),
//                                 child: Text("Print test ticket",
//                                     textAlign: TextAlign.center),
//                               ),
//                             ),
//                           ),
//                         )
//                         .toList()),
//                 Visibility(
//                   visible: defaultPrinterType == PrinterType.network &&
//                       Platform.isWindows,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 10.0),
//                     child: TextFormField(
//                       controller: _ipController,
//                       keyboardType:
//                           const TextInputType.numberWithOptions(signed: true),
//                       decoration: const InputDecoration(
//                         label: Text("Ip Address"),
//                         prefixIcon: Icon(Icons.wifi, size: 24),
//                       ),
//                       onChanged: setIpAddress,
//                     ),
//                   ),
//                 ),
//                 Visibility(
//                   visible: defaultPrinterType == PrinterType.network &&
//                       Platform.isWindows,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 10.0),
//                     child: TextFormField(
//                       controller: _portController,
//                       keyboardType:
//                           const TextInputType.numberWithOptions(signed: true),
//                       decoration: const InputDecoration(
//                         label: Text("Port"),
//                         prefixIcon: Icon(Icons.numbers_outlined, size: 24),
//                       ),
//                       onChanged: setPort,
//                     ),
//                   ),
//                 ),
//                 Visibility(
//                   visible: defaultPrinterType == PrinterType.network &&
//                       Platform.isWindows,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 10.0),
//                     child: OutlinedButton(
//                       onPressed: () async {
//                         // hitPrintApi();
//                         Future.delayed(
//                           const Duration(seconds: 5),
//                         ).then((value) {
//                           if (_ipController.text.isNotEmpty)
//                             setIpAddress(_ipController.text);
//                           _printReceiveTest();
//                           // printTicket();
//                         });
//                         setState(() {});
//                       },
//                       child: const Padding(
//                         padding:
//                             EdgeInsets.symmetric(vertical: 4, horizontal: 50),
//                         child: Text("Print test ticket",
//                             textAlign: TextAlign.center),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // hitPrintApi() {
//   //   billPrintController.getPrintBillApi(
//   //       url: AppUrls.printBillApi, rrnumber: rrNumber, zone: zoneName);
//   // }
// }

// class BluetoothPrinter {
//   int? id;
//   String? deviceName;
//   String? address;
//   String? port;
//   String? vendorId;
//   String? productId;
//   bool? isBle;

//   PrinterType typePrinter;
//   bool? state;

//   BluetoothPrinter(
//       {this.deviceName,
//       this.address,
//       this.port,
//       this.state,
//       this.vendorId,
//       this.productId,
//       this.typePrinter = PrinterType.bluetooth,
//       this.isBle = false});
// }

// class CollectionStyle {
//   CollectionStyle._();

//   /// Getter for all css style pre-define
//   static String get all {
//     return '''
//       <style>
//           body,
//           p {
//               margin: 0px;
//               padding: 0px;
//               font-family: helvetica; 
//           }
          
//           body {
//               background: #eee;
//               width: 576px;
//               font-size: 1.8em
//           }
          
//           .receipt {
//               max-width: 576px;
//               margin: auto;
//               background: white;
//           }
          
//           .container {
//               padding: 5px 15px;
//           }
          
//           hr {
//               border-top: 2px dashed black;
//           }
          
//           .text-center {
//               text-align: center;
//           }
          
//           .text-left {
//               text-align: left;
//           }
          
//           .text-right {
//               text-align: right;
//           }
          
//           .text-justify {
//               text-align: justify;
//           }
          
//           .right {
//               float: right;
//           }
          
//           .left {
//               float: left;
//           }
          
//           span {
//               color: black;
//               font-family: helvetica;
//           }
          
//           .full-width {
//               width: 100%;
//           }
          
//           .inline-block {
//               display: inline-block;
//           }
          
//           .text-extra-large {
//               font-size: 2.2em;
//           }
          
//           .text-large {
//               font-size: 1.6em;
//           }
          
//           .text-medium {
//               font-size: 1.2em;
//           }
          
//           .text-small {
//               font-size: 0.8em;
//           }
//       </style>
//     ''';
//   }

//   /// To separate style from all css, just create getter the value of style name
//   // static String get textCenter => 'text-center';
//   // static String get textLeft => 'text-left';
//   // static String get textRight => 'text-right';
// }

// //

// class ReceiptSectionText {
//   ReceiptSectionText();

//   String _data = '';

//   /// Build a page from html, [CollectionStyle.all] is defined CSS inside html
//   /// [_data] will collect all generated tag from model [ReceiptText],
//   /// [ReceiptTextLeftRight] and [ReceiptLine]
//   String get content {
//     return '''
// <!DOCTYPE html>
// <html lang="en">
// <head>
//     <meta charset="UTF-8">
//     <meta name="viewport" content="width=device-width, initial-scale=1.0">
//     <title>RECEIPT</title>
// </head>

// ${CollectionStyle.all}

// <body>
//   <div class="receipt">
//     <div class="container">
//       <!-- testing part -->
      
//       $_data
      
//     </div>
//   </div>
// </body>
// </html>
//     ''';
//   }

//   /// Handler tag of text (p or b) and put inside body html
//   /// This will generate single line text left, center or right
//   /// [text] value of text will print
//   /// [alignment] to set alignment of text
//   /// [style] define normal or bold
//   /// [size] to set size of text small, medium, large or extra large
//   void addText(String text,
//       {Alignment alignment = Alignment.center,
//       TextStyle weight = const TextStyle(fontWeight: FontWeight.normal),
//       TextStyle size = const TextStyle(fontSize: 30)}) {
//     final ReceiptText receiptText = ReceiptText(
//       text,
//       // textStyle: ReceiptTextStyle(
//       //   type: weight,
//       //   size: size,
//       // ),
//       alignment: alignment,
//     );
//     _data += receiptText.html;
//   }

//   // void addImage(
//   //   String base64, {
//   //   int width = 120,
//   //   Alignment alignment = Alignment.center,
//   // }) {
//   //   final ReceiptImage image = ReceiptImage(
//   //     base64,
//   //     width: width,
//   //     alignment: alignment,
//   //   );
//   //   _data += image.html;
//   // }
// }

// ///
// //
// class ReceiptText {
//   ReceiptText(
//     this.text, {
//     // this.textStyle = const ReceiptTextStyle(
//     //   type: ReceiptTextStyleType.normal,
//     //   size: ReceiptTextSizeType.medium,
//     // ),
//     this.alignment = Alignment.center,
//   });

//   final String text;
//   final TextStyle textStyle = const TextStyle(fontSize: 30);
//   final Alignment alignment;

//   String get html => '''
//     <div class="${Alignment.center} $textStyle">
//       <$textStyle>$text</$textStyle>
//     </div>
//     ''';
// }
