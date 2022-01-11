import 'dart:ffi';

import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/font_family.dart';
import 'package:flutter/material.dart';

class BasicFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final Color fillColor;
  final Color textColor;
  final double width;

  const BasicFilledButton({Key? key, required this.text, required this.callback,
    required this.fillColor, required this.textColor, this.width = 248.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      child: Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: textColor,
            fontFamily: FontFamily.quickSand,
            fontWeight: FontWeight.w700,
            fontSize: 16),
      ),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(fillColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)
              )
          ),
          fixedSize: MaterialStateProperty.all<Size>(Size(width, 54))
      ),
    );
  }
}

class EmptyButtonWithBorder extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const EmptyButtonWithBorder({Key? key, required this.text, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      child: Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontFamily: FontFamily.quickSand,
            fontSize: 14),
      ),
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)))),
    );
  }
}
