import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/services/eventService.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  var visibleController = Get.put(sponsorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(titles.event).initAppBar(),
      body: SafeArea(
        child: FutureBuilder(
            future: eventService.getEventsData(),
            builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Lottie.asset("assets/lottie/no_data.json"),
                );
              } else {
                if (snapshot.data == null &&
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return snapshot.data.length == 0
                      ? Center(
                          child: Lottie.asset("assets/lottie/no_data.json",
                              height: Get.height * 0.3),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (ctx, index) {
                            if (index == snapshot.data.length - 1) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed("/eventsdetails", arguments: [
                                        '${snapshot.data[index].id}'
                                      ]);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: 9, left: 9, right: 9),
                                      padding: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: HexColor('1A000000'),
                                              blurRadius: 4,
                                              offset: Offset(0, 0),
                                            ),
                                            BoxShadow(
                                              color: HexColor('ffffff'),
                                              blurRadius: 1,
                                              offset: Offset(0, 0),
                                            )
                                          ]),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                snapshot.data[index].image,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              )),
                                          _space(10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data[index].title,
                                                  style: TextStyle(
                                                    fontFamily: "pop-semibold",
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    _custTile(
                                                        "calendar_colored.svg",
                                                        snapshot
                                                            .data[index].date),
                                                    _custTile(
                                                        "clock_colored.svg",
                                                        snapshot
                                                            .data[index].time),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                _custTile(
                                                    "location.svg",
                                                    snapshot
                                                        .data[index].location),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  _spaceHeight(20),
                                  Visibility(
                                    visible: visibleController
                                        .getMainSponsorVisiblity(),
                                    child: SponsorData.sponserTitle(
                                        "${JciString.powered_by}"),
                                  ),
                                  _space(10),
                                  SponsorData.mainSponsor(context),
                                  _space(10),
                                  Visibility(
                                    visible: visibleController.getVisible(),
                                    child: SponsorData.sponserTitle(
                                        '${JciString.co_powered_by}'),
                                  ),
                                  SponsorData.otherSponsor(context),
                                  _space(20)
                                ],
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed("/eventsdetails", arguments: [
                                    '${snapshot.data[index].id}'
                                  ]);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 9, left: 9, right: 9),
                                  padding: EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: HexColor('1A000000'),
                                          blurRadius: 4,
                                          offset: Offset(0, 0),
                                        ),
                                        BoxShadow(
                                          color: HexColor('ffffff'),
                                          blurRadius: 1,
                                          offset: Offset(0, 0),
                                        )
                                      ]),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            snapshot.data[index].image,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, obj, err) {
                                              return Container();
                                            },
                                          )),
                                      _space(10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data[index].title,
                                              style: TextStyle(
                                                fontFamily: "pop-semibold",
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _custTile(
                                                    "calendar_colored.svg",
                                                    snapshot.data[index].date),
                                                _custTile("clock_colored.svg",
                                                    snapshot.data[index].time),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            _custTile("location.svg",
                                                snapshot.data[index].location),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                }
              }
            }),
      ),
    );
  }

  Widget _space(double w) {
    return SizedBox(width: w);
  }

  Widget _custTile(var icon, var title) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/${icon}",
          width: 18,
        ),
        _space(5),
        Text(
          caps(title),
          style: TextStyle(
            fontFamily: "pop-med",
          ),
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _spaceHeight(double h) {
    return SizedBox(height: h);
  }
}
