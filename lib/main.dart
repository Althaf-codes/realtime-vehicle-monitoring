import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telephony/telephony.dart';
import 'package:vehicle_monitoring_app/Screen/main_home_page.dart';
import 'package:vehicle_monitoring_app/providers/user_gps_provider.dart';
import 'package:vehicle_monitoring_app/service/notification_service.dart';

import 'Screen/Auth/toggle.dart';
import 'Service/firebase_auth_service.dart';
import 'firebase_options.dart';

//  onBackgroundMessage (SmsMessage message) {
//         if (message.address == "+918678959286") {
//           final msgListenerBody = message.body!.split(',');
//           print("THE LISTENER MESSAGE IS ${message.body}");
//           print(
//               "the msgarr in listener is ${msgListenerBody[1].split("=").last}");
//           speedval = int.parse(msgListenerBody[0].split('=').last);
//           fuelVal = int.parse(msgListenerBody[1].split('=').last);
//           setState(() {});
//         }
//       },
// onBackgroundMessage(SmsMessage message) {
//   print("THE BACKGROUND MSG IS ${message.body}");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
            create: (_) => FirebaseAuthMethods(
                  FirebaseAuth.instance,
                )),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
        ChangeNotifierProvider<UserGpsProvider>(
          create: (_) => UserGpsProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
        routes: {
          Toggle.route: (context) => const Toggle(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    print("THE USER IS $firebaseUser");
    if (firebaseUser != null) {
      print('THE USER IS ${firebaseUser.uid}');
      return const MainHomeScreen();
    } else {
      return const Toggle();
    }
    // return Toggle();
  }
}
