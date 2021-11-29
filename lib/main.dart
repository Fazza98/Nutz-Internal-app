import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jci/dashboard/dashboard.dart';
import 'package:jci/events/Events.dart';
import 'package:jci/home/home.dart';
import 'package:jci/profile/profile.dart';
import 'package:jci/roll_of_honour/details.dart';
import 'package:jci/roll_of_honour/roll_of_honour.dart';
import 'package:jci/services/local_notification_service.dart';
import 'package:jci/splash_screen.dart';
import 'package:jci/sponsorDetails/SponsorDetails.dart';
import 'package:jci/widgets/drawer.dart';
import 'package:get/get.dart';
import 'about/about.dart';
import 'birthday/birthday.dart';
import 'blood_donors/bloodDonors.dart';
import 'package:jci/events/eventsDetails.dart';
import 'home/imageViewer.dart';
import 'members/members.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  // LocalNotificationService.display(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(
    GetMaterialApp(
      initialRoute: '/splash',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
            name: '/splash',
            page: () => SplashScreen(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/', page: () => Main(), transition: Transition.leftToRight),
        GetPage(
            name: '/home',
            page: () => Home(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/about',
            page: () => About(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/sponsor',
            page: () => SponsorDetails(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/events',
            page: () => Events(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/eventsdetails',
            page: () => EventsDetails(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/members',
            page: () => Members(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/blood',
            page: () => BloodDonors(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/roh',
            page: () => RollOfHonour(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/roh_details',
            page: () => RohDetails(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/birthday',
            page: () => Birthday(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/profile',
            page: () => Profile(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/imgView',
            page: () => ImageViewer(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/dashboard',
            page: () => Dashboard(),
            transition: Transition.leftToRight)
      ],
      theme: ThemeData(fontFamily: "pop-reg"),
    ),
  );
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();

    LocalNotificationService.initialize();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        if (message.data != null) {
          var route = message.data["route"];
          Get.toNamed('/$route');
        }
      }
    });

    FirebaseMessaging.instance.subscribeToTopic("events");
    // To get fcm token ..
    // FirebaseMessaging.instance.getToken().then((token){
    //   print(token);
    // });

    FirebaseMessaging.onMessage.listen((message) {
      var firebaseNotification = message.notification;
      if (firebaseNotification != null) {
        LocalNotificationService.display(message, null, null);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      var route = message.data['route'];
      var event_id = message.data['event_id'];
      if (route == "events") {
        Get.toNamed("/eventsdetails", arguments: ["${event_id}"]);
      } else if (route == "birthday") {
        Get.toNamed("/birthday");
      }
    });
  }

  void initDynamicLink() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    var deepLink = data!.link;
    print('$deepLink');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Home(),
      drawer: drawer(),
    );
  }
}
