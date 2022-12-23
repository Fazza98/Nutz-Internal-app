import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/home/SponsorModel.dart';
import 'package:jci/services/homeService.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/drawer.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:get/get.dart';
import 'package:jci/widgets/titles.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/sponser_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var controller = Get.put(sponsorController());

  var loadingFlag = 0;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? _loading() : _home(context);
  }

  Scaffold _home(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(titles.home).initAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _space(5),
            // event images
            FutureBuilder(
              future: HomeService.getPastEventImages(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null &&
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      height: 200,
                      child: Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black))));
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data == null) {
                  return Container();
                } else {
                  print(snapshot.data);
                  return snapshot.data.length == 0
                      ? Container()
                      : CarouselSlider.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              GestureDetector(
                            onTap: () => Get.toNamed("/imgView",
                                arguments: [snapshot.data[itemIndex]]),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: HexColor("1A000000"),
                                    blurRadius: 4,
                                    offset: Offset(0, 0))
                              ]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  snapshot.data[itemIndex],
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  errorBuilder: (_, obj, err) => Container(),
                                ),
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                            height: 200,
                            enlargeCenterPage: true,
                            initialPage: 0,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                          ),
                        );
                }
              },
            ),
            _space(10),
            // Event button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: HexColor("1A000000"),
                        blurRadius: 4,
                        offset: Offset(0, 0),
                      ),
                      BoxShadow(
                        color: HexColor("ffffff"),
                        blurRadius: 1,
                        offset: Offset(0, 0),
                      ),
                    ]),
                child: ListTile(
                  onTap: () {
                    Get.toNamed("/events");
                  },
                  tileColor: Colors.white,
                  leading: SvgPicture.asset(
                    "assets/icons/event_colored.svg",
                    width: 28,
                    height: 35,
                  ),
                  title: Center(
                    child: Text(
                      "Events",
                      style: TextStyle(
                        fontFamily: "pop-semibold",
                        fontSize: 18,
                      ),
                    ),
                  ),
                  trailing: SvgPicture.asset(
                    "assets/icons/next.svg",
                    width: 13,
                  ),
                ),
              ),
            ),
            _space(30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // members
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        Get.toNamed("/members", arguments: ['mem']);
                      },
                      child: Container(
                        child: Column(
                          children: [
                            SvgPicture.asset("assets/icons/members_colored.svg",
                                width: 35, height: 55),
                            _space(6),
                            _title("Members")
                          ],
                        ),
                      ),
                    ),
                  ),
                  // birthday
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.toNamed("/birthday"),
                      child: Container(
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/birthday_colored.svg",
                              width: 35,
                              height: 50,
                            ),
                            _space(10),
                            _title("Birthday")
                          ],
                        ),
                      ),
                    ),
                  ),
                  // blood donors
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.toNamed("/blood"),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/blood_colored.svg",
                              width: 35,
                              height: 50,
                            ),
                            _space(10),
                            _title("Blood Donors")
                          ],
                        ),
                      ),
                    ),
                  ),

                  // about
                  // Expanded(
                  //   child: InkWell(
                  //     onTap: () => Get.toNamed("/about"),
                  //     child: Container(
                  //       child: Column(
                  //         children: [
                  //           SvgPicture.asset(
                  //             "assets/icons/about_colored.svg",
                  //             width: 30,
                  //             height: 30,
                  //           ),
                  //           _space(10),
                  //           _title("About")
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // // board members
                  // Expanded(
                  //   child: InkWell(
                  //     onTap: () {
                  //       Get.back();
                  //       Get.toNamed("/members", arguments: ["bm"]);
                  //     },
                  //     child: Container(
                  //       child: Column(
                  //         children: [
                  //           SvgPicture.asset(
                  //             "assets/icons/board_members.svg",
                  //             width: 30,
                  //             height: 30,
                  //           ),
                  //           SizedBox(
                  //             height: 10,
                  //           ),
                  //           _title("Board Members")
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            _space(60),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 80,
              ),
              child: Row(
                children: [
                  // roh
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.toNamed("/roh"),
                      child: Container(
                        // margin: EdgeInsets.fromLTRB(75, 0, 15, 10),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/roll_of_honour_colored.svg",
                              width: 35,
                              height: 40,
                            ),
                            _space(10),
                            _title("Guidelines")
                          ],
                        ),
                      ),
                    ),
                  ),

                  // past president
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        await launch(
                          'https://nutz.in',
                          forceWebView: true,
                          enableJavaScript: true,
                        );
                        // Get.back();
                        // Get.toNamed("/dashboard");
                      },
                      child: Container(
                        // margin: EdgeInsets.fromLTRB(15, 0, 75, 10),
                        // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/dashboard.svg",
                              width: 35,
                              height: 40,
                            ),
                            _space(10),
                            _title("Portfolio")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _space(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [_dummy(), _dummy()],
              ),
            ),
            _space(15),
            // Visibility(
            //     visible: controller.getMainSponsorVisiblity(),
            //     child: SponsorData.sponserTitle("${JciString.powered_by}")),
            // _space(10),
            // SponsorData.mainSponsor(context),
            // _space(10),
            // Visibility(
            //     visible: controller.getVisible(),
            //     child: SponsorData.sponserTitle('${JciString.co_powered_by}')),
            // SponsorData.otherSponsor(context),
            // _space(20)
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      "assets/images/logo.svg",
                      width: 65,
                      height: 80,
                    ))),
          ],
        ),
      ),
      drawer: NavigationDrawer(),
    );
  }

  Widget _title(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 14, fontFamily: "pop-med"),
      textAlign: TextAlign.center,
    );
  }

  Widget _space(double h) {
    return SizedBox(height: h);
  }

  Widget _dummy() => Expanded(child: Text(""));
}

Scaffold _loading() {
  return Scaffold(
    appBar: CustAppBar(titles.home).loadingAppBar(),
    body: Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
    ),
  );
}
