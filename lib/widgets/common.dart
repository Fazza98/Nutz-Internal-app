import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Utils {
  static Color darkBlue = HexColor("23346B");

  // static ImageNotFound() {
  //   return Container(
  //     child: Column(
  //       children: [
  //         Icon(
  //           Icons.warning,
  //           color: darkBlue,
  //         ),
  //         Container(
  //             margin: EdgeInsets.only(top: 10),
  //             child: Text(
  //               'Image Not Found',
  //               style: TextStyle(fontFamily: "pop-med"),
  //             ))
  //       ],
  //     ),
  //   );
  // }

  static ImageNotFound() {
    return Container(
      child: Icon(
        Icons.photo_camera_outlined,
      ),
    );
  }
}
