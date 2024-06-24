import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../Constants/global_variables.dart';

class SettingCard extends StatelessWidget {
  IconData icon;
  String text;
  SettingCard({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: GlobalVariables.lightGreenColor,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                text,
                style: TextStyle(
                    color: GlobalVariables.navGreenColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: GlobalVariables.navGreenColor,
          ),
        ],
      ),
    );
  }
}
