import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:web_socket_channel/web_socket_channel.dart";

class NotificationService {
  final Map<String, WebSocketChannel?> _channels = {};
  final Map<String, bool> _activeChannels = {};

  void initializeChannel(String channelName, String websocketUrl) {
    _activeChannels[channelName] = false;
    _channels[channelName] = WebSocketChannel.connect(
      Uri.parse(websocketUrl),
    );
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

}