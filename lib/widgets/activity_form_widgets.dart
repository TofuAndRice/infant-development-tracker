import 'package:flutter/material.dart';

const activityFieldLabelStyle = TextStyle(
  color: Color(0xFF4B5870),
  fontSize: 13.5,
  fontWeight: FontWeight.w400,
  height: 1.2,
);

class ActivityFormSectionCard extends StatelessWidget {
  const ActivityFormSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF4B5870),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class DateTimePickerRow extends StatelessWidget {
  const DateTimePickerRow({
    super.key,
    required this.dateText,
    required this.timeText,
    required this.onDateTap,
    required this.onTimeTap,
  });

  final String dateText;
  final String timeText;
  final VoidCallback onDateTap;
  final VoidCallback onTimeTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PickerField(
            label: 'Date',
            value: dateText,
            icon: Icons.calendar_today_outlined,
            onTap: onDateTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PickerField(
            label: 'Time',
            value: timeText,
            icon: Icons.access_time,
            onTap: onTimeTap,
          ),
        ),
      ],
    );
  }
}

class SleepTimePickerRow extends StatelessWidget {
  const SleepTimePickerRow({
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
    return Row(
      children: [
        Expanded(
          child: PickerField(
            label: 'Fell asleep',
            value: startText,
            onTap: onStartTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PickerField(
            label: 'Woke up',
            value: endText,
            onTap: onEndTap,
          ),
        ),
      ],
    );
  }
}

class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.icon,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 15, color: const Color(0xFF6D788B)),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: activityFieldLabelStyle,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFC8D0DB)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

// tipuri de feeding/diaper
class LabeledChoiceWrap<T> extends StatelessWidget {
  const LabeledChoiceWrap({
    super.key,
    required this.label,
    required this.values,
    required this.selectedValue,
    required this.labelFor,
    required this.onSelected,
  });

  final String label;
  final List<T> values;
  final T selectedValue;
  final String Function(T value) labelFor;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: activityFieldLabelStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in values)
              ChoiceChip(
                label: Text(labelFor(value)),
                selected: selectedValue == value,
                showCheckmark: false,
                selectedColor: const Color(0xFFD3F8F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onSelected: (_) => onSelected(value),
              ),
          ],
        ),
      ],
    );
  }
}


// height weight cu unitate langa
class NumberInputRow extends StatelessWidget {
  const NumberInputRow({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: activityFieldLabelStyle),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              width: 100,
              child: TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: Color(0xFF8B96A8),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(suffix),
          ],
        ),
      ],
    );
  }
}

class DiaperSizeGuide extends StatelessWidget {
  const DiaperSizeGuide({super.key});

  @override
  Widget build(BuildContext context) {
    const lines = [
      'Size 1: suitable for babies weighing 2-5 kg',
      'Size 2: suitable for babies weighing 4-8 kg',
      'Size 3: suitable for babies weighing 7-18 kg',
      'Size 4: suitable for babies weighing 8-14 kg',
      'Size 5: suitable for babies weighing 11-18 kg',
      'Size 6: suitable for babies weighing 13-25+ kg',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Diaper size guide',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(line, style: const TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }
}
