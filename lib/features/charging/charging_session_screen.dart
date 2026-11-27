import 'dart:async';
import 'package:flutter/material.dart';
import '../auth/auth_screen.dart';

// Screen 09 - Charging Session
class ChargingSessionScreen extends StatefulWidget {
  const ChargingSessionScreen({super.key});

  @override
  State<ChargingSessionScreen> createState() => _ChargingSessionScreenState();
}

class _ChargingSessionScreenState extends State<ChargingSessionScreen> {
  int battery = 30; // battery percent
  double energy = 0; // kWh
  double price = 0.75; // SAR for each kWh
  bool isCharging = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // every second the battery goes up 1%
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (battery < 100) {
        setState(() {
          battery = battery + 1;
          energy = energy + 0.75;
        });
      } else {
        stopCharging(); // stops by itself when full
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void stopCharging() {
    timer?.cancel();
    setState(() {
      isCharging = false;
    });

    double cost = energy * price;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Charging Finished'),
        content: Text(
          'Energy: ${energy.toStringAsFixed(1)} kWh\n'
          'Total: SAR ${cost.toStringAsFixed(2)}\n\n'
          'Paid with your saved card.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double cost = energy * price;
    int minutesLeft = (100 - battery) ~/ 3;

    return Scaffold(
      backgroundColor: const Color(0xFF04141A),
      appBar: AppBar(
        title: const Text('Charging'),
        centerTitle: true,
        backgroundColor: const Color(0xFF04141A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // the circle
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: battery / 100,
                    strokeWidth: 12,
                    color: kCyan,
                    backgroundColor: kBorder,
                  ),
                ),
                Text(
                  '$battery%',
                  style: const TextStyle(
                      fontSize: 45, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Text(
              isCharging ? 'Charging...' : 'Done',
              style: const TextStyle(fontSize: 20),
            ),
            if (isCharging) Text('~ $minutesLeft min remaining'),

            const SizedBox(height: 30),

            // energy, power, cost
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kFieldBg,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [
                    const Text('Energy'),
                    Text('${energy.toStringAsFixed(1)} kWh'),
                  ]),
                  const Column(children: [
                    Text('Power'),
                    Text('150 kW'),
                  ]),
                  Column(children: [
                    const Text('Est. Cost'),
                    Text('SAR ${cost.toStringAsFixed(2)}'),
                  ]),
                ],
              ),
            ),

            const Spacer(),

            // stop button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kCyan,
                  foregroundColor: Colors.black,
                ),
                onPressed: isCharging ? stopCharging : null,
                child: const Text('Stop Charging'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}