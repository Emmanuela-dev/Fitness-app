import 'package:flutter/material.dart';
import '../models/models.dart';

class FitnessProvider with ChangeNotifier {
  // Auth State
  bool _isLoggedIn = false;
  bool _hasProfile = false;

  // User Profile
  UserProfile? _userProfile;

  // Data
  List<Exercise> _exercises = [];
  List<BodyStats> _bodyStats = [];

  // Goals
  double _dailyCalorieGoal = 500.0;
  int _dailyExerciseMinutesGoal = 30;

  // Theme
  bool _isDarkMode = true;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get hasProfile => _hasProfile;
  bool get isDarkMode => _isDarkMode;
  UserProfile? get userProfile => _userProfile;
  List<Exercise> get exercises => [..._exercises];
  List<BodyStats> get bodyStats => [..._bodyStats];

  double get dailyCalorieGoal => _dailyCalorieGoal;
  int get dailyExerciseMinutesGoal => _dailyExerciseMinutesGoal;

  // Auth Methods
  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void setHasProfile(bool value) {
    _hasProfile = value;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _hasProfile = false;
    _userProfile = null;
    notifyListeners();
  }

  // Theme Methods
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // User Profile Methods
  void saveUserProfile(UserProfile profile) {
    _userProfile = profile;
    _hasProfile = true;
    _isLoggedIn = true;
    notifyListeners();
  }

  void updateUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void updateWeight(double weight) {
    if (_userProfile != null) {
      _userProfile = UserProfile(
        id: _userProfile!.id,
        name: _userProfile!.name,
        age: _userProfile!.age,
        gender: _userProfile!.gender,
        weight: weight,
        height: _userProfile!.height,
        fitnessGoal: _userProfile!.fitnessGoal,
        createdAt: _userProfile!.createdAt,
      );
      notifyListeners();
    }
  }

  void updateGoals({double? calorieGoal, int? exerciseMinutesGoal}) {
    if (calorieGoal != null) _dailyCalorieGoal = calorieGoal;
    if (exerciseMinutesGoal != null) _dailyExerciseMinutesGoal = exerciseMinutesGoal;
    notifyListeners();
  }

  // Today's stats
  List<Exercise> get todayExercises {
    final today = DateTime.now();
    return _exercises.where((e) =>
      e.date.year == today.year &&
      e.date.month == today.month &&
      e.date.day == today.day
    ).toList();
  }

  double get todayCaloriesBurned {
    return todayExercises.fold(0.0, (sum, e) => sum + e.caloriesBurned);
  }

  int get todayExerciseMinutes {
    return todayExercises.fold(0, (sum, e) => sum + e.durationMinutes);
  }

  int get todayExercisesCount => todayExercises.length;

  // Weekly progress
  List<DailyProgress> get weeklyProgress {
    List<DailyProgress> weekly = [];
    final today = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = DateTime(today.year, today.month, today.day - i);
      final dayExercises = _exercises.where((e) =>
        e.date.year == date.year &&
        e.date.month == date.month &&
        e.date.day == date.day
      ).toList();

      weekly.add(DailyProgress(
        date: date,
        totalCalories: dayExercises.fold(0.0, (sum, e) => sum + e.caloriesBurned),
        totalDuration: dayExercises.fold(0, (sum, e) => sum + e.durationMinutes),
        exercisesCount: dayExercises.length,
      ));
    }

    return weekly;
  }

  BodyStats? get latestBodyStats {
    if (_bodyStats.isEmpty) return null;
    _bodyStats.sort((a, b) => b.date.compareTo(a.date));
    return _bodyStats.first;
  }

  // Add exercise
  void addExercise(Exercise exercise) {
    _exercises.add(exercise);
    notifyListeners();
  }

  // Add body stats
  void addBodyStats(BodyStats stats) {
    _bodyStats.add(stats);
    notifyListeners();
  }

  // Delete exercise
  void deleteExercise(String id) {
    _exercises.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // Calculate calories burned for exercise type (simplified)
  static double calculateCalories(String exerciseType, int durationMinutes) {
    // MET values for different exercises
    const metValues = {
      'Running': 9.8,
      'Cycling': 7.5,
      'Swimming': 8.0,
      'Walking': 3.5,
      'Weight Training': 5.0,
      'Yoga': 3.0,
      'HIIT': 11.0,
      'Other': 5.0,
    };

    // Assuming average weight of 70kg for calculation
    const weight = 70.0;
    final met = metValues[exerciseType] ?? 5.0;
    return (met * weight * durationMinutes) / 60;
  }
}
