import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyStreakCount = 'streak_count';
  static const String _keyLastLoginDate = 'last_login_date';
  static const String _keyTodayProgress = 'today_progress';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_keyIsLoggedIn, value);
  }

  bool get isLoggedIn {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<void> saveUser(String name, String email) async {
    await _prefs.setString(_keyUserName, name);
    await _prefs.setString(_keyUserEmail, email);
  }

  String get userName {
    return _prefs.getString(_keyUserName) ?? 'User';
  }

  String get userEmail {
    return _prefs.getString(_keyUserEmail) ?? 'user@example.com';
  }

  Future<int> updateStreak() async {
    final lastDateStr = _prefs.getString(_keyLastLoginDate);
    DateTime? lastDate;

    if (lastDateStr != null) {
      try {
        lastDate = DateTime.parse(lastDateStr);
      } catch (e) {
        lastDate = null;
      }
    }

    final today = DateTime.now();
    int currentStreak = _prefs.getInt(_keyStreakCount) ?? 0;

    if (lastDate == null) {
      currentStreak = 1;
    } else if (lastDate.year == today.year &&
        lastDate.month == today.month &&
        lastDate.day == today.day) {
      return currentStreak;
    } else if (lastDate.year == today.year &&
        lastDate.month == today.month &&
        lastDate.day == today.day - 1) {
      currentStreak++;
    } else {
      currentStreak = 1;
    }

    await _prefs.setInt(_keyStreakCount, currentStreak);
    await _prefs.setString(_keyLastLoginDate, today.toIso8601String());

    return currentStreak;
  }

  int get streakCount {
    return _prefs.getInt(_keyStreakCount) ?? 0;
  }

  Future<void> updateProgress(int percentage) async {
    await _prefs.setInt(_keyTodayProgress, percentage);
  }

  int get todayProgress {
    return _prefs.getInt(_keyTodayProgress) ?? 0;
  }

  Future<void> logout() async {
    await _prefs.setBool(_keyIsLoggedIn, false);
  }

  Future<void> clearAllData() async {
    await _prefs.clear();
  }
}
