enum ActivityType {
  feeding,
  diaper,
  sleep,
  height,
  weight,
}

enum FeedingType {
  formula,
  natural,
  bottle,
}

enum DiaperType {
  wet,
  dirty,
  mixed,
}

class Activity {
  const Activity({
    this.id,
    required this.type,
    required this.dateTime,
    this.notes,
    this.feedingType,
    this.diaperType,
    this.diaperSize,
    this.heightCm,
    this.weightKg,
    this.sleepStartDateTime,
    this.sleepDurationMinutes,
  });

  final int? id;
  final ActivityType type;
  final DateTime dateTime;
  final String? notes;

  final FeedingType? feedingType;

  final DiaperType? diaperType;
  final int? diaperSize;

  final double? heightCm;
  final double? weightKg;

  final DateTime? sleepStartDateTime;
  final int? sleepDurationMinutes;

  DateTime? get wakeUpDateTime {
    final sleepStart = sleepStartDateTime ?? dateTime;

    if (sleepDurationMinutes == null) {
      return null;
    }

    return sleepStart.add(Duration(minutes: sleepDurationMinutes!)); //
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'type': type.name,
      'date_time': dateTime.millisecondsSinceEpoch,
      'notes': notes,
      'feeding_type': feedingType?.name,
      'diaper_type': diaperType?.name,
      'diaper_size': diaperSize,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'sleep_start_time': sleepStartDateTime?.millisecondsSinceEpoch,
      'sleep_duration_minutes': sleepDurationMinutes,
    };
  }

  factory Activity.fromMap(Map<String, Object?> map) {
    return Activity(
      id: map['id'] as int?,
      type: ActivityType.values.byName(map['type'] as String),
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['date_time'] as int),
      notes: map['notes'] as String?,
      feedingType: _feedingTypeFromName(map['feeding_type'] as String?),
      diaperType: _diaperTypeFromName(map['diaper_type'] as String?),
      diaperSize: map['diaper_size'] as int?,
      heightCm: (map['height_cm'] as num?)?.toDouble(),
      weightKg: (map['weight_kg'] as num?)?.toDouble(),
      sleepStartDateTime: _dateTimeFromMilliseconds(map['sleep_start_time']),
      sleepDurationMinutes: map['sleep_duration_minutes'] as int?,
    );
  }
}

// din DB in date reale
DateTime? _dateTimeFromMilliseconds(Object? value) {
  if (value == null) {
    return null;
  }

  return DateTime.fromMillisecondsSinceEpoch(value as int);
}

// din nume in date reale, feeding type
FeedingType? _feedingTypeFromName(String? name) {
  if (name == null) {
    return null;
  }

  if (name == 'mixed') {
    return FeedingType.bottle;
  }

  return FeedingType.values.byName(name); 
}

DiaperType? _diaperTypeFromName(String? name) {
  if (name == null) {
    return null;
  }

  return DiaperType.values.byName(name);
}

extension ActivityTypeLabels on ActivityType {
  String get label {
    switch (this) {
      case ActivityType.feeding:
        return 'Feeding';
      case ActivityType.diaper:
        return 'Diaper';
      case ActivityType.sleep:
        return 'Sleep';
      case ActivityType.height:
        return 'Height';
      case ActivityType.weight:
        return 'Weight';
    }
  }
}

extension FeedingTypeLabels on FeedingType {
  String get label {
    switch (this) {
      case FeedingType.formula:
        return 'Formula';
      case FeedingType.natural:
        return 'Natural';
      case FeedingType.bottle:
        return 'Bottle';
    }
  }
}

extension DiaperTypeLabels on DiaperType {
  String get label {
    switch (this) {
      case DiaperType.wet:
        return 'Wet';
      case DiaperType.dirty:
        return 'Dirty';
      case DiaperType.mixed:
        return 'Mixed';
    }
  }
}
