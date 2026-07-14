class SecurityAlert {
  final String alertId;
  final String title;
  final String description;
  final String attackType;
  final String severity;
  final String status;
  final String vmName;
  final String sourceIp;
  final String destinationIp;
  final DateTime timestamp;
  final Map<String, dynamic> rawLog;

  const SecurityAlert({
    required this.alertId,
    required this.title,
    required this.description,
    required this.attackType,
    required this.severity,
    required this.status,
    required this.vmName,
    required this.sourceIp,
    required this.destinationIp,
    required this.timestamp,
    required this.rawLog,
  });

  factory SecurityAlert.fromJson(Map<String, dynamic> json) {
    final String timestampText = _readRequiredString(json, 'timestamp');

    final DateTime? parsedTimestamp = DateTime.tryParse(timestampText);

    if (parsedTimestamp == null) {
      throw const FormatException('timestamp is not a valid date.');
    }

    final dynamic rawLogValue = json['rawLog'];

    if (rawLogValue is! Map) {
      throw const FormatException('rawLog must be a JSON object.');
    }

    return SecurityAlert(
      alertId: _readRequiredString(json, 'alertId'),
      title: _readRequiredString(json, 'title'),
      description: _readRequiredString(json, 'description'),
      attackType: _readRequiredString(json, 'attackType'),
      severity: _readRequiredString(json, 'severity').toLowerCase(),
      status: _readRequiredString(json, 'status').toLowerCase(),
      vmName: _readRequiredString(json, 'vmName'),
      sourceIp: _readRequiredString(json, 'sourceIp'),
      destinationIp: _readRequiredString(json, 'destinationIp'),
      timestamp: parsedTimestamp,
      rawLog: Map<String, dynamic>.from(rawLogValue),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'alertId': alertId,
      'title': title,
      'description': description,
      'attackType': attackType,
      'severity': severity,
      'status': status,
      'vmName': vmName,
      'sourceIp': sourceIp,
      'destinationIp': destinationIp,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'rawLog': Map<String, dynamic>.from(rawLog),
    };
  }

  SecurityAlert copyWith({
    String? alertId,
    String? title,
    String? description,
    String? attackType,
    String? severity,
    String? status,
    String? vmName,
    String? sourceIp,
    String? destinationIp,
    DateTime? timestamp,
    Map<String, dynamic>? rawLog,
  }) {
    return SecurityAlert(
      alertId: alertId ?? this.alertId,
      title: title ?? this.title,
      description: description ?? this.description,
      attackType: attackType ?? this.attackType,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      vmName: vmName ?? this.vmName,
      sourceIp: sourceIp ?? this.sourceIp,
      destinationIp: destinationIp ?? this.destinationIp,
      timestamp: timestamp ?? this.timestamp,
      rawLog: rawLog ?? Map<String, dynamic>.from(this.rawLog),
    );
  }

  static String _readRequiredString(
    Map<String, dynamic> json,
    String fieldName,
  ) {
    final dynamic fieldValue = json[fieldName];

    if (fieldValue is! String) {
      throw FormatException('$fieldName must be a string.');
    }

    final String cleanedValue = fieldValue.trim();

    if (cleanedValue.isEmpty) {
      throw FormatException('$fieldName cannot be empty.');
    }

    return cleanedValue;
  }
}
