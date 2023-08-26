import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mjala/view/auth/binding/login_binding.dart';
import 'package:mjala/view/auth/loginpage.dart';
import 'package:mjala/view/billdetails/billdetails.dart';
import 'package:mjala/view/billnotgenerate/billnotgenerate.dart';
import 'package:mjala/view/home/homepage.dart';
import 'package:mjala/view/splashscreen/splashpage.dart';
import 'http/http_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MJALA',
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashScreenPage(),
        ),
        GetPage(
            name: '/login',
            page: () => const LoginPage(),
            binding: LoginBinding()),
        // GetPage(
        //   name: '/configuration',
        //   page: () => const ConfigurationPage(),
        // ),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
        ),

        GetPage(
          name: '/billdetails',
          page: () => const BillDetailsPage(),
        ),
        GetPage(
          name: '/billnotgenerate',
          page: () => BillNotGeneratePage(),
        ),
        // GetPage(
        //   name: '/bluetoothconnection',
        //   page: () => const BluetoothConnectionPage(),
        // ),
      ],
      initialRoute: '/',
    );
  }
}
