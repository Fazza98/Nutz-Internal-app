import 'package:flutter/material.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'bDataSource.dart';

class Birthday extends StatefulWidget {
  const Birthday({Key? key}) : super(key: key);

  @override
  _BirthdayState createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  @override
  void initState() {
    super.initState();
    _getBirthdayData();
  }

  var visibleController = Get.put(sponsorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(titles.birthday).initAppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: _getBirthdayData(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height - 100,
                      child: SfCalendar(
                        view: CalendarView.month,
                        dataSource: MeetingDataSource(snapshot.data),
                        initialSelectedDate: DateTime.now(),
                        showNavigationArrow: true,
                        allowViewNavigation: true,
                        showDatePickerButton: true,
                        monthViewSettings: MonthViewSettings(
                            showAgenda: true,
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.appointment),
                      ),
                    ),
                    _space(20),
                    Visibility(
                        visible: visibleController.getMainSponsorVisiblity(),
                        child: SponsorData.sponserTitle(
                            "${JciString.powered_by}")),
                    _space(10),
                    SponsorData.mainSponsor(context),
                    _space(10),
                    Visibility(
                        visible: visibleController.getVisible(),
                        child: SponsorData.sponserTitle(
                            '${JciString.co_powered_by}')),
                    SponsorData.otherSponsor(context),
                    _space(20)
                  ],
                );
              }
            }),
      ),
    );
  }

  Future<List<Meeting>> _getBirthdayData() async {
    String u = dotenv.get("URL");
    Uri url = Uri.parse("$u/member/dob");
    var _dobresp = await http.get(url);
    var _dobRespData = json.decode(_dobresp.body);
    final List<Meeting> meetings = <Meeting>[];
    for (var _dob in _dobRespData['response']['data']['info']) {
      final String dob = _dob['dob'];
      final List<String> bday = dob.split('/');
      final DateTime startTime = DateTime(
          int.parse(bday[2]), int.parse(bday[1]), int.parse(bday[0]), 10, 0, 0);
      final DateTime endTime = startTime.add(const Duration(hours: 1));
      meetings.add(Meeting(
          '${_dob['user_name']}\'s birthday',
          startTime,
          endTime,
          const Color(0xFF0F8644),
          false,
          'FREQ=YEARLY;BYMONTHDAY=${bday[0]};BYMONTH=${bday[1]};COUNT=100'));
    }

    return meetings;
  }

  Widget _space(double h) {
    return SizedBox(height: h);
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.recurrenceRule);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String recurrenceRule;
}
