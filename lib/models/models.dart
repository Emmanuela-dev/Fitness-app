class Exercise {
  final String id;
  final String name;
  final int durationMinutes;
  final double caloriesBurned;
  final DateTime date;
  final String type;

  Exercise({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      durationMinutes: map['durationMinutes'],
      caloriesBurned: map['caloriesBurned'],
      date: DateTime.parse(map['date']),
      type: map['type'],
    );
  }
}

class BodyStats {
  final String id;
  final double weight;
  final double height;
  final DateTime date;
  final String notes;

  BodyStats({
    required this.id,
    required this.weight,
    required this.height,
    required this.date,
    this.notes = '',
  });

  double get bmi => height > 0 ? weight / ((height / 100) * (height / 100)) : 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weight': weight,
      'height': height,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory BodyStats.fromMap(Map<String, dynamic> map) {
    return BodyStats(
      id: map['id'],
      weight: map['weight'],
      height: map['height'],
      date: DateTime.parse(map['date']),
      notes: map['notes'] ?? '',
    );
  }
}

class DailyProgress {
  final DateTime date;
  final double totalCalories;
  final int totalDuration;
  final int exercisesCount;

  DailyProgress({
    required this.date,
    required this.totalCalories,
    required this.totalDuration,
    required this.exercisesCount,
  });
}

class UserProfile {
  final String id;
  final String name;
  final int age;
  final String gender;
  final double weight;
  final double height;
  final String fitnessGoal;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.fitnessGoal,
    required this.createdAt,
  });

  double get bmi => height > 0 ? weight / ((height / 100) * (height / 100)) : 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'fitnessGoal': fitnessGoal,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      weight: map['weight'],
      height: map['height'],
      fitnessGoal: map['fitnessGoal'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

// Mental Wellness Models
class MoodEntry {
  final String id;
  final int moodLevel; // 1-5 scale
  final String moodLabel; // e.g., "Happy", "Stressed", "Calm"
  final String? notes;
  final DateTime date;
  final List<String> activities; // e.g., ["Meditation", "Exercise", "Sleep"]

  MoodEntry({
    required this.id,
    required this.moodLevel,
    required this.moodLabel,
    this.notes,
    required this.date,
    this.activities = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'moodLevel': moodLevel,
      'moodLabel': moodLabel,
      'notes': notes,
      'date': date.toIso8601String(),
      'activities': activities,
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'],
      moodLevel: map['moodLevel'],
      moodLabel: map['moodLabel'],
      notes: map['notes'],
      date: DateTime.parse(map['date']),
      activities: List<String>.from(map['activities'] ?? []),
    );
  }
}

class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      content: map['content'],
      isUser: map['isUser'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
