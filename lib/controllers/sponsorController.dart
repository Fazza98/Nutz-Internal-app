import 'package:get/get.dart';

class sponsorController extends GetxController {
  var _visible = true.obs;
  var _mainSponsorVisible = true.obs;

  setVisible(bool value) {
    _visible.value = value;
    update();
  }

  getVisible() => _visible.value;

  setMainSponsorVisible(bool value) => _mainSponsorVisible.value = value;

  getMainSponsorVisiblity() => _mainSponsorVisible.value;

  
}
