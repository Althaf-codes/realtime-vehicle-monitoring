import 'package:vehicle_monitoring_app/resources/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  // void connectTracker(String trackerId) {

  // }

  void getGpsData() {
    _socketClient.on('gpsData', (data) {
      print('The GPS data is ${data.toString()}');
    });
  }
}
