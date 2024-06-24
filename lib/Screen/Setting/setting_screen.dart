import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constants/global_variables.dart';
import '../../Widgets/setting_card.dart';
import '../../service/firebase_auth_service.dart';
import '../Auth/toggle.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final authprovider =
    //     Provider.of<FirebaseAuthMethods>(context, listen: false);
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Text(
                      'Your Profile',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                  child: Text("A",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold)),
                                  backgroundColor:
                                      GlobalVariables.lightGreenColor,
                                  radius: 60),
                              Positioned(
                                bottom: 1,
                                right: -10,
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GlobalVariables.navGreenColor),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 20,
                                        color: Colors.white,
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 40,
                        ),
                        SettingCard(
                            icon: Icons.person_outline, text: 'Account'),
                        Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        // SettingCard(
                        //     icon: FontAwesomeIcons.bell, text: 'Notification'),
                        // Divider(),
                        // const SizedBox(
                        //   height: 10,
                        // ),

                        // SettingCard(
                        //     icon: Icons.visibility_outlined, text: 'Appearance'),
                        // Divider(),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        SettingCard(
                            icon: Icons.lock_outline,
                            text: 'Privacy & Security'),
                        Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        SettingCard(
                            icon: Icons.headphones, text: 'Help and Support'),
                        Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        SettingCard(
                            icon: EvaIcons.questionMarkCircleOutline,
                            text: 'About'),
                        Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Builder(builder: (context) {
                          return GestureDetector(
                            onTap: () async {
                              // await authprovider.signOut(context).then((value) =>
                              //     Navigator.pushNamedAndRemoveUntil(
                              //         context, Toggle.route, (route) => false));

                              await context
                                  .read<FirebaseAuthMethods>()
                                  .signOut(context)
                                  .then((value) =>
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          Toggle.route, (route) => false));

                              // .then((value) =>
                              //     Navigator.pushNamedAndRemoveUntil(context,
                              //         Toggle.route, (route) => false));
                              // context
                              //     .read<FirebaseAuthMethods>()
                              //     .signOut(context)
                              //     .then((value) =>
                              //         Navigator.pushNamedAndRemoveUntil(context,
                              //             Toggle.route, (route) => false));
                            },
                            child: SettingCard(
                                icon: Icons.logout_outlined, text: 'Sign Out'),
                          );
                        }),

                        Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
