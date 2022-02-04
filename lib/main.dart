import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'utils/screens.dart';
import 'package:jci/services/local_notification_service.dart';
import 'package:jci/utils/routes.dart';
import 'package:jci/widgets/drawer.dart';
import 'package:get/get.dart';
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
      getPages: Routes.list,
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
        Get.toNamed("/eventsdetails", arguments: ["$event_id"]);
      } else if (route == "birthday") {
        Get.toNamed("/birthday");
      }
    });
  }

  // void initDynamicLink() async {
  //   final PendingDynamicLinkData? data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   var deepLink = data!.link;
  //   print('$deepLink');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Home(),
      drawer: drawer(),
    );
  }
}
