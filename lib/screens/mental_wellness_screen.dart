import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import '../models/models.dart';
import '../theme.dart';

class MentalWellnessScreen extends StatefulWidget {
  const MentalWellnessScreen({super.key});

  @override
  State<MentalWellnessScreen> createState() => _MentalWellnessScreenState();
}

class _MentalWellnessScreenState extends State<MentalWellnessScreen> {
  int _selectedMood = 3;
  final TextEditingController _notesController = TextEditingController();
  final List<String> _selectedActivities = [];

  final List<Map<String, dynamic>> _moods = [
    {'level': 1, 'emoji': '😢', 'label': 'Very Low'},
    {'level': 2, 'emoji': '😔', 'label': 'Low'},
    {'level': 3, 'emoji': '😐', 'label': 'Neutral'},
    {'level': 4, 'emoji': '😊', 'label': 'Good'},
    {'level': 5, 'emoji': '😄', 'label': 'Great'},
  ];

  final List<Map<String, dynamic>> _activities = [
    {'name': 'Exercise', 'icon': Icons.fitness_center},
    {'name': 'Meditation', 'icon': Icons.self_improvement},
    {'name': 'Good Sleep', 'icon': Icons.bedtime},
    {'name': 'Healthy Eating', 'icon': Icons.restaurant},
    {'name': 'Nature Walk', 'icon': Icons.park},
    {'name': 'Social Time', 'icon': Icons.people},
    {'name': 'Reading', 'icon': Icons.book},
    {'name': 'Music', 'icon': Icons.music_note},
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveMoodEntry() {
    final entry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      moodLevel: _selectedMood,
      moodLabel: _moods.firstWhere((m) => m['level'] == _selectedMood)['label'],
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      date: DateTime.now(),
      activities: _selectedActivities,
    );

    context.read<FitnessProvider>().addMoodEntry(entry);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mood logged successfully!'),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );

    _notesController.clear();
    setState(() {
      _selectedActivities.clear();
      _selectedMood = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FitnessProvider>();
    final todayMood = provider.todayMood;
    final avgMood = provider.averageMoodThisWeek;
    final weeklyMoods = provider.weeklyMoods;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        title: const Text('Mental Wellness'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/chat'),
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Chat with AI',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade600, Colors.purple.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mind Matters',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Track your mood and mental wellness',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: "Today's Mood",
                    value: todayMood != null
                        ? _moods.firstWhere((m) => m['level'] == todayMood.moodLevel)['emoji']
                        : '—',
                    subtitle: todayMood?.moodLabel ?? 'Not logged',
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'Weekly Average',
                    value: avgMood > 0 ? avgMood.toStringAsFixed(1) : '—',
                    subtitle: avgMood > 0 ? _getMoodDescription(avgMood) : 'No data',
                    color: Colors.teal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Log Mood Section
            Text(
              'How are you feeling?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Mood Selector
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _moods.map((mood) {
                      final isSelected = _selectedMood == mood['level'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedMood = mood['level']),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryOrange.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(color: AppTheme.primaryOrange, width: 2)
                                : null,
                          ),
                          child: Column(
                            children: [
                              Text(
                                mood['emoji'],
                                style: TextStyle(fontSize: isSelected ? 36 : 28),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mood['label'],
                                style: TextStyle(
                                  color: isSelected
                                      ? AppTheme.primaryOrange
                                      : AppTheme.lightTextSecondary,
                                  fontSize: 10,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Activities
            Text(
              'What helped your mood today?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _activities.map((activity) {
                final isSelected = _selectedActivities.contains(activity['name']);
                return FilterChip(
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedActivities.add(activity['name']);
                      } else {
                        _selectedActivities.remove(activity['name']);
                      }
                    });
                  },
                  avatar: Icon(
                    activity['icon'],
                    size: 18,
                    color: isSelected ? AppTheme.lightText : AppTheme.lightTextSecondary,
                  ),
                  label: Text(activity['name']),
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.lightText : AppTheme.lightTextSecondary,
                  ),
                  selectedColor: AppTheme.primaryOrange,
                  backgroundColor: AppTheme.darkSurface,
                  checkmarkColor: AppTheme.lightText,
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Notes
            TextField(
              controller: _notesController,
              maxLines: 3,
              style: const TextStyle(color: AppTheme.lightText),
              decoration: InputDecoration(
                hintText: 'Add notes about your day (optional)',
                hintStyle: TextStyle(color: AppTheme.lightTextSecondary.withOpacity(0.5)),
                filled: true,
                fillColor: AppTheme.darkSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveMoodEntry,
                child: const Text('Log Mood'),
              ),
            ),

            const SizedBox(height: 32),

            // Weekly Mood History
            if (weeklyMoods.isNotEmpty) ...[
              Text(
                'Recent Mood History',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...weeklyMoods.reversed.take(5).map((entry) => _buildMoodHistoryItem(entry)),
            ],

            const SizedBox(height: 24),

            // Quick Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Wellness Tips',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildTipItem(Icons.self_improvement, 'Take 5 deep breaths'),
                  _buildTipItem(Icons.directions_walk, 'Go for a short walk'),
                  _buildTipItem(Icons.water_drop, 'Drink a glass of water'),
                  _buildTipItem(Icons.chat_bubble, 'Talk to your AI assistant'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.lightTextSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppTheme.lightTextSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodHistoryItem(MoodEntry entry) {
    final mood = _moods.firstWhere((m) => m['level'] == entry.moodLevel);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(mood['emoji'], style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mood['label'],
                  style: const TextStyle(
                    color: AppTheme.lightText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (entry.activities.isNotEmpty)
                  Text(
                    entry.activities.join(', '),
                    style: const TextStyle(
                      color: AppTheme.lightTextSecondary,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            _formatDate(entry.date),
            style: const TextStyle(
              color: AppTheme.lightTextSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryOrange, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.lightText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _getMoodDescription(double avgMood) {
    if (avgMood >= 4.5) return 'Excellent';
    if (avgMood >= 3.5) return 'Good';
    if (avgMood >= 2.5) return 'Okay';
    if (avgMood >= 1.5) return 'Low';
    return 'Very Low';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return 'Yesterday';
    }
    return '${date.day}/${date.month}';
  }
}
