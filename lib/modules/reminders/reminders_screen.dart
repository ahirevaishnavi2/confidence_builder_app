import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../services/notification_service.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _isEnabled = false;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 19, minute: 0); // Default 7 PM
  bool _isDaily = true;
  List<bool> _selectedDays = List.generate(7, (index) => true);
  final List<String> _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isEnabled = prefs.getBool('reminders_enabled') ?? false;
      final hour = prefs.getInt('reminder_hour') ?? 19;
      final minute = prefs.getInt('reminder_minute') ?? 0;
      _selectedTime = TimeOfDay(hour: hour, minute: minute);
      _isDaily = prefs.getBool('reminder_is_daily') ?? true;
      
      final daysString = prefs.getStringList('reminder_days');
      if (daysString != null) {
        _selectedDays = daysString.map((s) => s == 'true').toList();
      }
    });
  }

  Future<void> _saveSettings() async {
    // Request notification permission for Android 13+
    if (_isEnabled) {
      final status = await Permission.notification.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⚠️ Notification permission is required to send reminders.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() => _isEnabled = false);
        return;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminders_enabled', _isEnabled);
    await prefs.setInt('reminder_hour', _selectedTime.hour);
    await prefs.setInt('reminder_minute', _selectedTime.minute);
    await prefs.setBool('reminder_is_daily', _isDaily);
    await prefs.setStringList('reminder_days', _selectedDays.map((b) => b.toString()).toList());

    _updateNotifications();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Reminders updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _updateNotifications() {
    final notificationService = NotificationService();
    notificationService.cancelAll();

    if (_isEnabled) {
      if (_isDaily) {
        notificationService.scheduleDailyNotification(
          id: 100,
          title: 'Time to practice! 🎤',
          body: 'Don\'t break your streak 🔥 Keep building your confidence.',
          hour: _selectedTime.hour,
          minute: _selectedTime.minute,
        );
      } else {
        List<int> activeDays = [];
        for (int i = 0; i < 7; i++) {
          if (_selectedDays[i]) {
            // weekDay in timezone/dart is 1 (Mon) to 7 (Sun)
            activeDays.add(i + 1);
          }
        }
        
        if (activeDays.isNotEmpty) {
          notificationService.scheduleWeeklyNotification(
            id: 200,
            title: 'Time to practice! 🎤',
            body: 'Don\'t break your streak 🔥 Keep building your confidence.',
            hour: _selectedTime.hour,
            minute: _selectedTime.minute,
            days: activeDays,
          );
        }
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Reminders'),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple.shade50, Colors.purple.shade50],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enable/Disable Switch
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                child: SwitchListTile(
                  title: const Text(
                    'Enable Reminders',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: const Text('Get notified when it\'s time to practice'),
                  value: _isEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _isEnabled = value;
                    });
                  },
                  activeColor: Colors.deepPurple,
                ),
              ),
              
              const SizedBox(height: 20),
              
              if (_isEnabled) ...[
                // Time Selection
                const Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 8),
                  child: Text(
                    'Preferred Time',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.deepPurple),
                    title: Text(
                      _selectedTime.format(context),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _selectTime(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade700,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Change'),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Schedule Selection
                const Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 8),
                  child: Text(
                    'Schedule',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: Column(
                    children: [
                      RadioListTile<bool>(
                        title: const Text('Daily'),
                        subtitle: const Text('Remind me every day'),
                        value: true,
                        groupValue: _isDaily,
                        onChanged: (val) => setState(() => _isDaily = val!),
                        activeColor: Colors.deepPurple,
                      ),
                      RadioListTile<bool>(
                        title: const Text('Specific Days'),
                        subtitle: const Text('Choose which days to practice'),
                        value: false,
                        groupValue: _isDaily,
                        onChanged: (val) => setState(() => _isDaily = val!),
                        activeColor: Colors.deepPurple,
                      ),
                      
                      if (!_isDaily)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          child: Wrap(
                            spacing: 8,
                            children: List.generate(7, (index) {
                              return FilterChip(
                                label: Text(_dayNames[index]),
                                selected: _selectedDays[index],
                                onSelected: (bool selected) {
                                  setState(() {
                                    _selectedDays[index] = selected;
                                  });
                                },
                                selectedColor: Colors.deepPurple.shade100,
                                checkmarkColor: Colors.deepPurple,
                                labelStyle: TextStyle(
                                  color: _selectedDays[index] ? Colors.deepPurple : Colors.black87,
                                  fontWeight: _selectedDays[index] ? FontWeight.bold : FontWeight.normal,
                                ),
                              );
                            }),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 40),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                  ),
                  child: const Text(
                    'SAVE SETTINGS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              
              if (_isEnabled)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      NotificationService().showInstantNotification(
                        title: 'Test Notification 🔔',
                        body: 'If you see this, notifications are working perfectly!',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Test notification sent! Check your tray.')),
                      );
                    },
                    icon: const Icon(Icons.notification_important),
                    label: const Text('SEND TEST NOTIFICATION'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      side: const BorderSide(color: Colors.deepPurple),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              
              const SizedBox(height: 20),
              
              const Center(
                child: Text(
                  'Consistency is the key to confidence! 🚀',
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
