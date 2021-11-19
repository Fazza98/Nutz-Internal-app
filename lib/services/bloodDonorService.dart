import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jci/models/donorsModel.dart';
import 'package:http/http.dart' as http;

class DonorsService {
  static List<donorsModel> _donorsList = [];

  static Future<List<donorsModel>> getDonorsList() async {
    

    String u = dotenv.get("URL");

    Uri url = Uri.parse("$u/member/blood_donars");

    var _response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': ''}));

    var _responseData = json.decode(_response.body);

    _donorsList.clear();

    _donorsList.add(donorsModel(
        id: "", img: "", name: "", title: "", phone: "", blood: ""));

    for (var _donors in _responseData['response']['data']['info']) {
      var _donor = donorsModel(
          id: "${_donors['id']}",
          img: _donors['profile_pic'],
          name: _donors['user_name'],
          title: _donors['role'],
          phone: _donors['contact'],
          blood: _donors['blood_group']);
      _donorsList.add(_donor);
    }

    return _donorsList;
  }

}
