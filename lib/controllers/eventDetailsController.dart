
import 'package:get/get.dart';

class eventDetailController extends GetxController{
  var visibility = true.obs;

  setVisible(bool visible){
    visibility.value= visible;
    update();
  }
  getVisible(){
    return visibility.value;
  }
}