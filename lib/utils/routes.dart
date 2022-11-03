import 'package:get/route_manager.dart';
import 'package:jci/utils/screens.dart';

class Routes {
  static List<GetPage> list = [
    GetPage(
        name: '/splash',
        page: () => SplashScreen(),
        transition: Transition.leftToRight),
    GetPage(name: '/', page: () => Main(), transition: Transition.leftToRight),
    GetPage(
        name: '/home', page: () => Home(), transition: Transition.leftToRight),
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
    // GetPage(
    //     name: '/dashboard',
    //     // page: () => Dashboard(),
    //     transition: Transition.leftToRight)
  ];
}
