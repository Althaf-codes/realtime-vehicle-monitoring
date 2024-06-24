import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:floating_navigation_bar/floating_navigation_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_monitoring_app/Constants/global_variables.dart';
import 'package:vehicle_monitoring_app/Screen/Home/home_screen.dart';
import 'package:vehicle_monitoring_app/Screen/Setting/setting_screen.dart';
import 'package:vehicle_monitoring_app/Screen/Tracker/tracker_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var pageList = <Widget>[
      const HomeScreen(),
      const TrackerScreen(),
      const SettingScreen()
    ];
    return Scaffold(
      backgroundColor: Colors.grey[140],
      body: pageList[currentIndex],
      bottomNavigationBar: FloatingNavigationBar(
        backgroundColor: GlobalVariables.navGreenColor,
        barHeight: 60.0,
        barWidth: MediaQuery.of(context).size.width * 0.8,
        iconColor: Colors.white,
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
        iconSize: 20.0,
        indicatorColor: Colors.white,
        indicatorHeight: 5,
        indicatorWidth: 14.0,
        items: [
          NavBarItems(
            icon: EvaIcons.homeOutline,
            title: "Home",
          ),
          NavBarItems(
            icon: EvaIcons.pinOutline,
            title: "Track",
          ),
          NavBarItems(
            icon: EvaIcons.settingsOutline,
            title: "Settings",
          ),
        ],
        onChanged: (value) {
          currentIndex = value;
          setState(() {});
        },
      ),
    );
  }
}
