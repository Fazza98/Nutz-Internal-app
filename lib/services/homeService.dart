import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeService{

  static Future<List<String>> getPastEventImages() async {
    String u = dotenv.get("URL");
    Uri event_images = Uri.parse("$u/member/allevents_image");
    var response = await http.get(event_images);
    var _responseData = json.decode(response.body);
    List<String> _imageList = [];
    for (var imgs in _responseData['response']['data']['info']) {
      _imageList.add(imgs['event_image']);
    }
    return _imageList;
  }
}