import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/handelaar.dart';

class RestData {

  static RestData _instance = new RestData.internal();
  RestData.internal();
  factory RestData() => _instance;

  static const String BASE_URL = "https://testlekkerlokaal.azurewebsites.net/api/mobieleapp/";

  Future<Handelaar> meldHandelaarAan(String username, String password) async {
    final response = await http.get(BASE_URL + username + "/" + password);
    final responseJson = json.decode(response.body);
    return new Handelaar.fromJson(responseJson);
  }

}