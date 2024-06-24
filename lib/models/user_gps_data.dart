// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserGpsData {
  String userName;
  String email;
  String password;
  bool isParkingOwner;
  bool isTrackerEnabled;
  String? parkingOwnerId;
  String vehicleConnectionId;
  String vehicleConnectionPassword;
  String lat;
  String lon;
  String fuelLevel;
  String speed;
  bool isBikeTheft;
  UserGpsData({
    required this.userName,
    required this.email,
    required this.password,
    required this.isParkingOwner,
    required this.isTrackerEnabled,
    required this.parkingOwnerId,
    required this.vehicleConnectionId,
    required this.vehicleConnectionPassword,
    required this.lat,
    required this.lon,
    required this.fuelLevel,
    required this.speed,
    required this.isBikeTheft,
  });

  UserGpsData copyWith({
    String? userName,
    String? email,
    String? password,
    bool? isParkingOwner,
    bool? isTrackerEnabled,
    String? parkingOwnerId,
    String? vehicleConnectionId,
    String? vehicleConnectionPassword,
    String? lat,
    String? lon,
    String? fuelLevel,
    String? speed,
    bool? isBikeTheft,
  }) {
    return UserGpsData(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      isParkingOwner: isParkingOwner ?? this.isParkingOwner,
      isTrackerEnabled: isTrackerEnabled ?? this.isTrackerEnabled,
      parkingOwnerId: parkingOwnerId ?? this.parkingOwnerId,
      vehicleConnectionId: vehicleConnectionId ?? this.vehicleConnectionId,
      vehicleConnectionPassword:
          vehicleConnectionPassword ?? this.vehicleConnectionPassword,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      fuelLevel: fuelLevel ?? this.fuelLevel,
      speed: speed ?? this.speed,
      isBikeTheft: isBikeTheft ?? this.isBikeTheft,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'email': email,
      'password': password,
      'isParkingOwner': isParkingOwner,
      'isTrackerEnabled': isTrackerEnabled,
      'parkingOwnerId': parkingOwnerId,
      'vehicleConnectionId': vehicleConnectionId,
      'vehicleConnectionPassword': vehicleConnectionPassword,
      'lat': lat,
      'lon': lon,
      'fuelLevel': fuelLevel,
      'speed': speed,
      'isBikeTheft': isBikeTheft,
    };
  }

  factory UserGpsData.fromMap(Map<String, dynamic> map) {
    return UserGpsData(
      userName: map['userName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      isParkingOwner: map['isParkingOwner'] as bool,
      isTrackerEnabled: map['isTrackerEnabled'] as bool,
      parkingOwnerId: map['parkingOwnerId'] != null
          ? map['parkingOwnerId'] as String
          : null,
      vehicleConnectionId: map['vehicleConnectionId'] as String,
      vehicleConnectionPassword: map['vehicleConnectionPassword'] as String,
      lat: map['lat'] as String,
      lon: map['lon'] as String,
      fuelLevel: map['fuelLevel'] as String,
      speed: map['speed'] as String,
      isBikeTheft: map['isBikeTheft'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserGpsData.fromJson(String source) =>
      UserGpsData.fromMap(json.decode(source) as Map<String, dynamic>);
}
