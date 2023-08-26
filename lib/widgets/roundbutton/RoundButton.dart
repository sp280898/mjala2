// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  String? text;
  double? height;
  double? width;
  Decoration? decoration;

  Color color;
  VoidCallback onTap;

  bool isLoading;
  RoundButton({
    Key? key,
    required this.text,
    this.height = 30,
    this.width = 60,
    this.decoration,
    this.color = Colors.purple,
    required this.onTap,
    this.isLoading = false,
  }) : super(key: key);

  // static bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.green,
          ))
        : InkWell(
            onTap: onTap,
            child: Container(
              height: height,
              width: width,
              // color: color,
              decoration: decoration,
              child: Center(
                child: Text(
                  text!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
  }
}
