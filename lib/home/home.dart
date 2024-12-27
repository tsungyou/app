// import "dart:ffi";
import "dart:convert";
import 'package:flutter/material.dart';
import 'package:test_empty_1/subscription/subscription.dart';
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
void notificationResponse(NotificationResponse response) {
  if(response.payload != "null"){
    print("Notification clicked: ${response.payload}");
  }
}
void backgroundNotificationResponse(NotificationResponse response) {
  if(response.payload != "null") {
    print("Background notification Clicked: ${response.payload}");
  }
}
class _HomeState extends State<Home>{
  late WebSocketChannel _channel;
  String _message = 'Message 0';
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  
  int _bottomNavigatorIndex = 0;
  @override
  void initState(){
    super.initState();
    _initializeNotifications();
    _connectToWebSocket();
  }

  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettings = InitializationSettings(iOS: DarwinInitializationSettings()); // final

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationResponse,
      onDidReceiveBackgroundNotificationResponse: backgroundNotificationResponse,
    );
  }
  Future<void> _showIntradayNotification(String message) async {
    const iOSDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(iOS: iOSDetails);
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      '當沖訊號: ',
      message,
      notificationDetails,
      payload: 'item x',
    );
  }
  // Notifications ===================
  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(Uri.parse(Config.webSocketUrl));
    _channel.stream.listen((message) {
      setState(() {
        final jsonData = jsonDecode(message);
        final da = jsonData['da'];
        final daLength = da.length;
        final formattedMessage =
        "Code: ${jsonData['code']};${da.substring(daLength-8, daLength)};股價: ${jsonData['cl']}";

        _message = formattedMessage; // Update UI with formatted message
        _showIntradayNotification(_message);
        print("received");
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _channel.sink.close(web_socket_status.normalClosure);
  }

  Widget _getCurrentPage(){
    return Text(_message);
  }
  void _onBottomNavigatortapped(int index) {
    setState(() {
      _bottomNavigatorIndex = index;
    });
  }
  void _subsIconPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SubscriptionPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("策略")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: _subsIconPressed,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text("策略1"),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ]
        ),
      ),
      body: Center(
        child: _getCurrentPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items : const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: "策略"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "教學"
          ),
        ],
        currentIndex: _bottomNavigatorIndex,
        onTap: _onBottomNavigatortapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent, // Highlight color for the selected item
        unselectedItemColor: Colors.white,    // Color for unselected items
        backgroundColor: Colors.black,       // Background color of the navigation bar
        showUnselectedLabels: true,          // Show labels for unselected items
      ),
    );
  }
}