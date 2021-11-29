import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jci/models/donorsModel.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/services/bloodDonorService.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/widgets/common.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';

class BloodDonors extends StatefulWidget {
  const BloodDonors({Key? key}) : super(key: key);

  @override
  _BloodDonorsState createState() => _BloodDonorsState();
}

class _BloodDonorsState extends State<BloodDonors> {
  var lightColor = "24B9EC";
  String selectedGroup = "empty";

  List<donorsModel> _filteredList = [];
  static List<donorsModel> _donorsList = [];

  @override
  void initState() {
    super.initState();
    setDonorList();
  }

  setDonorList() async {
    _donorsList = await DonorsService.getDonorsList();
  }

  var visibleController = Get.put(sponsorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(titles.blood_donors).initAppBar(),
      body: SafeArea(
        child: FutureBuilder(
          future: DonorsService.getDonorsList(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: (selectedGroup == "empty")
                        ? snapshot.data.length
                        : _filteredList.length,
                    itemBuilder: (ctx, index) {
                      var mem = (selectedGroup == "empty")
                          ? snapshot.data[index]
                          : _filteredList[index];
                      if (index == 0) {
                        return _header();
                      } else if (index == snapshot.data.length - 1) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: HexColor('1A000000'),
                                    blurRadius: 15,
                                    offset: Offset(0, 0)),
                                BoxShadow(
                                    color: HexColor('ffffff'),
                                    blurRadius: 1,
                                    offset: Offset(0, 0))
                              ], borderRadius: BorderRadius.circular(10)),
                              child: _memRow(mem),
                            ),
                            _space(20),
                            Visibility(
                                visible:
                                    visibleController.getMainSponsorVisiblity(),
                                child: SponsorData.sponserTitle(
                                    "${JciString.powered_by}")),
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
                        return Container(
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: HexColor('1A000000'),
                                blurRadius: 15,
                                offset: Offset(0, 0)),
                            BoxShadow(
                                color: HexColor('ffffff'),
                                blurRadius: 1,
                                offset: Offset(0, 0))
                          ], borderRadius: BorderRadius.circular(10)),
                          child: _memRow(mem),
                        );
                      }
                    });
              }
            }
          },
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      color: Utils.darkBlue,
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bloodGroup("A+"),
                _bloodGroup("B+"),
                _bloodGroup("O+"),
                _bloodGroup("AB+"),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bloodGroup("A-"),
                _bloodGroup("B-"),
                _bloodGroup("O-"),
                _bloodGroup("AB-"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bloodGroup(String type) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedGroup = type;
          filterMember(selectedGroup);
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selectedGroup == type ? HexColor(lightColor) : Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(type,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: "pop-semibold",
            )),
        width: 80,
        height: 80,
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
        _heading(name),
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
      'assets/icons/next.svg',
      width: 14,
    );
  }

  _memRow(mem) {
    return InkWell(
      onTap: () {
        Get.toNamed("/profile", arguments: [mem.id]);
      },
      child: Row(
        children: [
          _memImg(mem.img),
          _hSpace(10),
          Expanded(child: _memDetails(mem.name, mem.title, mem.phone)),
          _nextIcon(),
        ],
      ),
    );
  }

  void filterMember(var blood_group) {
    _filteredList.clear();

    _filteredList.add(donorsModel(
        id: "", img: "", name: "", title: "", phone: "", blood: ""));

    for (var _mem in _donorsList) {
      if (_mem.blood == blood_group) {
        _filteredList.add(_mem);
      }
    }
  }

  Widget _space(double h) {
    return SizedBox(height: h);
  }
}
