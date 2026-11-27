import 'package:flutter/material.dart';
import '../auth/auth_screen.dart';

// Screen 12 - My Stats
class MyStatsScreen extends StatefulWidget {
  const MyStatsScreen({super.key});

  @override
  State<MyStatsScreen> createState() => _MyStatsScreenState();
}

class _MyStatsScreenState extends State<MyStatsScreen> {
  bool thisMonth = true;

  // sample numbers for the bars
  List<double> monthBars = [40, 60, 45, 75, 55, 90, 70, 100];
  List<double> allTimeBars = [50, 70, 65, 85, 75, 95, 80, 100];

  @override
  Widget build(BuildContext context) {
    List<double> bars = thisMonth ? monthBars : allTimeBars;
    double energy = thisMonth ? 124.6 : 842.3; // kWh
    double co2 = energy * 0.47; // kg of CO2 saved

    return Scaffold(
      backgroundColor: const Color(0xFF04141A),
      appBar: AppBar(
        title: const Text('My Stats'),
        backgroundColor: const Color(0xFF04141A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // This Month / All Time buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: thisMonth ? kCyan : kFieldBg,
                      foregroundColor: thisMonth ? Colors.black : Colors.white,
                    ),
                    onPressed: () => setState(() => thisMonth = true),
                    child: const Text('This Month'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !thisMonth ? kCyan : kFieldBg,
                      foregroundColor: !thisMonth ? Colors.black : Colors.white,
                    ),
                    onPressed: () => setState(() => thisMonth = false),
                    child: const Text('All Time'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // the bars
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (double b in bars)
                    Container(
                      width: 14,
                      height: b * 1.2,
                      decoration: BoxDecoration(
                        color: kCyan,
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // energy card
            Card(
              color: kFieldBg,
              child: ListTile(
                leading: const Icon(Icons.bolt, color: kCyan, size: 32),
                title: Text('${energy.toStringAsFixed(1)} kWh'),
                subtitle: const Text('Energy Charged'),
              ),
            ),

            // CO2 card
            Card(
              color: kFieldBg,
              child: ListTile(
                leading: const Icon(Icons.eco, color: Colors.green, size: 32),
                title: Text('${co2.toStringAsFixed(1)} kg'),
                subtitle: const Text('CO₂ Saved'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}