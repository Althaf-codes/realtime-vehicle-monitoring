import 'package:flutter/material.dart';
import 'package:vehicle_monitoring_app/models/user_gps_data.dart';

class UserGpsProvider extends ChangeNotifier {
  UserGpsData _userGpsData = UserGpsData(
    userName: '',
    email: '',
    password: '',
    isParkingOwner: false,
    isTrackerEnabled: false,
    parkingOwnerId: '',
    vehicleConnectionId: '',
    vehicleConnectionPassword: '',
    lat: '',
    lon: '',
    isBikeTheft: false,
    fuelLevel: '',
    speed: '',
  );
  UserGpsData get userGpsData => _userGpsData;

  void updateGpsData(UserGpsData userGpsData) {
    _userGpsData = userGpsData;
    print("the value is updated ");
    notifyListeners();
  }
}
