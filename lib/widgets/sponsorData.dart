import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/services/sponser_service.dart';
import 'package:get/get.dart';
import 'package:jci/widgets/common.dart';

class SponsorData {
  static var visibleController = Get.put(sponsorController());

  static Widget sponserTitle(String title) {
    return Text(
      "$title",
      style: TextStyle(
        color: Utils.darkBlue,
        fontFamily: "pop-med",
        fontSize: 20,
      ),
    );
  }

  static Widget otherSponsor(BuildContext context) {
    return FutureBuilder(
        future: SponsorService.getOurSponserData(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError || snapshot.data.length == 0) {
            visibleController.setVisible(false);
            return Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: HexColor("ffffff"),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "",
                style: TextStyle(fontSize: 14, fontFamily: "pop-med"),
              ),
            );
          } else {
            visibleController.setVisible(true);
            return CarouselSlider.builder(
              itemCount: snapshot.data.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) =>
                      GestureDetector(
                onTap: () {
                  _viewButton('our_sponser', '${snapshot.data[itemIndex].id}');
                },
                child: Container(
                  height: 250,
                  width: 250,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: HexColor("ffffff"),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(
                    '${snapshot.data[itemIndex].logo}',
                    // height: 40,
                    // width: 200,
                    errorBuilder: (ctx, obj, err) {
                      return Utils.ImageNotFound();
                    },
                  ),
                ),
              ),
              options: CarouselOptions(
                height: 250,
                initialPage: 0,
              ),
            );
          }
        });
  }

  static Widget mainSponsor(BuildContext context) {
    return FutureBuilder(
        future: SponsorService.getSponserData(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.data == null &&
              snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError ||
              (snapshot.data == null &&
                  snapshot.connectionState == ConnectionState.done) ||
              snapshot.data.length == 0) {
            visibleController.setMainSponsorVisible(false);
            return Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: HexColor("ffffff"),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "",
                style: TextStyle(fontSize: 14, fontFamily: "pop-med"),
              ),
            );
          } else {
            visibleController.setMainSponsorVisible(true);
            return GestureDetector(
              onTap: () =>
                  {_viewButton('main_sponser', '${snapshot.data[0].id}')},
              child: Container(
                width: 150,
                height: 150,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: HexColor("ffffff"),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                  '${snapshot.data[0].logo}',
                  // height: 40,
                  // width: 200,
                  errorBuilder: (_, obj, err) {
                    return Utils.ImageNotFound();
                  },
                ),
              ),
            );
          }
        });
  }
}

Widget _space(double h) {
  return SizedBox(height: h);
}

_viewButton(var sponser, var id) {
  Get.toNamed('/sponsor', arguments: [sponser, id]);
}
