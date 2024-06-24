import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:telephony/telephony.dart';

import '../../Constants/global_variables.dart';
import '../../api/gps_data_api.dart';
import '../../providers/user_gps_provider.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  Telephony telephony = Telephony.instance;
  List<SmsMessage> allMessages = [];

  BitmapDescriptor markerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  BitmapDescriptor bunkLocIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);

  BitmapDescriptor firebaseLocIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  double lat = 11.92148377563544;
  double lon = 79.62854114224366;

  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation =
      LatLng(12.085591182835007, 79.89038737719477);

  static const LatLng destinationLocation =
      LatLng(12.094195445316924, 79.89506420226814);

  // void customMarker() {
  //   BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/bike.png")
  //       .then((icon) {
  //     setState(() {
  //       markerIcon = icon;
  //     });
  //   });
  // }
  List<LatLng> polyLineCoordinates = [];
  LocationData? currentLocation;
  late GoogleMapController googleMapController;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((locationvalue) {
      setState(() {
        currentLocation = locationvalue;
      });
    });
    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newloc) {
      currentLocation = newloc;

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 13.5,
              target: LatLng(newloc.latitude!, newloc.longitude!))));
      setState(() {});
    });
  }

  List<LatLng> allLatLon = const [
    LatLng(11.918860, 79.653762),
    LatLng(11.921829, 79.632317),
    LatLng(11.882063, 79.629718),
    LatLng(11.882277, 79.629628),
    LatLng(11.921899, 79.632244),
    LatLng(11.918044, 79.661962),
    LatLng(11.923366, 79.662459),
    LatLng(11.927669, 79.662759),
    LatLng(11.954108, 79.629274),
    LatLng(11.872252, 79.628631),
    LatLng(11.870357, 79.613559),
    LatLng(11.875373, 79.606815),
    LatLng(11.875237, 79.606700),
    LatLng(11.892318, 79.742283)
  ];

  List<Marker> petrolBunkMarker = [];
  void addPetrolBunkMarker() {
    int i = 0;
    allLatLon.forEach((element) {
      petrolBunkMarker.add(
        Marker(
          markerId: MarkerId('markerId $i'),
          position: LatLng(element.latitude, element.longitude),
          icon: bunkLocIcon,
        ),
      );
      i++;
    });
    setState(() {});
  }

  // void simulatemap() {
  //   allLatLon.forEach((element) {
  //     Future.delayed(Duration(seconds: 10)).then((value) async {
  //       GoogleMapController googleMapController = await _controller.future;
  //       currentLocation = LocationData.fromMap(
  //           {'latitude': element.latitude, 'longitude': element.longitude});
  //       googleMapController.animateCamera(CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //               zoom: 15.5,
  //               target: LatLng(element.latitude, element.longitude))));
  //       setState(() {});
  //     });
  //   });
  // }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyCoMKZ4Ay3PNKliiKlAEo5sRzOVjpGBY7M",
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng val) {
        polyLineCoordinates.add(LatLng(val.latitude, val.longitude));
      });
      print('THE POLYPOINTS ARE ${polyLineCoordinates}');
      setState(() {});
    }
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/location.png")
        .then((icon) => sourceIcon = icon);
    // BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "")
    //     .then((icon) => destinationIcon = icon);
    // BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "")
    //     .then((icon) => currentLocationIcon = icon);
  }

  // void fetchMessages() {
  //   telephony.requestSmsPermissions.then((value) {
  //     //+918678959286
  //     setState(() {
  //       allMessages = [];
  //     });
  //     telephony.getInboxSms(
  //         columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
  //         filter: SmsFilter.where(SmsColumn.ADDRESS)
  //             .equals('+917448378183')).then((List<SmsMessage> messages) {
  //       print("THE SINGLE MESSAGE IS ${messages.length}");
  //       messages.forEach((element) {
  //         // print("THE ELEMENTS ARE ${element}");
  //         allMessages.add(element);
  //       });
  //       if (messages.isNotEmpty) {
  //         final msgarr = allMessages.first.body!.split(',');
  //         lat = double.parse(msgarr[2].split('=').last);
  //         lon = double.parse(msgarr[3].split('=').last);
  //         print("the msgarr is ${msgarr[1].split("=").last}");

  //         setState(() {});
  //         print("THE LAT LON IS ARE ${lat},${lon}");
  //       }
  //     });
  //   });
  // }

  final ref = FirebaseDatabase.instance.ref('Test');
  void getCurrentLocationFirebase() {
    ref.onValue.listen(
      (event) async {
        Map<dynamic, dynamic> allval = event.snapshot.value as dynamic;

        lat = double.parse(allval['LATITUDE'].toString());
        lon = double.parse(allval['LONGITUDE'].toString());
        setState(() {});
        print("the child changed and the val is $allval");

        googleMapController = await _controller.future;
        googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(zoom: 15.5, target: LatLng(lat, lon))));
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    // fetchMessages();
    // getCurrentLocation();
    // simulatemap();
    addPetrolBunkMarker();
    getCurrentLocationFirebase();

    // getPolyPoints();
    // setCustomMarkerIcon();
    // customMarker();
    // setState(() {
    //   lat = double.tryParse(Provider.of<UserGpsProvider>(context, listen: false)
    //           .userGpsData
    //           .lat) ??
    //       11.92148377563544;
    //   lon = double.tryParse(Provider.of<UserGpsProvider>(context, listen: false)
    //           .userGpsData
    //           .lon) ??
    //       79.62854114224366;
    // });
    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    setState(() {
      petrolBunkMarker = [];
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GpsDataApi gpsDataApi = GpsDataApi();

    // UserGpsProvider userGpsProvider = Provider.of<UserGpsProvider>(context);
    print("the lat is ${lat}");
    print("the lon is ${lon}");

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          'Track Location',
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: GlobalVariables.navGreenColor,
              child: Text(
                'A',
                style: TextStyle(color: GlobalVariables.lightGreenColor),
              ),
            ),
          )
        ],
      ),
      body:
          //currentLocation == null
          //     ? const Center(
          //         child: Text('Loading'),
          //       )
          // :
          Stack(
        children: [
          GoogleMap(
              mapType: MapType.satellite,
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, lon),
                zoom: 13,
              ),
              polylines: {
                Polyline(
                  polylineId: PolylineId("1"),
                  points: polyLineCoordinates,
                  color: GlobalVariables.navGreenColor,
                  width: 10,
                ),
              },
              markers: {
                Marker(
                    markerId: const MarkerId('firebaselocation'),
                    position: LatLng(lat, lon),
                    icon: firebaseLocIcon),

                ...petrolBunkMarker
                // Marker(
                //     markerId: const MarkerId('currentlocation'),
                //     position: LatLng(currentLocation!.latitude!,
                //         currentLocation!.longitude!),
                //     icon: currentLocationIcon),
                // Marker(
                //     markerId: MarkerId('source'),
                //     position: sourceLocation,
                //     icon: markerIcon),
                // Marker(
                //     markerId: MarkerId('destination'),
                //     position: destinationLocation,
                //     icon: markerIcon),
                // Marker(
                //   markerId: MarkerId('id1'),
                //   position: LatLng(lat, lon),
                //   icon: currentLocIcon,
                // ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              }),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: GlobalVariables
                              .navGreenColor), //Colors.blue[900]),
                      onPressed: () async {
                        googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                zoom: 15.5,
                                target: petrolBunkMarker.first.position)));
                        setState(() {});
                      },
                      child: const Text('Locate Petrol Bunks')),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Container(
          decoration: const BoxDecoration(
              color: GlobalVariables.navGreenColor, shape: BoxShape.circle),
          child: IconButton(
              onPressed: () {
                googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(zoom: 18.5, target: LatLng(lat, lon))));
                setState(() {});
              },
              icon: Icon(Icons.track_changes_rounded)),
        ),
      ),
    );
  }
}

