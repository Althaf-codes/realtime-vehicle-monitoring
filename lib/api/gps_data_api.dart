import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vehicle_monitoring_app/models/user_gps_data.dart';
import 'package:vehicle_monitoring_app/providers/user_gps_provider.dart';

class GpsDataApi {
  static String id = '63faf24f5e56abe0980def56';
  Future<void> getGpsData(BuildContext context) async {
    try {
      var res = await http.get(
        Uri.parse(
            'https://vmon.cyclic.app/api/getbyid/63faf24f5e56abe0980def56'),
      );
      print('The res is ${res.body}');
      final gpsData = jsonDecode(res.body);
      print('the gpsData is ${gpsData}');

      UserGpsData userGpsData = UserGpsData.fromMap(gpsData);
      print('THE USERGPSDATA IS ${userGpsData.fuelLevel}');
      Provider.of<UserGpsProvider>(context, listen: false)
          .updateGpsData(userGpsData);
    } catch (e) {
      print('THE ERROR IS $e');
    }
  }
}
