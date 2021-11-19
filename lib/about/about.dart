import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';
import 'package:get/get.dart';

class About extends StatelessWidget {
  var controller = Get.put(sponsorController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(titles.about).initAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/images/about_img.svg",
              width: MediaQuery.of(context).size.width,
            ),
            _space(10),
            Center(
              child: Text(
                "About JCI",
                style: TextStyle(
                  fontFamily: 'pop-bold',
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
              child: Text(
                "Junior Chamber International (JCI) is a worldwide federation of young leaders and entrepreneurs with nearly five lakh active members and millions of alumni spread across more than 115 countries.Each JCI member shares the belief that in order to create lasting positive change, we must improve ourselves and the world around us.JCI offers meetings, dynamic training sessions and projects that provide opportunities to learn, achieve and inspire active citizenship, while building their experience as leaders.The origin of Junior Chamber international (JCI)can be traced as far as almost a century  ago in 1915 to the city of St. Louis, Missouri, USA, where a young man named Henry Giessenbier together with 32 other young men, established the Young Men’s Progressive Civic Association (YMPCA), JCI’s first local organization. YMPCA grew to a membership of 750 in less than five months. The association went on to dedicate itself to bringing about civic improvements and giving young people a constructive approach to civic problems.",
                style: TextStyle(
                  fontFamily: "pop-med",
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Center(
              child: Text(
                "JCI Mission",
                style: TextStyle(
                  fontFamily: 'pop-bold',
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "To provide development opportunities that empower young people to create positive change.",
                style: TextStyle(
                  fontFamily: "pop-med",
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                "JCI Vision",
                style: TextStyle(
                  fontFamily: 'pop-bold',
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "To be the leading global network of young active citizens",
                style: TextStyle(
                  fontFamily: "pop-med",
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            _space(20),
            Visibility(
                visible: controller.getMainSponsorVisiblity(),
                child: SponsorData.sponserTitle("${JciString.powered_by}")),
            _space(10),
            SponsorData.mainSponsor(context),
            _space(10),
            Visibility(
                visible: controller.getVisible(),
                child: SponsorData.sponserTitle('${JciString.co_powered_by}')),
            SponsorData.otherSponsor(context),
            _space(20)
          ],
        ),
      ),
    );
  }

  Widget _space(double h) {
    return SizedBox(height: h);
  }
}
