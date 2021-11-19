import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jci/models/eventsModel.dart';
import 'package:http/http.dart' as http;

class eventService {
  static Future<List<EventsModel>> getEventsData() async {
    String u = dotenv.get("URL");
    Uri url = Uri.parse('$u/member/allevents');
    final response = await http.get(url);
    var _responseData = json.decode(response.body);
    List<EventsModel> eventsList = [];
    for (var event in _responseData['response']['data']['info']) {
      EventsModel em = EventsModel(
          id: "${event['id']}",
          image: event['event_image'],
          title: event['event_name'],
          date: event['event_date'],
          time: event['event_time'],
          location: event['event_location']);
      eventsList.add(em);
    }
    return eventsList;
  }
}
