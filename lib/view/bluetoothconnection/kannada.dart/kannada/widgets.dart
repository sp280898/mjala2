// import 'package:flutter/material.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';

// class BluetoothPrinterPage extends StatefulWidget {
//   @override
//   _BluetoothPrinterPageState createState() => _BluetoothPrinterPageState();
// }

// class _BluetoothPrinterPageState extends State<BluetoothPrinterPage> {
//   BlueThermalPrinter _printer = BlueThermalPrinter.instance;
//   BluetoothDevice? _selectedPrinter;
//   List<BluetoothDevice> _devices = [];

//   @override
//   void initState() {
//     super.initState();
//     _initBluetooth();
//   }

//   Future<void> _initBluetooth() async {
//     try {
//       bool? isBluetoothEnabled = await _printer.isOn;
//       if (!isBluetoothEnabled!) {
//         await _printer.openSettings;
//       }
//     } catch (e) {
//       print('Error initializing Bluetooth: $e');
//     }
//   }

//   void _connectToDevice(BluetoothDevice device) async {
//     try {
//       bool? isConnected = await _printer.isConnected;
//       if (isConnected!) {
//         await _printer.disconnect;
//       }

//       await _printer.connect(device);
//       setState(() {
//         _selectedPrinter = device;
//       });
//     } catch (e) {
//       print('Error connecting to the device: $e');
//     }
//   }

//   void _disconnect() async {
//     try {
//       await _printer.disconnect;
//       setState(() {
//         _selectedPrinter = null;
//       });
//     } catch (e) {
//       print('Error disconnecting from the device: $e');
//     }
//   }

//   void _discoverDevices() async {
//     try {
//       List<BluetoothDevice> devices = await _printer.getBondedDevices;
//       setState(() {
//         _devices = devices;
//       });
//     } catch (e) {
//       print('Error discovering devices: $e');
//     }
//   }

//   void printText(String text) async {
//     if (_selectedPrinter == null) {
//       print('Device not selected.');
//       return;
//     }

//     final profile = await CapabilityProfile.load();
//     final printer = await _printer.(
//       _selectedPrinter!,
//       profile,
//     );

//     final PosPrintResult result = await printer.connect(timeout: Duration(seconds: 10));

//     if (result != PosPrintResult.success) {
//       print('Error connecting to the printer: $result');
//       return;
//     }

//     printer.text(text, styles: PosStyles(align: PosAlign.left, bold: true));

//     final PosPrintResult printResult = await printer.cut();
//     if (printResult == PosPrintResult.success) {
//       print('Text sent to the printer successfully.');
//     } else {
//       print('Error printing: $printResult');
//     }

//     printer.disconnect();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Printer Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _discoverDevices,
//               child: Text('Discover Devices'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _disconnect,
//               child: Text('Disconnect from Printer'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 printText('Hello, this is a test print!');
//               },
//               child: Text('Print Text'),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _devices.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(_devices[index].name),
//                     subtitle: Text(_devices[index].address),
//                     onTap: () {
//                       // Connect and print on the selected device
//                       _connectToDevice(_devices[index]);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:async';

// import 'package:telpo_flutter_sdk/telpo_flutter_sdk.dart';

// const telpoColor = Color(0xff005AFF);

// // void main() {
// //   runApp(const App());
// // }

// class App1 extends StatelessWidget {
//   const App1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool _connected = false;
//   String _telpoStatus = 'Not initialized';
//   bool _isLoading = false;

