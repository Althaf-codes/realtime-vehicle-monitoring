import 'package:alxgration_speedometer/speedometer.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:telephony/telephony.dart';
import 'package:vehicle_monitoring_app/Constants/global_variables.dart';
import 'package:vehicle_monitoring_app/api/gps_data_api.dart';
import 'package:vehicle_monitoring_app/providers/user_gps_provider.dart';
import 'package:vehicle_monitoring_app/service/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // bool vehicleKeyStats = false;

  int speedval = 0;
  int fuelVal = 0;
  String testtxt = 'nothing ';
  // String gpsAddress = 'Fetching';
  String gpsLocality = 'Fetching';
  String gpsRoad = '....';
  String gpsPinCode = '....';
  String gpsStreet = '....';
  String gpsSubLocality = '....';
  bool istheft = false;

  // ' Kalvi Vallal N. Kesavan salai, Medical College Campus, Kalitheerthalkuppam, Puducherry';

  String sms = "";
  List<SmsMessage> allMessages = [];
  Telephony telephony = Telephony.instance;
  LocationData? currentLocation;

  // void getCurrentLocation() async {
  //   Location location = Location();

  //   location.getLocation().then((locationvalue) {
  //     setState(() {
  //       currentLocation = locationvalue;
  //     });
  //   });

  //   location.onLocationChanged.listen((newloc) {
  //     currentLocation = newloc;

  //     setState(() {});
  //   });
  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //       currentLocation!.latitude!, currentLocation!.longitude!);
  //   gpsAddress = ''' ${placemarks.first.locality.toString()},
  //                                    ${placemarks.first.thoroughfare.toString()} ,
  //                                    ${placemarks.first.postalCode.toString()}''';
  //   setState(() {});
  // }

  void fetchMessages() {
    telephony.requestSmsPermissions.then((value) {
      //+918678959286
      setState(() {
        allMessages = [];
      });
      telephony.getInboxSms(
          columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
          filter: SmsFilter.where(SmsColumn.ADDRESS)
              .equals('+917448378183')).then((List<SmsMessage> messages) {
        print("THE SINGLE MESSAGE IS ${messages.length}");
        messages.forEach((element) {
          // print("THE ELEMENTS ARE ${element}");
          allMessages.add(element);
        });
        if (messages.isNotEmpty) {
          final msgarr = allMessages.first.body!.split(',');
          print("the msgarr is ${msgarr[1].split("=").last}");
          speedval = int.parse(msgarr[0].split('=').last);
          fuelVal = int.parse(msgarr[1].split('=').last);

          setState(() {});
          print("THE ALL MESSAGES ARE ${allMessages.first.body}");
        }
      });
    });
  }

  void listenMessages() {
    telephony.requestPhoneAndSmsPermissions.then(
      (value) {
        telephony.listenIncomingSms(
            onNewMessage: (SmsMessage message) {
              //+918678959286
              print(
                  "THE LISTENER MESSAGE IS ${message.address} , ${message.body}");
              testtxt = message.body.toString();
              setState(() {});
            },
            listenInBackground: false);

        // onBackgroundMessage: onBackgroundMessage);
      },
      // onBackgroundMessage: (SmsMessage message) {
      //   if (message.address == "+918678959286") {
      //     final msgListenerBody = message.body!.split(',');
      //     print("THE LISTENER MESSAGE IS ${message.body}");
      //     print(
      //         "the msgarr in listener is ${msgListenerBody[1].split("=").last}");
      //     speedval = int.parse(msgListenerBody[0].split('=').last);
      //     fuelVal = int.parse(msgListenerBody[1].split('=').last);
      //     setState(() {});
      //   }
      // },
    );
  }

  void getaddress({required double latData, required double lonData}) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latData, lonData);

    // print('THE ALL PLACEMARKS ARE ${placemarks}');
    gpsStreet = placemarks.first.street ?? '....';
    gpsSubLocality = placemarks.first.subLocality ?? '....';

    gpsLocality = placemarks.first.locality ?? '....';
    gpsRoad = placemarks.first.thoroughfare ?? '....';
    gpsPinCode = placemarks.first.postalCode ?? '.....';
    // gpsAddress = '''Locality :${placemarks.first.locality.toString()},
    //  Road: ${placemarks.first.thoroughfare.toString()} ,
    //  Pincode: ${placemarks.first.postalCode.toString()}''';
    setState(() {});
  }

  var ref = FirebaseDatabase.instance.ref('Test');

  void getAddressFromFirebase() {
    ref.onValue.listen((event) async {
      Map<dynamic, dynamic> allval = event.snapshot.value as dynamic;

      double lat = double.parse(allval['LATITUDE'].toString());
      double lon = double.parse(allval['LONGITUDE'].toString());
      final fuelIndicator = double.parse(allval['FUEL'].toString()).toInt();
      int speed = double.parse(allval['SPEED'].toString()).toInt();
      bool isAccident = allval['ISACCIDENT'];
      bool isTheft = allval['ISTHEFT'];

      if (fuelIndicator < 1) {
        await NotificationService().showNotification(
          1,
          'Fuel Alert',
          'Your Vehicle have less fuel. Get fuel from Nearby Petrol Bunk',
          const RawResourceAndroidNotificationSound(
              'normal_notification_sound'),
        );
      }
      if (isTheft == true) {
        print("the is theft is $isTheft");
        await NotificationService().showNotification(
          1,
          'Theft Alert',
          'Your Vehicle have been Theft. Switch of the bike ',
          const RawResourceAndroidNotificationSound(
              'normal_notification_sound'),
        );
        istheft = true;
        setState(() {});
      }
      if (isAccident == true) {
        await NotificationService().showNotification(
          2,
          'Accident !!!',
          'Hurry!! The Tracker attached vehicle met with accident. Location is updated in the app',
          RawResourceAndroidNotificationSound('emergency_alarm_69780.mp3'),
        );
      }
      if (speed > 80) {
        print('The speed is $speed ');
        await NotificationService().showNotification(
          3,
          'High Speed !!!',
          'Warning !!. High speed Noted. Advice the user to go slow.',
          RawResourceAndroidNotificationSound('emergency_alarm_69780'),
        );
      }

      setState(() {});
      getaddress(latData: lat, lonData: lon);
    });
  }

  void offBike() async {
    await ref.update({"ISTHEFT": true, "BIKESTATUS": false});
  }

  void turnOffTheftStatus() async {
    await ref.update({"ISTHEFT": false});
    istheft = false;
    setState(() {});
  }

  @override
  void initState() {
    // fetchMessages();
    // listenMessages();
    getAddressFromFirebase();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserGpsProvider userGpsProvider = Provider.of<UserGpsProvider>(context);
    print('SPEEDVAL IS ${speedval}');
    print('FUELVAL IS ${fuelVal}');

    GpsDataApi gpsDataApi = GpsDataApi();
    double global_height = MediaQuery.of(context).size.height;
    double global_width = MediaQuery.of(context).size.width;
    ScrollController _scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          'VMON',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              // await gpsDataApi.getGpsData(context);
              // setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: GlobalVariables.navGreenColor,
                child: Text(
                  'A',
                  style: TextStyle(color: GlobalVariables.lightGreenColor),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
          controller: _scrollController,
          child: StreamBuilder(
              stream: ref.onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error Occured'),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  Map<dynamic, dynamic> arduinoVal =
                      snapshot.data!.snapshot.value as dynamic;
                  print("the arduino val is ${arduinoVal}");
                  print("the fuel is ${arduinoVal['FUEL']}");
                  print("the speed is ${arduinoVal['SPEED']}");
                  print("the lat is ${arduinoVal['LATITUDE']}");
                  print("the lon is ${arduinoVal['LONGITUDE']}");
                  print("the isTheft is ${arduinoVal['ISTHEFT']}");

                  final bikestatus = arduinoVal['BIKESTATUS'];
                  final speed =
                      double.parse(arduinoVal['SPEED'].toString()).toInt();
                  final fuel =
                      double.parse(arduinoVal['FUEL'].toString()).toInt();
                  final latitude =
                      double.parse(arduinoVal['LATITUDE'].toString());
                  final longitude =
                      double.parse(arduinoVal['LONGITUDE'].toString());
                  final istheft = arduinoVal['ISTHEFT'];

                  // print("the snapshot of speed  is ${data!.snapshot.value}");
                  // getaddress(latData: latitude, lonData: longitude);

                  return Column(
                    children: [
                      Container(
                        height: global_height * 0.3,
                        width: global_width,
                        decoration: BoxDecoration(
                            color: GlobalVariables.navGreenColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                '''Hi, Althaf''',
                                style: TextStyle(
                                    color: GlobalVariables.lightGreenColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600),
                              ),
                              Spacer(),
                              Center(
                                child: Text(
                                  'Have A Safe Drive !',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: global_height * 0.15,
                          width: global_width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: GlobalVariables.lightGreenColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ''' YOUR VEHICLE 
          IS
        NOW''',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CupertinoSwitch(
                                      activeColor: Colors.black,
                                      thumbColor: GlobalVariables.navGreenColor,
                                      trackColor:
                                          GlobalVariables.secondaryGreenColor,
                                      value: bikestatus,
                                      onChanged: (bool val) async {
                                        //                           setState(() {
                                        //                             vehicleKeyStats = val;
                                        //                           });

                                        //                           if (val == true) {
                                        //                             await gpsDataApi
                                        //                                 .getGpsData(context);
                                        //                             print(
                                        //                                 "THE FETCHED LAT IS ${userGpsProvider.userGpsData.lat}");
                                        //                             setState(() {});
                                        //                             final latData = double.tryParse(
                                        //                                     userGpsProvider
                                        //                                         .userGpsData.lat) ??
                                        //                                 12.345;
                                        //                             //  11.92148377563544;
                                        //                             final lonData = double.tryParse(
                                        //                                     userGpsProvider
                                        //                                         .userGpsData.lon) ??
                                        //                                 5.68;
                                        //                             //  79.62854114224366;
                                        //                             print(
                                        //                                 'the lat nd lon is ${latData} and ${lonData}');
                                        //                             List<Placemark> placemarks =
                                        //                                 await placemarkFromCoordinates(
                                        //                                     latData, lonData);

                                        //                             print(
                                        //                                 'THE ALL PLACEMARKS ARE ${placemarks}');
                                        //                             setState(() {
                                        //                               gpsAddress =
                                        //                                   '''Locality :${placemarks.first.locality.toString()},
                                        //  Road: ${placemarks.first.thoroughfare.toString()} ,
                                        //  Pincode: ${placemarks.first.postalCode.toString()}''';
                                        //                             });
                                        //                           }

                                        // var first = placemarks.first;

                                        //FETCHES FROM SERVER

                                        // setState(() {
                                        //   vehicleKeyStats = val;
                                        //   print("the gpsaddress is ${gpsAddress}");
                                        //   //   // speedval = int.tryParse(userGpsProvider
                                        //   //   //         .userGpsData.speed) ??
                                        //   //   //     0;
                                        //   //   // fuelVal = int.tryParse(userGpsProvider
                                        //   //   //         .userGpsData.fuelLevel) ??
                                        //   //   //     0;
                                        // });
                                        // print("the switch is $val");
                                      }),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'OFF',
                                        style: TextStyle(
                                            color: bikestatus
                                                ? Colors.black.withOpacity(0.6)
                                                : Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        'ON',
                                        style: TextStyle(
                                            color: bikestatus
                                                ? Colors.black
                                                : Colors.black.withOpacity(0.6),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: global_height * 0.3,
                              width: global_width * 0.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: GlobalVariables.lightGreenColor),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Speedometer(
                                      size: 100,
                                      minValue: 0,
                                      maxValue: 150,
                                      currentValue: bikestatus ? speed : 0,
                                      barColor: Colors.black,
                                      pointerColor:
                                          GlobalVariables.navGreenColor,
                                      displayText: "km/h",
                                      displayTextStyle: TextStyle(
                                        fontSize: 14,
                                        color: speed >= 90
                                            ? Colors.red
                                            : speed > 70
                                                ? Colors.orange
                                                : GlobalVariables.navGreenColor,
                                      ),
                                      displayNumericStyle: TextStyle(
                                          fontSize: 24,
                                          color: speed >= 90
                                              ? Colors.red
                                              : speed > 70
                                                  ? Colors.orange
                                                  : GlobalVariables
                                                      .navGreenColor),
                                      onComplete: () {
                                        print("ON COMPLETE");
                                      },
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.speed_outlined,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    'Speed',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            child: Container(
                              height: global_height * 0.3,
                              width: global_width * 0.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Locality : $gpsLocality',
                                          style: TextStyle(
                                              color: GlobalVariables
                                                  .lightGreenColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 3,
                                          child: Divider(
                                            color: Colors.white,
                                            // thickness: 1,
                                            height: 1,
                                          ),
                                        ),
                                        Text(
                                          'SubLocality : $gpsSubLocality',
                                          style: TextStyle(
                                              color: GlobalVariables
                                                  .lightGreenColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 3,
                                          child: Divider(
                                            color: Colors.white,
                                            // thickness: 1,
                                            height: 1,
                                          ),
                                        ),
                                        Text(
                                          'Street : $gpsStreet',
                                          style: TextStyle(
                                              color: GlobalVariables
                                                  .lightGreenColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 3,
                                          child: Divider(
                                            color: Colors.white,
                                            // thickness: 1,
                                            height: 1,
                                          ),
                                        ),
                                        Text(
                                          'Road : $gpsRoad',
                                          style: TextStyle(
                                              color: GlobalVariables
                                                  .lightGreenColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 3,
                                          child: Divider(
                                            color: Colors.white,
                                            // thickness: 1,
                                            height: 1,
                                          ),
                                        ),
                                        Text(
                                          'Pincode : $gpsPinCode',
                                          style: TextStyle(
                                              color: GlobalVariables
                                                  .lightGreenColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    EvaIcons.pin,
                                    size: 40,
                                    color: GlobalVariables.lightGreenColor,
                                  ),
                                  Text(
                                    'Location',
                                    style: TextStyle(
                                        color: GlobalVariables.lightGreenColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: global_height * 0.3,
                              width: global_width * 0.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Icon(
                                      bikestatus
                                          ? Icons.lock_open_outlined
                                          : Icons.lock_outline_rounded,
                                      size: 60,
                                      color: GlobalVariables.lightGreenColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.lock_outline_rounded,
                                    size: 38,
                                    color: GlobalVariables.lightGreenColor,
                                  ),
                                  Text(
                                    bikestatus ? 'Lock Out' : 'Lock In',
                                    style: TextStyle(
                                        color: GlobalVariables.lightGreenColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: global_height * 0.3,
                              width: global_width * 0.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: GlobalVariables.lightGreenColor),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Speedometer(
                                      size: 100,
                                      minValue: 0,
                                      maxValue: 10,
                                      currentValue: fuel
                                      // int.parse(userGpsProvider.userGpsData.fuelLevel)
                                      ,
                                      barColor: Colors.black,
                                      pointerColor:
                                          GlobalVariables.navGreenColor,
                                      displayText: "litres",
                                      displayTextStyle: TextStyle(
                                        fontSize: 14,
                                        color: fuel <= 1
                                            ? Colors.red
                                            : GlobalVariables.navGreenColor,
                                      ),
                                      displayNumericStyle: TextStyle(
                                        fontSize: 24,
                                        color: fuel <= 1
                                            ? Colors.red
                                            : GlobalVariables.navGreenColor,
                                      ),
                                      onComplete: () {
                                        print("ON COMPLETE");
                                      },
                                    ),
                                  ),
                                  Spacer(),
                                  const Icon(
                                    Icons.gas_meter_outlined,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    'Fuel',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   height: global_height * 0.15,
                      //   width: global_width * 0.9,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(12),
                      //       color: GlobalVariables.lightGreenColor),
                      //   child: Column(
                      //     children: [
                      //       SizedBox(
                      //         height: 8,
                      //       ),
                      //       Text(
                      //         'Report Theft',
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.w500),
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Center(
                      //         child: ElevatedButton(
                      //             style: ElevatedButton.styleFrom(
                      //                 shape: StadiumBorder(),
                      //                 backgroundColor: GlobalVariables
                      //                     .navGreenColor), //Colors.blue[900]),
                      //             onPressed: () async {
                      //               offBike();
                      //               // setState(() {});
                      //             },
                      //             child: const Text('Switch Off the Bike')),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        height: istheft
                            ? global_height * 0.2
                            : global_height * 0.15,
                        width: global_width * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: GlobalVariables.lightGreenColor),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Report Theft',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(),
                                      backgroundColor: GlobalVariables
                                          .navGreenColor), //Colors.blue[900]),
                                  onPressed: () async {
                                    offBike();
                                    // setState(() {});
                                  },
                                  child: const Text('Switch off the Bike')),
                            ),
                            istheft
                                ? Center(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: StadiumBorder(),
                                            backgroundColor: GlobalVariables
                                                .navGreenColor), //Colors.blue[900]),
                                        onPressed: () async {
                                          turnOffTheftStatus();
                                          // setState(() {});
                                        },
                                        child: const Text(
                                            'Turn Off Theft Status')),
                                  )
                                : Container(),
                          ],
                        ),
                      )

                      // Align(
                      //   alignment: Alignment.topCenter,
                      //   child: Container(
                      //     height: 80,
                      //     width: MediaQuery.of(context).size.width,
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(5.0),
                      //       child: Center(
                      //         child: ElevatedButton(
                      //             style: ElevatedButton.styleFrom(
                      //                 shape: StadiumBorder(),
                      //                 backgroundColor: GlobalVariables
                      //                     .navGreenColor), //Colors.blue[900]),
                      //             onPressed: () async {
                      //               setState(() {});
                      //             },
                      //             child: const Text('Switch Off Bike')),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // // Text("SMS MESSAGES"),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   controller: _scrollController,
                      //   itemCount: allMessages.length,
                      //   itemBuilder: (context, index) {
                      //     return ListTile(
                      //         title:
                      //             Text(allMessages[index].address.toString()),
                      //         subtitle:
                      //             Text(allMessages[index].body.toString()));
                      //   },
                      // )
                    ],
                  );
                } else {
                  return const Center(child: Text('Nothing state'));
                }
              })),
    );
  }
}



//lat "12.086236813402904"
//lon "79.89120954067351"