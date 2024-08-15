import 'package:flutter/material.dart';
import '/strategies/PE.dart';
import '/strategies/intraday.dart';
import '/strategies/trend.dart';
import '/stocks/detailedRobinhood.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
                      // First column
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Column 1',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              'Content 1',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // Vertical line
                      Container(
                        width: 1.0,
                        height: 40.0,
                        color: Colors.white,
                      ),
                      // Second column
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Column 2',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              'Content 2',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // Vertical line
                      Container(
                        width: 1.0,
                        height: 40.0,
                        color: Colors.white,
                      ),
                      // Third column
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Column 3',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              'Content 3',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
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
            Intraday(),
            Trend(),
          ],
        ),
      ),
    );
  }
}
