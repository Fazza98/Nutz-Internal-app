import 'package:flutter/material.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/familyModel.dart';
import '../models/businessModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/personalModel.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  final _appTitle = 'Profile';

  var ID = Get.arguments;

  // profile meta data
  String NAME = "location";
  String ROLE = "EMAIL";
  String PHONE = "null";
  String PROFILE_PIC = 'NULL';

  final _darkblue = '23346B';
  final _lightBlue = '24B9EC';

  late TabController _tabController;

  List<Tab> list = [];
  String u = dotenv.get("URL");

  Future<List<FamilyModel>> _getFamilyList() async {
    Uri url = Uri.parse("$u/member/family");
    http.Response famResp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{"id": ID[0]}));

    var _famRespData = json.decode(famResp.body);

    List<FamilyModel> _famList = [];
    for (var famMem in _famRespData['response']['data']['info']) {
      FamilyModel fam = FamilyModel(
          name: famMem['name'],
          dob: famMem['dob'],
          relationship: famMem['relationship']);
      _famList.add(fam);
    }
    return _famList;
  }

  Future<List<BusinessModel>> _getBusinessList() async {
    Uri _bUrl = Uri.parse("$u/member/member");

    var _bresp = await http.post(_bUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"id": ID[0]}));

    var _brespData = json.decode(_bresp.body);

    List<BusinessModel> _businessList = [];

    for (var _mem in _brespData['response']['data']['info']) {
      BusinessModel bm = BusinessModel(
          role: _mem['job'],
          companyName: _mem['office_name'],
          sector: _mem['sector']);
      _businessList.add(bm);
    }
    return _businessList;
  }

  Future<List<PersonalModel>> _getPersonalList() async {
    Uri _bUrl = Uri.parse("$u/member/member");

    var _bresp = await http.post(_bUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"id": ID[0]}));

    var _prespData = json.decode(_bresp.body);
    List<PersonalModel> _personalList = [];

    for (var _mem in _prespData['response']['data']['info']) {
      NAME = _mem['user_name'];
      PROFILE_PIC = _mem['profile_pic'];
      ROLE = _mem['role'];
      PHONE = _mem['contact'];
      PersonalModel pm = PersonalModel(
          location: '${_mem['location']}',
          email: '${_mem['email']}',
          dob: '${_mem['dob']}',
          blood: '${_mem['blood_group']}',
          phoneno: '${_mem['contact']}');

      _personalList.add(pm);
    }
    return _personalList;
  }

  @override
  void initState() {
    super.initState();
    list.add(_personalTap());
    list.add(_businessTap());
    list.add(_familyTap());
    _tabController = TabController(length: list.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(_appTitle).initAppBar(),
      body: OrientationBuilder(
        builder: (ctx, orientation) {
          if (orientation == Orientation.portrait) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder(
                      future: _getPersonalList(),
                      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return _profilePic("", "", "");
                        } else {
                          return _profilePic("$PROFILE_PIC", "$NAME", "$ROLE");
                        }
                      }),
                  Container(
                    decoration:
                        BoxDecoration(color: HexColor(_darkblue), boxShadow: [
                      BoxShadow(
                        color: HexColor('1A000000'),
                        blurRadius: 10,
                        offset: Offset(4, -4),
                      ),
                      BoxShadow(
                        color: HexColor(_darkblue),
                        blurRadius: 4,
                        offset: Offset(4, -4),
                      )
                    ]),
                    child: TabBar(
                      indicator: BoxDecoration(color: HexColor(_lightBlue)),
                      unselectedLabelColor: Colors.white,
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: list,
                      unselectedLabelStyle: TextStyle(
                        fontFamily: 'pop-med',
                        fontSize: 15,
                      ),
                      labelStyle: TextStyle(
                        fontFamily: 'pop-med',
                        fontSize: 15,
                      ),
                      automaticIndicatorColorAdjustment: false,
                    ),
                  ),
                  Flexible(
                    child: TabBarView(controller: _tabController, children: [
                      FutureBuilder(
                          future: _getPersonalList(),
                          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return Container(
                                  height: 200,
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            } else {
                              return personalInfo(snapshot);
                            }
                          }),
                      FutureBuilder(
                          future: _getBusinessList(),
                          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return Container(
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            } else {
                              return _businessInfo(snapshot);
                            }
                          }),
                      FutureBuilder(
                          future: _getFamilyList(),
                          builder: (BuildContext ctx,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.data == null) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return _familyInfo(snapshot);
                            }
                          })
                    ]),
                  ),
                  // call button
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: HexColor(_darkblue),
                            padding: EdgeInsets.all(10)),
                        onPressed: () {
                          if (PHONE == "null") {
                            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                              content: Text("User not provide contact details"),
                              padding: EdgeInsets.all(10),
                              duration: Duration(seconds: 2),
                            ));
                          } else {
                            launch("tel://$PHONE");
                          }
                        },
                        child: Text(
                          'Call Now',
                          style:
                              TextStyle(fontFamily: 'pop-bold', fontSize: 14),
                        )),
                  ),
                ],
              ),
            );
          } else {
            return Center(
                child: Container(
                    child: Text(
              'Please rotate your device for better experience.',
              style: TextStyle(fontFamily: 'pop-semibold'),
            )));
          }
        },
      ),
    );
  }

  _profilePic(String propic, String name, String role) {
    return propic != ''
        ? Container(
            padding: EdgeInsets.all(20),
            color: HexColor(_darkblue),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Get.toNamed("/imgView", arguments: [propic]),
                  child: CircleAvatar(
                    radius: Get.height * 0.05,
                    backgroundImage: NetworkImage(propic),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'pop-semibold'),
                ),
                SizedBox(height: 5),
                Text(
                  role,
                  style: TextStyle(
                      color: Colors.white, fontSize: 16, fontFamily: 'pop-med'),
                )
              ],
            ),
          )
        : Container();
  }

  _personalTap() => Tab(child: _customTabTitle("Personal info"));
  _businessTap() => Tab(child: _customTabTitle('Business info'));
  _familyTap() => Tab(child: _customTabTitle('Family info'));

  _space(double h) {
    return SizedBox(
      height: h,
    );
  }

  personalInfo(AsyncSnapshot snapshot) {
    return ListView(
      children: [
        _space(5),
        _custTile('location.svg', snapshot.data[0].location),
        _custTile('mail_colored.svg', snapshot.data[0].email),
        _custTile('heart.svg', snapshot.data[0].dob),
        _custTile('blood_colored.svg', snapshot.data[0].blood),
        _custTile('phone_colored.svg', snapshot.data[0].phoneno)
      ],
    );
  }

  _businessInfo(AsyncSnapshot snapshot) {
    return ListView(
      children: [
        _space(5),
        _custTile('work.svg', snapshot.data[0].role),
        _custTile('work.svg', snapshot.data[0].sector),
        _custTile('location.svg', snapshot.data[0].companyName),
      ],
    );
  }

  _familyInfo(AsyncSnapshot<dynamic> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext ctx, int index) {
          if (index == 0) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      _tableTile("Name"),
                      _tableTile("DOB"),
                      _tableTile("Relationship")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      _tableTile("${snapshot.data[index].name}"),
                      _tableTile("${snapshot.data[index].dob}"),
                      _tableTile("${snapshot.data[index].relationship}")
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _tableTile("${snapshot.data[index].name}"),
                  _tableTile("${snapshot.data[index].dob}"),
                  _tableTile("${snapshot.data[index].relationship}")
                ],
              ),
            );
          }
        });
  }

  _custTile(String icon, String title) {
    return ListTile(
      title: Text("$title"),
      minLeadingWidth: 1,
      leading: SvgPicture.asset(
        'assets/icons/$icon',
        width: 24,
      ),
    );
  }

  _customTabTitle(String title) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  _tableTile(var str) {
    return Expanded(
        child: Container(
      child: Text(
        '$str',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "pop-med",
          fontSize: 18,
        ),
      ),
    ));
  }
}
