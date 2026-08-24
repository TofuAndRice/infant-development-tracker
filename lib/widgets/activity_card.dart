import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../utils/date_formatters.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
    this.onTap,
  });

  final Activity activity;
  final VoidCallback? onTap; 

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1, 
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile( 
        contentPadding: const EdgeInsets.symmetric( 
          horizontal: 14,
          vertical: 8,
        ),
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _backgroundColor,
          child: Icon(
            _icon,
            color: _iconColor,
            size: 22,
          ), 
        ),
        title: Text(
          activity.type.label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          _detailsText,
          style: const TextStyle(
            color: Color(0xFF4B5870),
            fontSize: 12,
          ),
        ),
        trailing: Row( 
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatTime(activity.dateTime),
              style: const TextStyle(
                color: Color(0xFF7B8495),
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFC2C8D2),
            ),
          ],
        ),
      ),
    );
  }

  String get _detailsText {
    switch (activity.type) {
      case ActivityType.feeding:
        return activity.feedingType?.label ?? 'Feeding';
      case ActivityType.diaper:
        final type = activity.diaperType?.label ?? 'Diaper';
        final size = activity.diaperSize;
        return size == null ? type : '$type - Size $size';
      case ActivityType.sleep:
        final minutes = activity.sleepDurationMinutes ?? 0;
        return 'Duration: ${_durationText(minutes)}';
      case ActivityType.height:
        return '${_numberText(activity.heightCm)} cm';
      case ActivityType.weight:
        return '${_numberText(activity.weightKg)} kg';
    }
  }

  IconData get _icon {
    switch (activity.type) {
      case ActivityType.feeding:
        return Icons.local_drink_outlined;
      case ActivityType.diaper:
        return Icons.water_drop_outlined;
      case ActivityType.sleep:
        return Icons.nightlight_round;
      case ActivityType.height:
        return Icons.straighten;
      case ActivityType.weight:
        return Icons.monitor_weight_outlined;
    }
  }

  Color get _backgroundColor {
    switch (activity.type) {
      case ActivityType.feeding:
        return const Color(0xFFFFE1EC);
      case ActivityType.diaper:
        return const Color(0xFFC9F6EE);
      case ActivityType.sleep:
        return const Color(0xFFE0E5FF);
      case ActivityType.height:
        return const Color(0xFFD6F8DF);
      case ActivityType.weight:
        return const Color(0xFFF1D9FF);
    }
  }

  Color get _iconColor {
    switch (activity.type) {
      case ActivityType.feeding:
        return const Color(0xFFE63E7B);
      case ActivityType.diaper:
        return const Color(0xFF00A995);
      case ActivityType.sleep:
        return const Color(0xFF4E5BFF);
      case ActivityType.height:
        return const Color(0xFF20B45B);
      case ActivityType.weight:
        return const Color(0xFF9C39F5);
    }
  }

  String _durationText(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours == 0) {
      return '${minutes}min';
    }

    if (minutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${minutes}min';
  }

  String _numberText(double? value) {
    if (value == null) {
      return '-';
    }

    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }
}
