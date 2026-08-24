import 'package:flutter/material.dart';

import '../models/activity.dart';

class ActivityFilterBar extends StatelessWidget {
  const ActivityFilterBar({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  final ActivityType? selectedType; 
  final ValueChanged<ActivityType?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('All'),
              selected: selectedType == null,
              showCheckmark: false,
              selectedColor: const Color(0xFF1E5BFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              labelStyle: TextStyle(
                color: selectedType == null ? Colors.white : Colors.black87,
              ),
              onSelected: (_) => onSelected(null),
            ),
          ),
          for (final type in ActivityType.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(type.label),
                selected: selectedType == type,
                showCheckmark: false,
                selectedColor: const Color(0xFF1E5BFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                labelStyle: TextStyle(
                  color:
                      selectedType == type ? Colors.white : Colors.black87,
                ),
                onSelected: (_) => onSelected(type),
              ),
            ),
        ],
      ),
    );
  }
}
