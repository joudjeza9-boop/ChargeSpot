import 'package:flutter/material.dart';
import '../auth/auth_screen.dart';

// Screen 11 - Charging History
class ChargingHistoryScreen extends StatelessWidget {
  const ChargingHistoryScreen({super.key});

  // old charging sessions (sample data for now)
  final List<Map<String, String>> sessions = const [
    {'station': 'KAFD Station', 'date': 'Nov 19', 'energy': '32.1', 'cost': '24.10'},
    {'station': 'Riyadh Front Station', 'date': 'Nov 17', 'energy': '18.7', 'cost': '14.00'},
    {'station': 'Granada Mall Station', 'date': 'Nov 6', 'energy': '41.2', 'cost': '31.50'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF04141A),
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: const Color(0xFF04141A),
      ),
      body: sessions.isEmpty
          ? const Center(child: Text('No charging sessions yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              itemBuilder: (context, i) {
                final s = sessions[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: kFieldBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.ev_station, color: kCyan, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s['station']!,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${s['date']} • ${s['energy']} kWh'),
                          ],
                        ),
                      ),
                      Text('SAR ${s['cost']}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}