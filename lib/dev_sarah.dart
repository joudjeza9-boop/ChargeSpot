import 'package:flutter/material.dart';
import 'features/charging/charging_session_screen.dart';
import 'features/history/charging_history_screen.dart';
import 'features/stats/my_stats_screen.dart';

// only for testing my screens
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: const TestMenu(),
  ));
}

class TestMenu extends StatelessWidget {
  const TestMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Screens')),
      body: Column(
        children: [
          ListTile(
            title: const Text('09 Charging Session'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ChargingSessionScreen())),
          ),
          ListTile(
            title: const Text('11 Charging History'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ChargingHistoryScreen())),
          ),
          ListTile(
            title: const Text('12 My Stats'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MyStatsScreen())),
          ),
        ],
      ),
    );
  }
}