import 'dart:async';

import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../models/activity.dart';
import '../utils/date_formatters.dart';
import 'activity_form_screen.dart';
import '../widgets/activity_card.dart';
import '../widgets/activity_filter_bar.dart';


class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key}); 

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  ActivityType? selectedFilter; 
  List<Activity> activities = []; 

  bool isLoading = true;
  String? loadingError; 

  
  @override
  void initState() {
    super.initState(); 
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    try {
      final loadedActivities = await DatabaseHelper.instance 
          .getActivities()
          .timeout(const Duration(seconds: 5)); 

      if (!mounted) { 
        return; 
      }

      setState(() {
        activities = loadedActivities;
        isLoading = false;
        loadingError = null;
      });
    } on TimeoutException {
      _showLoadingError(
        'Database loading took too long.',
      );
    } catch (_) {
      _showLoadingError(
        'Could not load activities.',
      );
    }
  }

  void _showLoadingError(String message) {
    if (!mounted) {
      return;
    }

    setState(() {
      activities = [];
      isLoading = false;
      loadingError = message;
    });
  }

  void _selectFilter(ActivityType? type) {
    setState(() {
      selectedFilter = type;
    });
  }

  Future<void> _openAddActivity() async {
    final initialType = selectedFilter ?? ActivityType.feeding; 
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => ActivityFormScreen(initialType: initialType),
      ),
    );
    
    if (saved == true) {
      await _loadActivities();
    }
  }

  Future<void> _openEditActivity(Activity activity) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => ActivityFormScreen(activity: activity),
      ),
    );

    if (changed == true) {
      await _loadActivities();
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleActivities = selectedFilter == null
        ? activities
        : activities
            .where((activity) => activity.type == selectedFilter)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Baby Logger'),
      ),
      body: Column(
        children: [
          ActivityFilterBar(
            selectedType: selectedFilter, 
            onSelected: _selectFilter, 
          ), 
          Expanded(
            child: _TimelineContent(
              isLoading: isLoading,
              errorMessage: loadingError,
              activities: visibleActivities, 
              onActivityTap: _openEditActivity, 
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddActivity,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TimelineContent extends StatelessWidget {
  const _TimelineContent({
    required this.isLoading,
    required this.errorMessage,
    required this.activities,
    required this.onActivityTap,
  }); 

  final bool isLoading;
  final String? errorMessage;
  final List<Activity> activities;
  final ValueChanged<Activity> onActivityTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return _TimelineErrorMessage(message: errorMessage!);
    }

    if (activities.isEmpty) {
      return const _EmptyTimelineMessage();
    }

    final timelineWidgets = <Widget>[]; 
    DateTime? currentDay; 

    for (final activity in activities) {
      if (!_isSameDay(currentDay, activity.dateTime)) {
        currentDay = activity.dateTime;
        timelineWidgets.add(_DateHeader(dateTime: activity.dateTime));
      }

      timelineWidgets.add(
        ActivityCard(
          activity: activity,
          onTap: () => onActivityTap(activity), 
        ),
      ); 
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14), 
      children: timelineWidgets,
    );
  }

  bool _isSameDay(DateTime? first, DateTime second) {
    if (first == null) {
      return false;
    }

    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({
    required this.dateTime,
  });

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 14, 0, 8),
      child: Text(
        formatTimelineHeader(dateTime),
        style: const TextStyle(
          color: Color(0xFF4B5870),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}


class _TimelineErrorMessage extends StatelessWidget {
  const _TimelineErrorMessage({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF8A3342),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}


class _EmptyTimelineMessage extends StatelessWidget {
  const _EmptyTimelineMessage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.assignment_outlined,
            color: Color(0xFFC9D0DA),
            size: 42,
          ),
          SizedBox(height: 14),
          Text(
            'No activities logged yet',
            style: TextStyle(
              color: Color(0xFF4B5870),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Tap the + button to add your first entry.',
            style: TextStyle(
              color: Color(0xFF8B96A8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
