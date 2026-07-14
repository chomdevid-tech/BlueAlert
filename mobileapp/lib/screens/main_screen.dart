import 'package:flutter/material.dart';

import '../data/alert_repository.dart';
import '../models/security_alert.dart';
import 'all_alerts_screen.dart';
import 'dashboard_screen.dart';
import 'investigating_screen.dart';
import 'resolved_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({required this.alertRepository, super.key});

  final AlertRepository alertRepository;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedPageIndex = 0;

  late final Stream<List<SecurityAlert>> alertsStream;

  @override
  void initState() {
    super.initState();

    alertsStream = widget.alertRepository.watchAlerts().asBroadcastStream();
  }

  void openPage(int pageIndex) {
    setState(() {
      selectedPageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      DashboardScreen(
        alertRepository: widget.alertRepository,
        alertsStream: alertsStream,
        onOpenPage: openPage,
      ),
      AllAlertsScreen(
        alertRepository: widget.alertRepository,
        alertsStream: alertsStream,
      ),
      InvestigatingScreen(
        alertRepository: widget.alertRepository,
        alertsStream: alertsStream,
      ),
      ResolvedScreen(
        alertRepository: widget.alertRepository,
        alertsStream: alertsStream,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedPageIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPageIndex,
        onDestinationSelected: openPage,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_amber_outlined),
            selectedIcon: Icon(Icons.warning),
            label: 'All Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Investigating',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Resolved',
          ),
        ],
      ),
    );
  }
}
