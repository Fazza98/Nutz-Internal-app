import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';
import 'package:lottie/lottie.dart';
import '../models/membersModel.dart';

class Members extends StatefulWidget {
  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  var appBarTitle = "Members";
  List<String> ID = Get.arguments;

  List<MembersModel> _memberList = [];
  List<MembersModel> _filteredMembersList = [];

  var _searchView = TextEditingController();
  var visibleController = Get.put(sponsorController());

  bool _isSearch = true;
  String _searchText = "";

  @override
  void initState() {
    super.initState();
  }

  String u = dotenv.get("URL");

  Future<List<MembersModel>> _loadMembersInfo() async {
    var _routes;
    switch (ID[0]) {
      case 'bm':
        _routes = "boardmembers";
        break;
      case 'mem':
        _routes = "allmembers";
        break;
      case 'pp':
        _routes = "designation";
        break;
    }

    Uri url = Uri.parse("$u/member/$_routes");

    final _response;
    var _jsonData;
    if (ID[0] == "mem") {
      _response = await http.get(url);
    } else {
      _response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'id': ""}));
    }

    var _responseData = json.decode(_response.body);
    _jsonData = _responseData['response']['data']['info'];

    _memberList.clear();

    if (_jsonData != "Not Found") {
      for (var members in _jsonData) {
        if (ID[0] == "mem") {
          MembersModel _mem = MembersModel(
              id: '${members['id']}',
              img: members['profile_pic'],
              name: members['user_name'],
              title: members['role'],
              phone: members['contact']);
          _memberList.add(_mem);
        } else {
          MembersModel _mem = MembersModel(
              id: '${members['id']}',
              img: members['profile_pic'],
              name: members['user_name'],
              title: members['role'],
              phone: members['contact']);
          _memberList.add(_mem);
        }
      }
    }

    return _memberList;
  }

  @override
  Widget build(BuildContext context) {
    switch (ID[0]) {
      case 'bm':
        appBarTitle = titles.board_members;
        break;
      case 'mem':
        appBarTitle = titles.members;
        break;
      case 'pp':
        appBarTitle = titles.past_presidents;
        break;
    }

    return Scaffold(
      appBar: CustAppBar(appBarTitle).initAppBar(),
      body: Column(
        children: [
          _searchBox(),
          FutureBuilder(
            future: _loadMembersInfo(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return _nodatafound();
              } else {
                if (snapshot.data == null &&
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 3),
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data == null &&
                    snapshot.connectionState == ConnectionState.done) {
                  return _nodatafound();
                } else {
                  return snapshot.data.length == 0
                      ? Expanded(
                          child: Center(
                            child: Container(
                              child: Lottie.asset("assets/lottie/no_data.json",
                                  height: Get.height * 0.3, repeat: true),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              itemCount: _isSearch
                                  ? snapshot.data.length
                                  : _filteredMembersList.length,
                              itemBuilder: (ctx, index) {
                                var mem = _isSearch
                                    ? snapshot.data[index]
                                    : _filteredMembersList[index];
                                if (index == snapshot.data.length - 1) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                            '/profile',
                                            arguments: [
                                              mem.id,
                                            ],
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          margin: EdgeInsets.fromLTRB(
                                              15, 15, 15, 0),
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: HexColor('1A000000'),
                                                    blurRadius: 15,
                                                    offset: Offset(0, 0)),
                                                BoxShadow(
                                                    color: HexColor('ffffff'),
                                                    blurRadius: 1,
                                                    offset: Offset(0, 0))
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            children: [
                                              _memImg(mem.img),
                                              _hSpace(10),
                                              Expanded(
                                                  child: _memDetails(mem.name,
                                                      mem.title, mem.phone)),
                                              _nextIcon(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      _space(20),
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
                                      Get.toNamed(
                                        '/profile',
                                        arguments: [mem.id],
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      margin:
                                          EdgeInsets.fromLTRB(15, 15, 15, 0),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: HexColor('1A000000'),
                                                blurRadius: 15,
                                                offset: Offset(0, 0)),
                                            BoxShadow(
                                                color: HexColor('ffffff'),
                                                blurRadius: 1,
                                                offset: Offset(0, 0))
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          _memImg(mem.img),
                                          _hSpace(10),
                                          Expanded(
                                              child: _memDetails(mem.name,
                                                  mem.title, mem.phone)),
                                          _nextIcon(),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }),
                        );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Expanded _nodatafound() {
    return Expanded(
      child: Center(
        child: Container(
          child: Lottie.asset("assets/lottie/no_data.json"),
        ),
      ),
    );
  }

  Widget _memImg(String link) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        link,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (_, obj, err) {
          return Container();
        },
      ),
    );
  }

  Widget _memDetails(String name, String role, String phn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading(name[0].toUpperCase() + name.substring(1)),
        SizedBox(height: 3),
        _subHeading(role),
        SizedBox(height: 3),
        _subHeading(phn),
      ],
    );
  }

  Widget _heading(String name) {
    return Text(
      caps(name),
      style: TextStyle(
        fontFamily: "pop-semibold",
        fontSize: 20,
      ),
    );
  }

  Widget _subHeading(String name) {
    return Text(
      caps(name),
      style: TextStyle(
        fontFamily: "pop-med",
        fontSize: 14,
      ),
    );
  }

  Widget _hSpace(double w) {
    return SizedBox(width: w);
  }

  Widget _nextIcon() {
    return SvgPicture.asset(
      "assets/icons/next.svg",
      width: 14,
    );
  }

  Widget _searchBox() {
    _searchView.addListener(() {
      if (_searchView.text.isEmpty) {
        setState(() {
          _isSearch = true;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearch = false;
          _searchText = _searchView.text;
          filterMember(_searchText);
        });
      }
    });

    return Container(
        margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        decoration: BoxDecoration(
          color: HexColor('eeeeee'),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: _searchView,
          decoration: InputDecoration(
            hintText: "Search",
            border: InputBorder.none,
            hintStyle: TextStyle(
              fontFamily: "pop-med",
              fontSize: 20,
            ),
            icon: SvgPicture.asset("assets/icons/search_colored.svg"),
          ),
          style: TextStyle(
            fontSize: 20,
          ),
        ));
  }

  void filterMember(String name) {
    _filteredMembersList.clear();

    for (var _mem in _memberList) {
      if (_mem.name.toLowerCase().contains(_searchText)) {
        _filteredMembersList.add(MembersModel(
            id: _mem.id,
            img: _mem.img,
            name: _mem.name,
            title: _mem.title,
            phone: _mem.phone));
      }
    }
  }

  // sponsor section
  Widget _space(double h) {
    return SizedBox(height: h);
  }
}
