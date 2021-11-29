import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jci/controllers/eventDetailsController.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';
import 'package:lottie/lottie.dart';

class EventsDetails extends StatefulWidget {
  @override
  _EventsDetailsState createState() => _EventsDetailsState();
}

class _EventsDetailsState extends State<EventsDetails> {
  String u = dotenv.get("URL");
  List<String> ID = Get.arguments;

  var eventController = Get.put(eventDetailController());
  var visibleController = Get.put(sponsorController());

  Future<List<String>> _getEventImageData() async {
    Uri url = Uri.parse('$u/member/event_image');
    var _img = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': ID[0]}));
    var _responseData = json.decode(_img.body);
    List<String> _imgList = [];

    for (var _i in _responseData['response']['data']['info']) {
      _imgList.add(_i['event_image']);
    }
    return _imgList;
  }

  Future<List<EventDetailsModel>> _getEventDetails() async {
    Uri url = Uri.parse('$u/member/event');
    var _response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': ID[0]}));

    var _responseData = json.decode(_response.body);
    List<EventDetailsModel> details = [];
    var _data = _responseData['response']['data']['info'];
    EventDetailsModel _detailsModel = EventDetailsModel(
        image: _data['event_image'],
        title: _data['event_name'],
        time: _data['event_time'],
        date: _data['event_date'],
        location: _data['event_location'],
        desc: _data['event_desc']);
    details.add(_detailsModel);
    return details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(titles.eventDetails).initAppBar(),
      body: SafeArea(
        child: FutureBuilder(
          future: _getEventDetails(),
          builder: (BuildContext ctx,
              AsyncSnapshot<List<EventDetailsModel>> snapshot) {
            if (snapshot.data == null &&
                snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: MediaQuery.of(ctx).size.height / 1.2,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data == null) {
              return _nodatafound();
            } else {
              return snapshot.data!.length == 0
                  ? _nodatafound()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _poster(context, snapshot.data![0].image),
                          _eventTitle("${snapshot.data![0].title}"),
                          _eventPlace(
                              "${snapshot.data![0].date}, ${snapshot.data![0].time}",
                              "${snapshot.data![0].location}"),
                          _eventDetails("${snapshot.data![0].desc}"),
                          Obx(
                            () => Visibility(
                                visible: eventController.getVisible(),
                                child: _eventTitle("Photos")),
                          ),
                          FutureBuilder(
                              future: _getEventImageData(),
                              builder:
                                  (BuildContext ctx, AsyncSnapshot snapshot) {
                                if (snapshot.data == null) {
                                  return Container(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else {
                                  return snapshot.data.length == 0
                                      ? CustomContainer()
                                      : CarouselSlider.builder(
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,
                                                  int itemIndex,
                                                  int pageViewIndex) =>
                                              Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 0),
                                            decoration:
                                                BoxDecoration(boxShadow: [
                                              BoxShadow(
                                                  color: HexColor("1D000000"),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 0))
                                            ]),
                                            child: InkWell(
                                              onTap: () => Get.toNamed(
                                                  "/imgView",
                                                  arguments: [
                                                    snapshot.data[itemIndex]
                                                  ]),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  snapshot.data[itemIndex],
                                                  fit: BoxFit.cover,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  errorBuilder: (_, obj, err) {
                                                    return Container();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          options: CarouselOptions(
                                            height: 250,
                                            enlargeCenterPage: true,
                                            initialPage: 0,
                                          ),
                                        );
                                }
                              }),
                          SizedBox(height: 30),
                          _spaceHeight(20),
                          Visibility(
                            visible:
                                visibleController.getMainSponsorVisiblity(),
                            child: Center(
                                child: SponsorData.sponserTitle(
                                    '${JciString.powered_by}')),
                          ),
                          _spaceHeight(10),
                          Center(child: SponsorData.mainSponsor(context)),
                          _spaceHeight(10),
                          Visibility(
                            visible: visibleController.getVisible(),
                            child: Center(
                                child: SponsorData.sponserTitle(
                                    '${JciString.co_powered_by}')),
                          ),
                          Center(child: SponsorData.otherSponsor(context)),
                          _spaceHeight(20)
                        ],
                      ),
                    );
            }
          },
        ),
      ),
    );
  }

  Center _nodatafound() {
    return Center(
      child: Lottie.asset("assets/lottie/no_data.json"),
    );
  }

  Widget _poster(BuildContext ctx, String _image) {
    return InkWell(
      onTap: () => Get.toNamed("/imgView", arguments: [_image]),
      child: Image.network(
        _image,
        width: MediaQuery.of(ctx).size.width,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (_, obj, err) => Container(),
      ),
    );
  }

  Widget _eventTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        caps(title),
        style: TextStyle(
          fontFamily: "pop-semibold",
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _eventPlace(String date, String location) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: HexColor("1D000000"),
              blurRadius: 10,
              offset: Offset(0, 0)),
          BoxShadow(
              color: HexColor("ffffff"), blurRadius: 1, offset: Offset(0, 0)),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _custTile("clock_colored.svg", date),
          SizedBox(height: 10),
          _custTile("location.svg", location),
        ],
      ),
    );
  }

  Widget _eventDetails(String details) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        caps(details),
        style: TextStyle(
          fontFamily: "pop-med",
          fontSize: 18,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _custTile(var icon, var title) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/$icon",
          width: 18,
        ),
        _space(10),
        Text(
          caps(title),
          style: TextStyle(fontFamily: "pop-med"),
        ),
      ],
    );
  }

  Widget _space(double w) {
    return SizedBox(width: w);
  }

  Widget _spaceHeight(double h) {
    return SizedBox(height: h);
  }

  Widget CustomContainer() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      eventController.setVisible(false);
    });
    return Container();
  }
}

class EventDetailsModel {
  String image, title, date, time, location, desc;

  EventDetailsModel(
      {required this.image,
      required this.title,
      required this.date,
      required this.time,
      required this.location,
      required this.desc});
}
