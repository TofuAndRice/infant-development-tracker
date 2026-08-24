import 'dart:async';

import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/activity.dart';
import '../utils/date_formatters.dart';
import '../widgets/activity_detail_sections.dart';
import '../widgets/activity_form_widgets.dart';

class ActivityFormScreen extends StatefulWidget {
  const ActivityFormScreen({
    super.key,
    this.initialType,
    this.activity,
  });

  final ActivityType? initialType; 
  final Activity? activity; 

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  late ActivityType selectedType;
  late DateTime selectedDateTime;

  late DateTime sleepStartDateTime;
  late DateTime wakeUpDateTime;

  FeedingType selectedFeedingType = FeedingType.formula; 
  DiaperType selectedDiaperType = DiaperType.wet; 
  int selectedDiaperSize = 1;
  bool showDiaperGuide = false;

  String? formError; 

  final heightController = TextEditingController(); 
  final weightController = TextEditingController();
  final notesController = TextEditingController();

  bool get isEditing => widget.activity != null; 

  @override
  void initState() {
    super.initState();

    
    final activity = widget.activity;
    selectedType = activity?.type ?? widget.initialType ?? ActivityType.feeding;
    selectedDateTime = activity?.dateTime ?? DateTime.now();
    selectedFeedingType = activity?.feedingType ?? FeedingType.formula;
    selectedDiaperType = activity?.diaperType ?? DiaperType.wet; //
    selectedDiaperSize = activity?.diaperSize ?? 1;
    heightController.text = _initialNumberText(activity?.heightCm);
    weightController.text = _initialNumberText(activity?.weightKg);
    notesController.text = activity?.notes ?? '';

    sleepStartDateTime = activity?.sleepStartDateTime ?? selectedDateTime;
    wakeUpDateTime = activity?.wakeUpDateTime ??
        sleepStartDateTime.add(const Duration(hours: 1)); 
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    notesController.dispose();
    super.dispose();
  } 

  
  Future<void> _pickLogDate() async { 
    final picked = await _pickDatePart(selectedDateTime);
    if (picked == null) {
      return;
    }

    setState(() {
      selectedDateTime = picked; 

      if (selectedType == ActivityType.sleep) {
        sleepStartDateTime = _sameDateWithTime(
          selectedDateTime,
          sleepStartDateTime,
        ); // --
        wakeUpDateTime = _sameDateWithTime(selectedDateTime, wakeUpDateTime);
        _keepWakeUpAfterSleepStart();
      }
    });
  } 

  Future<void> _pickLogTime() async {
    final picked = await _pickTimePart(selectedDateTime);
    if (picked == null) {
      return;
    }

    setState(() {
      selectedDateTime = picked;
    });
  } 

  Future<void> _pickSleepStartTime() async {
    final picked = await _pickTimePart(sleepStartDateTime);
    if (picked == null) {
      return;
    }

    setState(() {
      sleepStartDateTime = _sameDateWithTime(selectedDateTime, picked); 
      _keepWakeUpAfterSleepStart(); 
    });
  } 

  Future<void> _pickWakeUpTime() async {
    final picked = await _pickTimePart(wakeUpDateTime);
    if (picked == null) {
      return;
    }

    setState(() {
      wakeUpDateTime = _sameDateWithTime(selectedDateTime, picked);
      _keepWakeUpAfterSleepStart();
    });
  } 

