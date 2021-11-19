import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jci/models/rohModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class rohService {
  static Future<List<RohModel>> getROHData(year) async {
    String u = dotenv.get("URL");
    Uri url = Uri.parse("$u/member/roh");
    var _resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{"year": "$year"}));
    var _responseData = json.decode(_resp.body);

    print(_responseData);
    List<RohModel> memberList = [];

    for (var members in _responseData['response']['data']['info']) {
      RohModel member = RohModel(
          img: members['Member']['profile_pic'],
          name: members['Member']['user_name'],
          role: members['Member']['role']);
      memberList.add(member);
    }

    return memberList;
  }
}
