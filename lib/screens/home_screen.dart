import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import '../theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FitnessProvider>();
    final userProfile = provider.userProfile;
    final todayCalories = provider.todayCaloriesBurned;
    final calorieGoal = provider.dailyCalorieGoal;
    final caloriesProgress = (todayCalories / calorieGoal).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.lightTextSecondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userProfile?.name ?? 'Fitness Enthusiast',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.darkSurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Today's Date
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: AppTheme.primaryOrange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(DateTime.now()),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTextSecondary,
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Progress Ring Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppTheme.orangeGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryOrange.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Today's Progress",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.lightText,
                          ),
                    ),
                    const SizedBox(height: 24),
                    // Circular Progress Ring
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: CircularProgressIndicator(
                            value: caloriesProgress,
                            strokeWidth: 12,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.lightText),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '${(caloriesProgress * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: AppTheme.lightText,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'of goal',
                              style: TextStyle(
                                color: AppTheme.lightText.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildProgressItem(
                          icon: Icons.local_fire_department,
                          value: todayCalories.toStringAsFixed(0),
                          label: 'Burned',
                          unit: 'kcal',
                        ),
                        _buildProgressItem(
                          icon: Icons.flag,
                          value: calorieGoal.toStringAsFixed(0),
                          label: 'Goal',
                          unit: 'kcal',
                        ),
                      ],
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
                      icon: Icons.timer,
                      value: provider.todayExerciseMinutes.toString(),
                      label: 'Minutes',
                      color: AppTheme.secondaryOrange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.fitness_center,
                      value: provider.todayExercisesCount.toString(),
                      label: 'Exercises',
                      color: AppTheme.accentOrange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Quick Add Exercise Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/exercise'),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Exercise'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Fitness Goal Card
              if (userProfile != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.darkSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryOrange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.flag, color: AppTheme.primaryOrange),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Goal',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              userProfile.fitnessGoal,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Motivation Message
              _buildMotivationCard(userProfile?.fitnessGoal ?? 'Stay Active'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressItem({
    required IconData icon,
    required String value,
    required String label,
    required String unit,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.lightText, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.lightText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$label $unit',
          style: TextStyle(
            color: AppTheme.lightText.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
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
            style: const TextStyle(
              color: AppTheme.lightTextSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationCard(String goal) {
    String message = _getMotivationalMessage(goal);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.orangeGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.lightbulb, color: AppTheme.lightText),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Tip',
                  style: const TextStyle(
                    color: AppTheme.lightText,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: AppTheme.lightText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getMotivationalMessage(String goal) {
    switch (goal) {
      case 'Lose Weight':
        return 'Every step counts! Keep moving to burn those calories.';
      case 'Build Muscle':
        return 'Stay consistent with your strength training for best results.';
      case 'Stay Active':
        return 'Movement is medicine. Keep being active every day!';
      case 'Improve Endurance':
        return 'Push your limits gradually to build endurance.';
      case 'Increase Flexibility':
        return 'Don\'t forget to stretch before and after your workouts.';
      default:
        return 'You\'ve got this! Keep up the great work!';
    }
  }
}
