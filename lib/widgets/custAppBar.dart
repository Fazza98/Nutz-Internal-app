import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustAppBar {
  String appBarTitle;
  var lightBlue = '24B9EC';
  var darkBlue = '23346B';

  CustAppBar(this.appBarTitle);

  AppBar initAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            appBarTitle,
            style: TextStyle(
                fontSize: 18, fontFamily: "pop-semibold", color: Colors.black),
          ),
          Row(
            children: [
              Text(
                'nutz   ',
                style: TextStyle(
                    fontSize: 25, fontFamily: "ubuntu", color: Colors.black),
              ),
              // Text(
              //   'making sense',
              //   style: TextStyle(
              //       fontSize: 10,
              //       fontFamily: "pop-semibold",
              //       color: Colors.black),
              // ),
              SizedBox(width: 10)
            ],
          )
        ],
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      titleSpacing: 0,
    );
  }

  AppBar loadingAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            appBarTitle,
            style: TextStyle(
                fontSize: 18, fontFamily: "pop-semibold", color: Colors.black),
          ),
          Row(
              // children: [
              //   Text(
              //     'JCI ',
              //     style: TextStyle(
              //         fontSize: 18,
              //         fontFamily: "pop-semibold",
              //         color: HexColor(lightBlue)),
              //   ),
              //   Text(
              //     'Green City',
              //     style: TextStyle(
              //         fontSize: 18,
              //         fontFamily: "pop-semibold",
              //         color: HexColor(darkBlue)),
              //   ),
              //   SizedBox(width: 10)
              // ],
              )
        ],
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
    );
  }
}
