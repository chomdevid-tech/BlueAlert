import 'package:flutter/material.dart';

import '../data/alert_repository.dart';
import '../models/security_alert.dart';
import '../widgets/alert_card.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({required this.alertRepository, super.key});

  final AlertRepository alertRepository;

  @override
  State<DashboardScreen> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final Stream<List<SecurityAlert>> alertsStream;

  @override
  void initState() {
    super.initState();

    alertsStream = widget.alertRepository.watchAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'BlueAlert Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Firebase real-time security alerts',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<SecurityAlert>>(
        stream: alertsStream,
        builder:
            (
              BuildContext context,
              AsyncSnapshot<List<SecurityAlert>> snapshot,
            ) {
              if (snapshot.hasError) {
                return const ErrorView(
                  message: 'Could not load Firebase alerts.',
                );
              }

              if (!snapshot.hasData) {
                return const LoadingView();
              }

              final List<SecurityAlert> alerts = snapshot.data!;

              final int criticalAlertCount = alerts
                  .where((SecurityAlert alert) => alert.severity == 'critical')
                  .length;

              final int highAlertCount = alerts
                  .where((SecurityAlert alert) => alert.severity == 'high')
                  .length;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  DashboardStatCard(
                    title: 'Total Firebase Alerts',
                    value: alerts.length,
                    icon: Icons.security,
                  ),
                  const SizedBox(height: 12),
                  DashboardStatCard(
                    title: 'Critical Alerts',
                    value: criticalAlertCount,
                    icon: Icons.dangerous_outlined,
                  ),
                  const SizedBox(height: 12),
                  DashboardStatCard(
                    title: 'High Alerts',
                    value: highAlertCount,
                    icon: Icons.warning_amber,
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'Received Security Alerts',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Alerts received from Firebase using StreamBuilder.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  if (alerts.isEmpty)
                    const SizedBox(
                      height: 250,
                      child: EmptyView(
                        message: 'No Firebase alerts were found.',
                      ),
                    )
                  else
                    ...alerts.map((SecurityAlert alert) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AlertCard(alert: alert),
                      );
                    }),
                ],
              );
            },
      ),
    );
  }
}
