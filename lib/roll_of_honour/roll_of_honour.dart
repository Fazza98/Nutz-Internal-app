import 'package:flutter/material.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';
import 'package:jci/widgets/titles.dart';

class RollOfHonour extends StatelessWidget {


  var _count = (DateTime.now().year - 1985) + 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(titles.roh).initAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (ctx, idx) {
              return _gridCard(ctx, DateTime.now().year - idx);
            },
            itemCount: _count,
          ),
        ),
      ),
    );
  }

  _gridCard(BuildContext context, var year) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/roh_details', arguments: [year]);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: HexColor('1A000000'),
              blurRadius: 10,
              offset: Offset(0, 0)),
          BoxShadow(
              color: HexColor('ffffff'), blurRadius: 1, offset: Offset(0, 0)),
        ]),
        child: Center(
          child: Text(
            "$year",
            style: TextStyle(
              fontFamily: 'pop-med',
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