  Future<DateTime?> _pickDatePart(DateTime currentValue) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentValue,
      firstDate: DateTime(2020), 
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) {
      return null;
    } 

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      currentValue.hour,
      currentValue.minute,
    );
  } 

  Future<DateTime?> _pickTimePart(DateTime currentValue) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentValue),
    );

    if (pickedTime == null) {
      return null;
    }

    return DateTime(
      currentValue.year,
      currentValue.month,
      currentValue.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  } 

  void _keepWakeUpAfterSleepStart() {
    wakeUpDateTime = _sameDateWithTime(selectedDateTime, wakeUpDateTime);

    if (!wakeUpDateTime.isAfter(sleepStartDateTime)) {
      wakeUpDateTime = wakeUpDateTime.add(const Duration(days: 1));
    } 

  }

  void _selectType(ActivityType type) {
    if (selectedType == type) {
      return;
    } 

    setState(() {
      selectedType = type;
      formError = null; 

      if (selectedType == ActivityType.sleep) {
        sleepStartDateTime = selectedDateTime;
        wakeUpDateTime = selectedDateTime.add(const Duration(hours: 1));
      }
    });
  }


  
  Future<void> _saveActivity() async {
    final activity = _buildActivityFromForm();
    if (activity == null) {
      return;
    }

    try {
      if (isEditing) {
        await DatabaseHelper.instance
            .updateActivity(activity)
            .timeout(const Duration(seconds: 5)); 
      } else {
        await DatabaseHelper.instance
            .insertActivity(activity)
            .timeout(const Duration(seconds: 5)); 
      }
    } on TimeoutException {
      _setError('Saving took too long. Please restart the app and try again.');
      return;
    } catch (_) {
      _setError(
        'Could not save the activity. Please restart the app and try again.',
      );
      return;
    }

    if (!mounted) {
      return;
    } 

    Navigator.of(context).pop(true); 
  }

  Future<void> _deleteActivity() async {
    final activityId = widget.activity?.id; 
    if (activityId == null) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete activity?'),
          content: const Text(
            'This activity will be removed from the timeline.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await DatabaseHelper.instance.deleteActivity(activityId); 

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true); 
  }

  Activity? _buildActivityFromForm() {
    final notes = notesController.text.trim();  

    switch (selectedType) {
      case ActivityType.feeding:
        return Activity(
          id: widget.activity?.id,
          type: selectedType,
          dateTime: selectedDateTime,
          notes: notes.isEmpty ? null : notes,
          feedingType: selectedFeedingType,
        );
      case ActivityType.diaper:
        return Activity(
          id: widget.activity?.id,
          type: selectedType,
          dateTime: selectedDateTime,
          notes: notes.isEmpty ? null : notes,
          diaperType: selectedDiaperType,
          diaperSize: selectedDiaperSize,
        );
      case ActivityType.sleep:
        final sleepStart = _sameDateWithTime(
          selectedDateTime,
          sleepStartDateTime,
        );
        var wakeUp = _sameDateWithTime(selectedDateTime, wakeUpDateTime);

        if (!wakeUp.isAfter(sleepStart)) {
          wakeUp = wakeUp.add(const Duration(days: 1));
        }

        return Activity(
          id: widget.activity?.id,
          type: selectedType,
          dateTime: selectedDateTime,
          notes: notes.isEmpty ? null : notes,
          sleepStartDateTime: sleepStart,
          sleepDurationMinutes: wakeUp.difference(sleepStart).inMinutes, 
        );
      case ActivityType.height:
        final height = double.tryParse(heightController.text.trim()); 
        if (height == null || height <= 0) {
          _setError('Please enter a valid height in cm.');
          return null;
        }

        return Activity(
          id: widget.activity?.id,
          type: selectedType,
          dateTime: selectedDateTime,
          notes: notes.isEmpty ? null : notes,
          heightCm: height,
        );
      case ActivityType.weight:
        final weight = double.tryParse(weightController.text.trim());
        if (weight == null || weight <= 0) {
          _setError('Please enter a valid weight in kg.');
          return null;
        }

        return Activity(
          id: widget.activity?.id,
          type: selectedType,
          dateTime: selectedDateTime,
          notes: notes.isEmpty ? null : notes,
          weightKg: weight,
        );
    }
  }

  void _setError(String message) {
    setState(() {
      formError = message;
    });
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(isEditing ? 'Edit Activity' : 'Add Activity'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent, 
        onTap: () => FocusScope.of(context).unfocus(), 
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ActivityFormSectionCard(
              title: 'ACTIVITY TYPE',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final type in ActivityType.values)
                    ChoiceChip(
                      label: Text(type.label),
                      selected: selectedType == type,
                      showCheckmark: false,
                      selectedColor: const Color(0xFF1E5BFF),
                      labelStyle: TextStyle(
                        color: selectedType == type
                            ? Colors.white
                            : Colors.black87,
                      ),
                      onSelected: (_) => _selectType(type),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ActivityFormSectionCard(
              title: 'DATE & TIME',
              child: DateTimePickerRow(
                dateText: formatDate(selectedDateTime),
                timeText: formatTime(selectedDateTime),
                onDateTap: _pickLogDate,
                onTimeTap: _pickLogTime,
              ),
            ),
            const SizedBox(height: 12),
            ActivityFormSectionCard(
              title: 'DETAILS',
              child: _detailsSection(),
            ),
            const SizedBox(height: 12),
            ActivityFormSectionCard(
              title: 'NOTES (optional)',
              child: TextField(
                controller: notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Add any notes...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            if (formError != null) ...[
              const SizedBox(height: 12),
              Text(
                formError!,
                style: const TextStyle(
                  color: Color(0xFFB00020),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saveActivity,
                child: Text(isEditing ? 'Save Changes' : 'Save'),
              ),
            ),
            if (isEditing) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: _deleteActivity,
                child: const Text('Delete Activity'),
              ),
            ],
          ],
        ),
      ),
    );
  }

 
  Widget _detailsSection() {
    switch (selectedType) {
      case ActivityType.feeding:
        return FeedingDetailsSection(
          selectedFeedingType: selectedFeedingType,
          onSelected: (value) {
            setState(() {
              selectedFeedingType = value;
            });
          },
        );
      case ActivityType.diaper:
        return DiaperDetailsSection(
          selectedDiaperType: selectedDiaperType,
          selectedDiaperSize: selectedDiaperSize,
          showDiaperGuide: showDiaperGuide,
          onDiaperTypeSelected: (value) {
            setState(() {
              selectedDiaperType = value;
            });
          },
          onDiaperSizeSelected: (value) {
            setState(() {
              selectedDiaperSize = value;
            });
          },
          onToggleGuide: () {
            setState(() {
              showDiaperGuide = !showDiaperGuide;
            });
          },
        );
      case ActivityType.sleep:
        return SleepDetailsSection(
          startText: formatTime(sleepStartDateTime),
          endText: formatTime(wakeUpDateTime), 
          onStartTap: _pickSleepStartTime,
          onEndTap: _pickWakeUpTime,
        );
      case ActivityType.height:
        return MeasurementDetailsSection(
          controller: heightController,
          label: 'Height',
          hintText: 'e.g. 62',
          suffix: 'cm',
        );
      case ActivityType.weight:
        return MeasurementDetailsSection(
          controller: weightController,
          label: 'Weight',
          hintText: 'e.g. 6.4',
          suffix: 'kg',
        );
    }
  }

  DateTime _sameDateWithTime(DateTime date, DateTime time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  } 

  String _initialNumberText(double? value) {
    if (value == null) {
      return '';
    }

    if (value == value.roundToDouble()) { 
      return value.toInt().toString(); 
    }

    return value.toString();
  } //
}
