import 'package:flutter/material.dart';

import '../models/security_alert.dart';
import '../utils/date_formatter.dart';
import 'severity_badge.dart';
import 'status_badge.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({
    required this.alert,
    required this.onDetails,
    this.onInvestigate,
    this.onResolve,
    this.isUpdating = false,
    super.key,
  });

  final SecurityAlert alert;
  final VoidCallback onDetails;
  final VoidCallback? onInvestigate;
  final VoidCallback? onResolve;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD4D4D4)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  alert.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SeverityBadge(severity: alert.severity),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              StatusBadge(status: alert.status),
              Chip(label: Text(alert.vmName)),
              Chip(label: Text(alert.attackType)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Source IP: ${alert.sourceIp}'),
          const SizedBox(height: 4),
          Text(
            DateFormatter.format(alert.timestamp),
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          if (isUpdating) ...<Widget>[
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              OutlinedButton(
                onPressed: isUpdating ? null : onDetails,
                child: const Text('Details'),
              ),
              if (onInvestigate != null)
                OutlinedButton(
                  onPressed: isUpdating ? null : onInvestigate,
                  child: const Text('Investigate'),
                ),
              if (onResolve != null)
                FilledButton(
                  onPressed: isUpdating ? null : onResolve,
                  child: const Text('Resolve'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
