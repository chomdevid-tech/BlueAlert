import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../config/app_constants.dart';
import '../models/security_alert.dart';

class FirebaseAlertService {
  FirebaseAlertService({FirebaseDatabase? firebaseDatabase})
    : _alertsReference = (firebaseDatabase ?? FirebaseDatabase.instance).ref(
        AppConstants.alertsPath,
      );

  final DatabaseReference _alertsReference;

  Stream<List<SecurityAlert>> watchAlerts() {
    return _alertsReference.onValue.map((DatabaseEvent event) {
      final Object? firebaseValue = event.snapshot.value;

      if (firebaseValue == null) {
        return <SecurityAlert>[];
      }

      if (firebaseValue is! Map) {
        throw const FormatException(
          'The alerts path must contain a JSON object.',
        );
      }

      final List<SecurityAlert> alerts = <SecurityAlert>[];

      for (final MapEntry<dynamic, dynamic> entry in firebaseValue.entries) {
        if (entry.value is! Map) {
          continue;
        }

        try {
          final Map<String, dynamic> alertJson = _convertMap(
            entry.value as Map,
          );

          if (alertJson['alertId'] == null) {
            alertJson['alertId'] = entry.key.toString();
          }

          alerts.add(SecurityAlert.fromJson(alertJson));
        } catch (error) {
          debugPrint('Invalid Firebase alert ${entry.key}: $error');
        }
      }

      alerts.sort((SecurityAlert firstAlert, SecurityAlert secondAlert) {
        return secondAlert.timestamp.compareTo(firstAlert.timestamp);
      });

      return alerts;
    });
  }

  Future<void> updateAlertStatus(String alertId, String newStatus) async {
    final String cleanedAlertId = alertId.trim();
    final String cleanedStatus = newStatus.trim().toLowerCase();

    if (cleanedAlertId.isEmpty) {
      throw ArgumentError('alertId cannot be empty.');
    }

    if (!AppConstants.allowedStatuses.contains(cleanedStatus)) {
      throw ArgumentError('Invalid status: $cleanedStatus');
    }

    await _alertsReference
        .child(cleanedAlertId)
        .child('status')
        .set(cleanedStatus);
  }

  static Map<String, dynamic> _convertMap(Map<dynamic, dynamic> originalMap) {
    final Map<String, dynamic> convertedMap = <String, dynamic>{};

    for (final MapEntry<dynamic, dynamic> entry in originalMap.entries) {
      convertedMap[entry.key.toString()] = _convertValue(entry.value);
    }

    return convertedMap;
  }

  static dynamic _convertValue(dynamic value) {
    if (value is Map) {
      return _convertMap(value);
    }

    if (value is List) {
      return value.map<dynamic>(_convertValue).toList();
    }

    return value;
  }
}
