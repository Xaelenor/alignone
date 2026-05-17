import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    _loadReminderTime();
  }

  void _loadReminderTime() async {
    final time = await NotificationService().getReminderTime();
    if (mounted) setState(() => _reminderTime = time);
  }

  void _selectReminderTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (newTime != null) {
      await NotificationService().scheduleDailyReminder(newTime);
      setState(() => _reminderTime = newTime);
    }
  }

  void _cancelReminder() async {
    await NotificationService().cancelReminders();
    setState(() => _reminderTime = null);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Daily Reminder'),
            subtitle: Text(
              _reminderTime != null
                  ? _reminderTime!.format(context)
                  : 'Not set',
            ),
            trailing: _reminderTime != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _cancelReminder,
                  )
                : null,
            onTap: _selectReminderTime,
          ),
          const Divider(),
          ListTile(
            title: const Text('Edit Life Areas'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigation to Life Areas edit screen could go here
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await authProvider.signOut();
            },
          ),
        ],
      ),
    );
  }
}
