import 'package:flutter/material.dart';

import '../models/activity.dart';
import 'activity_form_widgets.dart';

class FeedingDetailsSection extends StatelessWidget {
  const FeedingDetailsSection({
    super.key,
    required this.selectedFeedingType,
    required this.onSelected,
  });

  final FeedingType selectedFeedingType; 
  final ValueChanged<FeedingType> onSelected; 

  @override
  Widget build(BuildContext context) {
    return LabeledChoiceWrap<FeedingType>(
      label: 'Feeding Type',
      values: FeedingType.values,
      selectedValue: selectedFeedingType,
      labelFor: (value) => value.label, 
      onSelected: onSelected,
    );
  }
}

class DiaperDetailsSection extends StatelessWidget {
  const DiaperDetailsSection({
    super.key,
    required this.selectedDiaperType,
    required this.selectedDiaperSize,
    required this.showDiaperGuide,
    required this.onDiaperTypeSelected,
    required this.onDiaperSizeSelected,
    required this.onToggleGuide,
  });

  final DiaperType selectedDiaperType;
  final int selectedDiaperSize;
  final bool showDiaperGuide;
  final ValueChanged<DiaperType> onDiaperTypeSelected;
  final ValueChanged<int> onDiaperSizeSelected;
  final VoidCallback onToggleGuide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledChoiceWrap<DiaperType>(
          label: 'Diaper Type',
          values: DiaperType.values,
          selectedValue: selectedDiaperType,
          labelFor: (value) => value.label,
          onSelected: onDiaperTypeSelected,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const Text('Diaper Size', style: activityFieldLabelStyle),
            const SizedBox(width: 6),
            InkWell( 
              borderRadius: BorderRadius.circular(10),
              onTap: onToggleGuide,
              child: const CircleAvatar(
                radius: 10,
                backgroundColor: Color(0xFFDCE3EC),
                child: Text('?', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var size = 1; size <= 6; size++)
              ChoiceChip(
                label: Text(size.toString()),
                selected: selectedDiaperSize == size,
                showCheckmark: false,
                selectedColor: const Color(0xFFD3F8F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onSelected: (_) => onDiaperSizeSelected(size),
              ),
          ],
        ),
        if (showDiaperGuide) ...[
          const SizedBox(height: 12),
          const DiaperSizeGuide(),
        ],
      ],
    );
  }
}

class SleepDetailsSection extends StatelessWidget {
  const SleepDetailsSection({
    super.key,
    required this.startText,
    required this.endText,
    required this.onStartTap,
    required this.onEndTap,
  });

  final String startText;
  final String endText;
  
  final VoidCallback onStartTap;
  final VoidCallback onEndTap; 

  @override
  Widget build(BuildContext context) {
    return SleepTimePickerRow(
      startText: startText,
      endText: endText,
      onStartTap: onStartTap,
      onEndTap: onEndTap,
    );
  }
}

class MeasurementDetailsSection extends StatelessWidget {
  const MeasurementDetailsSection({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.suffix,
  });

  final TextEditingController controller; 
  final String label;
  final String hintText;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return NumberInputRow(
      controller: controller,
      label: label,
      hintText: hintText,
      suffix: suffix,
    );
  }
}
