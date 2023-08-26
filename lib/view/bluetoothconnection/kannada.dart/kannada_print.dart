// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'dart:convert';
// import 'dart:typed_data';

// class BluetoothPrinterPage extends StatefulWidget {
//   @override
//   _BluetoothPrinterPageState createState() => _BluetoothPrinterPageState();
// }

// class _BluetoothPrinterPageState extends State<BluetoothPrinterPage> {
//   BluetoothConnection? _bluetoothConnection;
//   bool _isConnected = false;
//   List<BluetoothDevice> _devices = [];

//   @override
//   void initState() {
//     super.initState();
//     _initBluetooth();
//   }

//   Future<void> _initBluetooth() async {
//     try {
//       bool? isEnabled = await FlutterBluetoothSerial.instance.isEnabled;
//       if (!isEnabled!) {
//         await FlutterBluetoothSerial.instance.requestEnable();
//       }
//     } catch (e) {
//       print('Error initializing Bluetooth: $e');
//     }
//   }

//   void _connectToDevice(BluetoothDevice device) async {
//     try {
//       BluetoothConnection connection =
//           await BluetoothConnection.toAddress(device.address);
//       if (connection.isConnected) {
//         setState(() {
//           _bluetoothConnection = connection;
//           _isConnected = true;
//         });
//       } else {
//         print('Failed to connect to the device.');
//       }
//     } catch (e) {
//       print('Error connecting to the device: $e');
//     }
//   }

//   void _disconnect() async {
//     if (_bluetoothConnection != null && _bluetoothConnection!.isConnected) {
//       await _bluetoothConnection!.close();
//       setState(() {
//         _isConnected = false;
//       });
//     }
//   }

//   void printText(String text) {
//     if (_bluetoothConnection == null || !_bluetoothConnection!.isConnected) {
//       print('Device not connected.');
//       return;
//     }

//     // Convert the text to bytes using UTF-8 encoding
//     Uint8List bytes = Uint8List.fromList(utf8.encode(text));

//     try {
//       // _bluetoothConnection!.add(bytes);
//       print('Text sent to the printer successfully.');
//     } catch (e) {
//       print('Error sending text to the printer: $e');
//     }
//   }

//   Future<void> _discoverDevices() async {
//     List<BluetoothDevice> devices = [];
//     try {
//       devices = await FlutterBluetoothSerial.instance.getBondedDevices();
//     } catch (e) {
//       print('Error getting bonded devices: $e');
//     }

//     setState(() {
//       _devices = devices;
//     });
//   }

//   @override
//   void dispose() {
//     _disconnect();
//     super.dispose();
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
//                     title: Text(_devices[index].name!),
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
