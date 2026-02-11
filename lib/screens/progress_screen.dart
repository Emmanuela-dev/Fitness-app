import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import '../models/models.dart';
import '../theme.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool _showWeekly = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FitnessProvider>();
    final weeklyProgress = provider.weeklyProgress;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Progress'),
        backgroundColor: AppTheme.darkSurface,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _showWeekly = !_showWeekly;
              });
            },
            child: Text(
              _showWeekly ? 'Today' : 'Weekly',
              style: const TextStyle(color: AppTheme.primaryOrange),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    icon: Icons.local_fire_department,
                    value: _showWeekly
                        ? weeklyProgress.fold(0.0, (sum, d) => sum + d.totalCalories).toStringAsFixed(0)
                        : provider.todayCaloriesBurned.toStringAsFixed(0),
                    label: _showWeekly ? 'This Week (kcal)' : 'Today (kcal)',
                    color: AppTheme.primaryOrange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    icon: Icons.timer,
                    value: _showWeekly
                        ? weeklyProgress.fold(0, (sum, d) => sum + d.totalDuration).toString()
                        : provider.todayExerciseMinutes.toString(),
                    label: _showWeekly ? 'This Week (min)' : 'Today (min)',
                    color: AppTheme.secondaryOrange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Weekly Chart
            if (_showWeekly) ...[
              Text(
                'Weekly Overview',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.darkSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Chart
                    SizedBox(
                      height: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: weeklyProgress.map((day) {
                          final maxCalories = weeklyProgress.fold<double>(
                            0.0,
                            (sum, d) => sum > d.totalCalories ? sum : d.totalCalories,
                          );
                          final height = maxCalories > 0
                              ? (day.totalCalories / maxCalories) * 150
                              : 0;
                          final isToday = DateTime.now().year == day.date.year &&
                              DateTime.now().month == day.date.month &&
                              DateTime.now().day == day.date.day;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${day.totalCalories.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: AppTheme.lightTextSecondary,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 32,
                                height: height.clamp(4.0, 150.0).toDouble(),
                                decoration: BoxDecoration(
                                  gradient: isToday
                                      ? AppTheme.orangeGradient
                                      : LinearGradient(
                                          colors: [
                                            AppTheme.darkSurfaceVariant,
                                            AppTheme.darkSurfaceVariant,
                                          ],
                                        ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getDayAbbreviation(day.date.weekday),
                                style: TextStyle(
                                  color: isToday
                                      ? AppTheme.primaryOrange
                                      : AppTheme.lightTextSecondary,
                                  fontSize: 12,
                                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Daily Breakdown
              Text(
                'Daily Breakdown',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...weeklyProgress.reversed.map((day) => _buildDayProgressItem(day)),
            ] else ...[
              // Today's detailed view
              Text(
                'Today\'s Activity',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),

              if (provider.todayExercises.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppTheme.darkSurface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 48,
                          color: AppTheme.lightTextSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No exercises logged today',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/exercise'),
                          child: const Text('Log Exercise'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...provider.todayExercises.map((exercise) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.darkSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppTheme.orangeGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.fitness_center, color: AppTheme.lightText),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              exercise.type,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${exercise.caloriesBurned.toStringAsFixed(0)} kcal',
                            style: const TextStyle(
                              color: AppTheme.primaryOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${exercise.durationMinutes} min',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                )),

              const SizedBox(height: 24),

              // Motivational Message
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.orangeGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, color: AppTheme.lightText, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getMotivationalMessage(provider.todayCaloriesBurned),
                            style: const TextStyle(
                              color: AppTheme.lightText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Goals Progress
            Text(
              'Goals Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildGoalProgress(
              context,
              label: 'Daily Calorie Goal',
              current: provider.todayCaloriesBurned,
              goal: provider.dailyCalorieGoal,
            ),
            const SizedBox(height: 12),
            _buildGoalProgress(
              context,
              label: 'Daily Exercise Goal',
              current: provider.todayExerciseMinutes.toDouble(),
              goal: provider.dailyExerciseMinutesGoal.toDouble(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.lightText),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.lightText,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.lightText.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayProgressItem(DailyProgress day) {
    final isToday = DateTime.now().year == day.date.year &&
        DateTime.now().month == day.date.month &&
        DateTime.now().day == day.date.day;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: isToday
            ? Border.all(color: AppTheme.primaryOrange, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isToday ? 'Today' : _getDayName(day.date.weekday),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isToday ? AppTheme.primaryOrange : null,
                  ),
                ),
                Text(
                  '${day.date.month}/${day.date.day}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${day.totalCalories.toStringAsFixed(0)} kcal',
                style: const TextStyle(
                  color: AppTheme.primaryOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${day.totalDuration} min • ${day.exercisesCount} exercises',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress(
    BuildContext context, {
    required String label,
    required double current,
    required double goal,
  }) {
    final progress = (current / goal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: AppTheme.primaryOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppTheme.darkSurfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${current.toStringAsFixed(0)} / ${goal.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _getDayAbbreviation(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'M';
      case DateTime.tuesday: return 'T';
      case DateTime.wednesday: return 'W';
      case DateTime.thursday: return 'T';
      case DateTime.friday: return 'F';
      case DateTime.saturday: return 'S';
      case DateTime.sunday: return 'S';
      default: return '';
    }
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'Monday';
      case DateTime.tuesday: return 'Tuesday';
      case DateTime.wednesday: return 'Wednesday';
      case DateTime.thursday: return 'Thursday';
      case DateTime.friday: return 'Friday';
      case DateTime.saturday: return 'Saturday';
      case DateTime.sunday: return 'Sunday';
      default: return '';
    }
  }

  String _getMotivationalMessage(double calories) {
    if (calories == 0) {
      return 'Start your fitness journey today! Log your first exercise.';
    } else if (calories < 200) {
      return 'Great start! Keep pushing to reach your goals.';
    } else if (calories < 400) {
      return 'Awesome work! You\'re making great progress.';
    } else if (calories < 600) {
      return 'Amazing! You\'re crushing it today!';
    } else {
      return 'Incredible! You\'re on fire! What a workout!';
    }
  }
}