//   final _telpoFlutterChannel = TelpoFlutterChannel();

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> _connect() async {
//     // Platform calls are catched on plugin-side. No need to use try-catch here,
//     // as connect() method returns non-nullable boolean.

//     final bool connected = await _telpoFlutterChannel.connect();

//     setState(() {
//       _connected = connected;

//       _telpoStatus = _connected ? 'Connected' : 'Telpo not supported';
//     });
//   }

//   Future<void> _checkStatus() async {
//     String telpoStatus;

//     final TelpoStatus status = await _telpoFlutterChannel.checkStatus();
//     telpoStatus = status.name;

//     setState(() => _telpoStatus = telpoStatus);
//   }

//   Future<void> _printData() async {
//     setState(() => _isLoading = true);

//     // Creating an [TelpoPrintSheet] instance.
//     final sheet = TelpoPrintSheet();

//     // Creating a text element
//     final textData = PrintData.text(
//       'TelpoFlutterSdk',
//       alignment: PrintAlignment.center,
//       fontSize: PrintedFontSize.size34,
//     );

//     // Creating 8-line empty space element.
//     final spacing = PrintData.space(line: 8);

//     // Inserting previously created text element to the sheet.
//     sheet.addElement(textData);

//     // Inserting previously created spacing element to the sheet.
//     sheet.addElement(spacing);

//     final PrintResult result = await _telpoFlutterChannel.print(sheet);

//     setState(() {
//       _telpoStatus = result.name;
//       _isLoading = false;
//     });
//   }

//   @override
//   void setState(VoidCallback fn) {
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//     if (mounted) {
//       super.setState(fn);
//     }
//   }

//   @override
//   void dispose() {
//     // Disconnecting from Telpo.
//     _telpoFlutterChannel.disconnect();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//         backgroundColor: const Color(0xffFF8D49),
//         title: const Text('Telpo plugin example'),
//         actions: [
//           if (_isLoading)
//             Container(
//               alignment: Alignment.center,
//               padding: const EdgeInsets.only(right: 16.0),
//               child: const CircularProgressIndicator(
//                 color: Colors.white,
//               ),
//             )
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Telpo status: $_telpoStatus',
//               style: const TextStyle(fontSize: 16.0),
//             ),
//             const SizedBox(height: 32.0),
//             CupertinoButton(
//               color: telpoColor,
//               onPressed: _isLoading ? null : _connect,
//               child: const Text('Initialize'),
//             ),
//             if (_connected) ...[
//               const SizedBox(height: 24.0),
//               CupertinoButton(
//                 color: telpoColor,
//                 onPressed: _isLoading ? null : _checkStatus,
//                 child: const Text(
//                   'Check status',
//                 ),
//               ),
//               if ([PrintResult.success.name, TelpoStatus.ok.name]
//                   .contains(_telpoStatus)) ...[
//                 const SizedBox(height: 24.0),
//                 CupertinoButton(
//                   color: telpoColor,
//                   onPressed: _isLoading ? null : _printData,
//                   child: Text(
//                     _isLoading ? 'Printing' : 'Print',
//                   ),
//                 ),
//               ]
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

//
import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:mjala/screens/bluetoothconnection/kannada.dart/kannada/src/enums.dart';
// import 'package:mjala/screens/bluetoothconnection/kannada.dart/kannada/src/portInfo.dart';
// import 'package:mjala/screens/bluetoothconnection/kannada.dart/kannada/src/star_prnt.dart';
// import 'package:flutter_star_prnt/flutter_star_prnt.dart';
import 'dart:ui' as ui;

import 'package:mjala/view/bluetoothconnection/kannada.dart/kannada/src/utilities.dart';

import 'flutter_star_prnt.dart';

// void main() => runApp(MyApp());

class MyApp1 extends StatefulWidget {
  const MyApp1({super.key});

  @override
  State<MyApp1> createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
  GlobalKey _globalKey = GlobalKey();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary? boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      print(e);
      return Uint8List(0);
    }
  }

  String emulationFor(String modelName) {
    String emulation = 'StarGraphic';
    if (modelName != '') {
      final em = StarMicronicsUtilities.detectEmulation(modelName: modelName);
      emulation = em!.emulation!;
    }
    return emulation;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Column(
          children: <Widget>[
            TextButton(
              onPressed: () async {
                List list = await StarPrnt.portDiscovery(StarPortType.All);
                print(list);
                list.forEach((port) async {
                  print(port.portName);
                  if (port.portName?.isNotEmpty != null) {
                    print(await StarPrnt.getStatus(
                      portName: port.portName!,
                      emulation: emulationFor(port.modelName!),
                    ));

                    PrintCommands commands = PrintCommands();
                    String raster = "        Star Clothing Boutique\n"
                            "             123 Star Road\n" +
                        "           City, State 12345\n" +
                        "\n" +
                        "Date:MM/DD/YYYY          Time:HH:MM PM\n" +
                        "--------------------------------------\n" +
                        "SALE\n" +
                        "SKU            Description       Total\n" +
                        "300678566      PLAIN T-SHIRT     10.99\n" +
                        "300692003      BLACK DENIM       29.99\n" +
                        "300651148      BLUE DENIM        29.99\n" +
                        "300642980      STRIPED DRESS     49.99\n" +
                        "30063847       BLACK BOOTS       35.99\n" +
                        "\n" +
                        "Subtotal                        156.95\n" +
                        "Tax                               0.00\n" +
                        "--------------------------------------\n" +
                        "Total                           156.95\n" +
                        "--------------------------------------\n" +
                        "\n" +
                        "Charge\n" +
                        "156.95\n" +
                        "Visa XXXX-XXXX-XXXX-0123\n" +
                        "Refunds and Exchanges\n" +
                        "Within 30 days with receipt\n" +
                        "And tags attached\n";
                    commands.appendBitmapText(text: raster);
                    print(await StarPrnt.sendCommands(
                        portName: port.portName!,
                        emulation: emulationFor(port.modelName!),
                        printCommands: commands));
                  }
                });
              },
              child: Text('Print from text'),
            ),
            TextButton(
              onPressed: () async {
                //FilePickerResult file = await FilePicker.platform.pickFiles();
                List<PortInfo> list =
                    await StarPrnt.portDiscovery(StarPortType.All);
                print(list);
                list.forEach((port) async {
                  print(port.portName);
                  if (port.portName?.isNotEmpty != null) {
                    print(await StarPrnt.getStatus(
                      portName: port.portName!,
                      emulation: emulationFor(port.modelName!),
                    ));

                    PrintCommands commands = PrintCommands();
                    commands.appendBitmap(
                        path:
                            'https://c8.alamy.com/comp/MPCNP1/camera-logo-design-photograph-logo-vector-icons-MPCNP1.jpg');
                    print(await StarPrnt.sendCommands(
                        portName: port.portName!,
                        emulation: emulationFor(port.modelName!),
                        printCommands: commands));
                  }
                });
                setState(() {
                  isLoading = false;
                });
              },
              child: Text('Print from url'),
            ),
            SizedBox(
              width: 576, // 3'' only
              child: RepaintBoundary(
                key: _globalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('This is a text to print as image , for 3\''),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final img = await _capturePng();
                setState(() {
                  isLoading = true;
                });
                //FilePickerResult file = await FilePicker.platform.pickFiles();
                List<PortInfo> list =
                    await StarPrnt.portDiscovery(StarPortType.All);
                print(list);

                list.forEach((port) async {
                  print(port.portName);
                  if (port.portName!.isNotEmpty) {
                    print(await StarPrnt.getStatus(
                      portName: port.portName!,
                      emulation: emulationFor(port.modelName!),
                    ));

                    PrintCommands commands = PrintCommands();
                    commands.appendBitmapByte(
                      byteData: img,
                      diffusion: true,
                      bothScale: true,
                      alignment: StarAlignmentPosition.Left,
                    );
                    print(await StarPrnt.sendCommands(
                        portName: port.portName!,
                        emulation: emulationFor(port.modelName!),
                        printCommands: commands));
                  }
                });
                setState(() {
                  isLoading = false;
                });
              },
              child: Text('Print from genrated image'),
            ),
          ],
        ),
      ),
    );
  }
}
