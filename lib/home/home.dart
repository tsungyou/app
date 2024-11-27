import 'package:flutter/material.dart';
import '/strategies/PE_2.dart';
import '/strategies/PE.dart';
// import '/strategies/intraday.dart';
// import '/strategies/trend.dart';
import '/strategies/twse_signal.dart';
import '/models/notifications.dart';
class Home extends StatelessWidget {
  const Home({super.key});
  Widget verticalLine() {
    return Container(
      width: 1.0,
      height: 40.0,
      color: Colors.white,
    );
  }
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("123"),
          ),
          bottom: PreferredSize(
          preferredSize: const Size.fromHeight(150.0), // Adjust height as needed
            child: Column(
              children: [
                // Row item to be displayed above the TabBar
                Container(
                  color: Colors.blueAccent.withOpacity(0.5), // Background color
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('123'),
                          ],
                        ),
                      ),
                      verticalLine(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(onPressed: () {
                              NotificationModel().showNotification(title: 'It works!', body: 'It works');
                            }, child: const Text("noit")),
                          ],
                        ),
                      ),
                      verticalLine(),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('123'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                // TabBar
                const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.apps), text: 'PE'),
                    Tab(icon: Icon(Icons.leaderboard), text: 'Intraday'),
                    Tab(icon: Icon(Icons.person), text: 'Trend'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            PE(),
            TwseBullbear(),
            PeTester(),
          ],
        ),
      ),
    );
  }
  
}
