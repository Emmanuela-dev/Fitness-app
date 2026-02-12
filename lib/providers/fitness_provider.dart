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
  List<MoodEntry> _moodEntries = [];
  List<ChatMessage> _chatMessages = [];

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
  List<MoodEntry> get moodEntries => [..._moodEntries];
  List<ChatMessage> get chatMessages => [..._chatMessages];

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

  // Mental Wellness Methods
  void addMoodEntry(MoodEntry entry) {
    _moodEntries.add(entry);
    notifyListeners();
  }

  void deleteMoodEntry(String id) {
    _moodEntries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  MoodEntry? get todayMood {
    final today = DateTime.now();
    final todayEntries = _moodEntries.where((e) =>
      e.date.year == today.year &&
      e.date.month == today.month &&
      e.date.day == today.day
    ).toList();
    if (todayEntries.isEmpty) return null;
    todayEntries.sort((a, b) => b.date.compareTo(a.date));
    return todayEntries.first;
  }

  List<MoodEntry> get weeklyMoods {
    final today = DateTime.now();
    final weekAgo = today.subtract(const Duration(days: 7));
    return _moodEntries.where((e) => e.date.isAfter(weekAgo)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  double get averageMoodThisWeek {
    final moods = weeklyMoods;
    if (moods.isEmpty) return 0;
    return moods.fold(0.0, (sum, e) => sum + e.moodLevel) / moods.length;
  }

  // Chat Methods
  void addChatMessage(ChatMessage message) {
    _chatMessages.add(message);
    notifyListeners();
  }

  void clearChatHistory() {
    _chatMessages.clear();
    notifyListeners();
  }

  // AI Response Generator (Simple rule-based responses)
  String generateAIResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    // Greeting responses
    if (message.contains('hello') || message.contains('hi') || message.contains('hey')) {
      return "Hello! I'm your wellness assistant. How can I help you today? You can ask me about fitness tips, mental wellness, or just chat!";
    }
    
    // Mood-related
    if (message.contains('sad') || message.contains('down') || message.contains('depressed')) {
      return "I'm sorry to hear you're feeling down. Remember, it's okay to have tough days. Try some light exercise or meditation - they can really help boost your mood. Would you like some tips?";
    }
    
    if (message.contains('stressed') || message.contains('anxious') || message.contains('anxiety')) {
      return "Stress is tough, but you're tougher! Try deep breathing: inhale for 4 counts, hold for 4, exhale for 4. Also, physical activity is a great stress reliever. Even a 10-minute walk can help!";
    }
    
    if (message.contains('happy') || message.contains('great') || message.contains('good')) {
      return "That's wonderful to hear! Keep that positive energy going. What's been making you feel good today?";
    }
    
    // Fitness-related
    if (message.contains('workout') || message.contains('exercise')) {
      return "Great question about exercise! For beginners, start with 20-30 minutes of activity 3-4 times a week. Mix cardio (like walking or cycling) with strength training. What type of workout interests you?";
    }
    
    if (message.contains('weight') || message.contains('lose') || message.contains('gain')) {
      return "Weight management is about balance - nutrition and exercise work together. Focus on consistent habits rather than quick fixes. Would you like tips on healthy eating or workout routines?";
    }
    
    if (message.contains('tired') || message.contains('energy') || message.contains('fatigue')) {
      return "Feeling tired? Make sure you're getting 7-9 hours of sleep, staying hydrated, and eating balanced meals. Light exercise can actually boost your energy levels!";
    }
    
    // Sleep
    if (message.contains('sleep') || message.contains('insomnia')) {
      return "Good sleep is crucial for both physical and mental health. Try to keep a consistent sleep schedule, avoid screens before bed, and create a relaxing bedtime routine. Meditation can also help!";
    }
    
    // Motivation
    if (message.contains('motivation') || message.contains('motivated') || message.contains('lazy')) {
      return "Motivation comes and goes, but discipline stays! Start small - even 5 minutes of activity counts. Set specific goals, track your progress, and celebrate small wins. You've got this!";
    }
    
    // Meditation/Mindfulness
    if (message.contains('meditat') || message.contains('mindful') || message.contains('calm')) {
      return "Meditation is amazing for mental wellness! Start with just 5 minutes of focused breathing. Apps can guide you, or simply sit quietly and focus on your breath. Would you like a simple exercise?";
    }
    
    // Help
    if (message.contains('help') || message.contains('what can you do')) {
      return "I'm here to support your wellness journey! You can:\n• Ask about fitness tips and workouts\n• Talk about how you're feeling\n• Get advice on sleep and stress\n• Learn about meditation and mindfulness\n• Just chat when you need support!";
    }
    
    // Thank you
    if (message.contains('thank')) {
      return "You're welcome! I'm always here to help. Is there anything else you'd like to know?";
    }
    
    // Default response
    return "I hear you! While I'm a simple assistant, I'm here to support your wellness journey. Feel free to ask about fitness, mental health, sleep, or just share how you're feeling today.";
  }
}
