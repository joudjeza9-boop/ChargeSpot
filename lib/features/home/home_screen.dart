
import 'package:flutter/material.dart';

// الألوان من ملف الـ Auth (نفس الثيم)
import '../auth/auth_screen.dart' show kCyan, kFieldBg, kBorder;

// ======================= Models =======================

class Station {
  final String name;
  final double distanceKm;
  final int available;
  final int total;
  final List<String> connectors;

  const Station({
    required this.name,
    required this.distanceKm,
    required this.available,
    required this.total,
    required this.connectors,
  });
}

// بيانات تجريبية. استبدلها بنداء الـ Backend
// (S11: Search Nearby Charging Stations)
const _demoStations = <Station>[
  Station(
    name: 'Riyadh Front Station',
    distanceKm: 1.2,
    available: 5,
    total: 7,
    connectors: ['CCS2', 'Type 2'],
  ),
  Station(
    name: 'KAFD Station',
    distanceKm: 2.4,
    available: 3,
    total: 6,
    connectors: ['CCS2'],
  ),
  Station(
    name: 'Granada Mall Station',
    distanceKm: 3.9,
    available: 0,
    total: 4,
    connectors: ['Type 2'],
  ),
];

class StationFilter {
  final Set<String> connectors;
  final bool availableOnly;

  const StationFilter({
    this.connectors = const <String>{},
    this.availableOnly = false,
  });

  bool get isActive => connectors.isNotEmpty || availableOnly;
}

// ======================= Home Screen =======================

class HomeScreen extends StatefulWidget {
  /// اسم المستخدم (من بيانات تسجيل الدخول)
  final String userName;

  /// ربط الأزرار مع باقي الشاشات (اختياري)
  final VoidCallback? onFindStations;
  final VoidCallback? onMyBookings;
  final VoidCallback? onMyUsage;
  final ValueChanged<Station>? onStationTap;

  const HomeScreen({
    super.key,
    this.userName = 'Norah',
    this.onFindStations,
    this.onMyBookings,
    this.onMyUsage,
    this.onStationTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _tabTitles = ['Home', 'Map', 'Bookings', 'Profile'];

  final _searchCtrl = TextEditingController();
  StationFilter _filter = const StationFilter();
  int _tab = 0;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  // البحث + الفلترة + الترتيب حسب الأقرب (S11 + S12)
  List<Station> get _stations {
    final q = _searchCtrl.text.trim().toLowerCase();
    final list = _demoStations.where((s) {
      if (q.isNotEmpty && !s.name.toLowerCase().contains(q)) return false;
      if (_filter.availableOnly && s.available == 0) return false;
      if (_filter.connectors.isNotEmpty &&
          !s.connectors.any(_filter.connectors.contains)) {
        return false;
      }
      return true;
    }).toList();
    list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return list;
  }

  void _soon(String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$what - coming soon')),
    );
  }

  Future<void> _openFilter() async {
    final result = await showModalBottomSheet<StationFilter>(
      context: context,
      backgroundColor: kFieldBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: kCyan),
        ),
        child: _FilterSheet(initial: _filter),
      ),
    );
    if (result != null) setState(() => _filter = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF06222B),
        selectedItemColor: kCyan,
        unselectedItemColor: Colors.white54,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined), label: 'Bookings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A3A47), Color(0xFF04141A)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _tab == 0
                  ? _buildHome()
                  : Center(child: Text('${_tabTitles[_tab]} - coming soon')),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHome() {
    final stations = _stations;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        // الترحيب بالمستخدم
        Row(
          children: [
            Flexible(
              child: Text(
                '$_greeting, ${widget.userName}',
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 6),
            const Text('\u{1F44B}', style: TextStyle(fontSize: 20)),
          ],
        ),
        const SizedBox(height: 16),

        // البحث عن المحطات + الفلتر
        _buildSearchBar(),
        const SizedBox(height: 16),

        // اختصارات: المحطات / الحجوزات / الاستخدام
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.ev_station_outlined,
                label: 'Find\nStations',
                onTap: widget.onFindStations ??
                    () => setState(() => _tab = 1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.calendar_month_outlined,
                label: 'My\nBookings',
                onTap: widget.onMyBookings ??
                    () => setState(() => _tab = 2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.bar_chart_rounded,
                label: 'My\nUsage',
                onTap: widget.onMyUsage ?? () => _soon('My Usage'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // أقرب المحطات
        _buildStationsCard(stations),
        const SizedBox(height: 16),

        // مكان صورة السيارة (استبدلها بصورة من الـ assets)
        const SizedBox(
          height: 90,
          child: Center(
            child: Icon(
              Icons.directions_car_filled_rounded,
              size: 80,
              color: Color(0x4022D3EE),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c),
        );

    return TextField(
      controller: _searchCtrl,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Search for a station or location...',
        hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
        prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 20),
        suffixIcon: IconButton(
          onPressed: _openFilter,
          icon: Badge(
            isLabelVisible: _filter.isActive,
            smallSize: 8,
            backgroundColor: kCyan,
            child: const Icon(Icons.tune, color: Colors.white70, size: 20),
          ),
        ),
        filled: true,
        fillColor: kFieldBg,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        enabledBorder: border(kBorder),
        focusedBorder: border(kCyan),
      ),
    );
  }

  Widget _buildStationsCard(List<Station> stations) {
    void open(Station s) {
      if (widget.onStationTap != null) {
        widget.onStationTap!(s);
      } else {
        _soon(s.name);
      }
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x6612333D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nearest Station',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (stations.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No stations match your search',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            )
          else
            _StationTile(
              station: stations.first,
              onTap: () => open(stations.first),
            ),
          if (stations.length > 1) ...[
            const Divider(color: kBorder, height: 24),
            const Text(
              'More nearby',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 6),
            for (final s in stations.skip(1))
              _StationTile(station: s, onTap: () => open(s)),
          ],
        ],
      ),
    );
  }
}

// ======================= Widgets =======================

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: kFieldBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: kCyan, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _StationTile extends StatelessWidget {
  final Station station;
  final VoidCallback onTap;

  const _StationTile({required this.station, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasFree = station.available > 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            // مكان صورة المحطة (استبدلها بـ Image.network / asset)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E70), Color(0xFF0A3A47)],
                ),
              ),
              child: const Icon(Icons.ev_station, color: kCyan),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${station.distanceKm.toStringAsFixed(1)} km  •  '
                    '${station.available} available',
                    style: TextStyle(
                      fontSize: 12,
                      color: hasFree ? Colors.white70 : Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

// ======================= Filter Sheet (S12) =======================

class _FilterSheet extends StatefulWidget {
  final StationFilter initial;

  const _FilterSheet({required this.initial});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  static const _allConnectors = ['CCS2', 'Type 2'];

  late final Set<String> _connectors = {...widget.initial.connectors};
  late bool _availableOnly = widget.initial.availableOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Stations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Connector type',
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final c in _allConnectors)
                FilterChip(
                  label: Text(c),
                  selected: _connectors.contains(c),
                  onSelected: (v) => setState(() {
                    if (v) {
                      _connectors.add(c);
                    } else {
                      _connectors.remove(c);
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Available now only'),
            value: _availableOnly,
            onChanged: (v) => setState(() => _availableOnly = v),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).pop(const StationFilter()),
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(
                    StationFilter(
                      connectors: _connectors,
                      availableOnly: _availableOnly,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kCyan,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