// class TrackerScreen extends StatefulWidget {
//   const TrackerScreen({super.key});

//   @override
//   State<TrackerScreen> createState() => _TrackerScreenState();
// }

// class _TrackerScreenState extends State<TrackerScreen> {
//   BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
//   late double lat;

//   late double lon;

//   @override
//   void initState() {
//     // customMarker();
//     setState(() {
//       lat = double.tryParse(Provider.of<UserGpsProvider>(context, listen: false)
//               .userGpsData
//               .lat) ??
//           11.92148377563544;
//       lon = double.tryParse(Provider.of<UserGpsProvider>(context, listen: false)
//               .userGpsData
//               .lon) ??
//           79.62854114224366;
//     });
//     super.initState();
//   }

//   // void customMarker() {
//   //   BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/bike.png")
//   //       .then((icon) {
//   //     setState(() {
//   //       markerIcon = icon;
//   //     });
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     UserGpsProvider userGpsProvider = Provider.of<UserGpsProvider>(context);
//     print("the lat is ${lat}");
//     print("the lon is ${lon}");

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         backgroundColor: Colors.white,
//         title: const Text(
//           'Track Location',
//           style: TextStyle(
//               color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: CircleAvatar(
//               backgroundColor: GlobalVariables.navGreenColor,
//               child: Text(
//                 'A',
//                 style: TextStyle(color: GlobalVariables.lightGreenColor),
//               ),
//             ),
//           )
//         ],
//       ),
//       body: GoogleMap(
//         initialCameraPosition:
//             CameraPosition(target: LatLng(lat, lon), zoom: 14),
//         markers: {
//           Marker(
//               markerId: MarkerId('id1'),
//               position: LatLng(lat, lon),
//               icon: markerIcon),
//         },
//       ),
//     );
//   }
// }
