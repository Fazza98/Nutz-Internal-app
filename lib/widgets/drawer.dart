import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jci/widgets/titles.dart';

var lightBlue = '24B9EC';
var darkBlue = '23346B';
double _svgWidth = 35;

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.8,
      child: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  DrawerHeader(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        height: 40,
                        width: 40,
                        child: SvgPicture.asset(
                          "assets/images/logo.svg",
                        ),
                      ),
                    ),
                  ),
                  // events
                  ListTile(
                    title: _listTile(titles.event),
                    minLeadingWidth: 1,
                    leading: _events,
                    onTap: () {
                      Get.back();
                      Get.toNamed("/events");
                    },
                  ),

                  // member
                  ListTile(
                    title: _listTile(titles.members),
                    minLeadingWidth: 0,
                    horizontalTitleGap: 10,
                    leading: _members,
                    onTap: () {
                      Get.back();
                      Get.toNamed("/members", arguments: ['mem']);
                    },
                  ),
                  // birthday
                  ListTile(
                    title: _listTile(titles.birthday),
                    minLeadingWidth: 1,
                    horizontalTitleGap: 10,
                    leading: _birthday,
                    onTap: () {
                      Get.back();
                      Get.toNamed("/birthday");
                    },
                  ),
                  // blood donors
                  ListTile(
                    title: _listTile(titles.blood_donors),
                    minLeadingWidth: 1,
                    horizontalTitleGap: 10,
                    leading: _blood,
                    onTap: () {
                      Get.back();
                      Get.toNamed("/blood");
                    },
                  ),

                  // roll of honour
                  ListTile(
                    title: _listTile(titles.roh),
                    minLeadingWidth: 1,
                    leading: _roll_of_honour,
                    onTap: () {
                      Get.back();
                      Get.toNamed("/roh");
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.08,
            )
          ],
        ),
      ),
    );
  }

  final Widget _birthday = SvgPicture.asset(
    'assets/icons/birthday_colored.svg',
    // width: 20,
    height: 40,
  );

  final Widget _blood = SvgPicture.asset(
    'assets/icons/blood_colored.svg',
    // width: 20,
    height: 40,
  );

  final Widget _members = SvgPicture.asset(
    'assets/icons/members_colored.svg',
    // width: 20,
    height: 40,
  );

  final Widget _dashboard = SvgPicture.asset(
    'assets/icons/dashboard.svg',
    width: _svgWidth,
  );

  final Widget _roll_of_honour = SvgPicture.asset(
    'assets/icons/roll_of_honour_colored.svg',
    width: _svgWidth,
  );

  final Widget _events = SvgPicture.asset(
    "assets/icons/event_colored.svg",
    width: _svgWidth,
  );

  Widget _listTile(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontFamily: 'pop-med'),
    );
  }
}
