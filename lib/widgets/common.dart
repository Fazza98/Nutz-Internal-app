import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Utils {
  static Color darkBlue = HexColor("23346B");



  static ImageNotFound() {
    return Container(
      child: Icon(
        Icons.photo_camera_outlined,
      ),
    );
  }
}
