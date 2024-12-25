import 'package:flutter/material.dart';
// import "package:web_socket_channel/io.dart";
import "package:test_empty_1/config.dart";
import "package:web_socket_channel/web_socket_channel.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:web_socket_channel/status.dart" as web_socket_status;
// import '/strategies/intraday.dart';
// import '/strategies/trend.dart';
class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  late WebSocketChannel _channel;
  String _message = 'Message 0';
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState(){
    super.initState();
    // streamListener(); 
    _initializeNotifications();
    _connectToWebSocket();
  }
  
  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsDarwin = DarwinInitializationSettings();
    final initializationSettings = InitializationSettings(iOS: initializationSettingsDarwin);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  Future<void> _showNotification(String message) async {
    const iOSDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(iOS: iOSDetails);
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'New WebSocket Message',
      message,
      notificationDetails,
      payload: 'item x',
    );
  }
  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(Uri.parse(Config.webSocketUrl));
    _channel.stream.listen((message) {
      setState(() {
        _message = message;
        _showNotification(_message);
        print("received");
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _channel.sink.close(web_socket_status.normalClosure);
  }

  // streamListener(){
  //   channel.stream.listen((message) {
  //     print(message);
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(_message)
    );
  }
}