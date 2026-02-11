import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import '../theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _calorieGoalController = TextEditingController();
  final TextEditingController _exerciseMinutesController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _calorieGoalController.dispose();
    _exerciseMinutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FitnessProvider>();
    final userProfile = provider.userProfile;

    // Initialize controllers with current values
    if (userProfile != null) {
      _weightController.text = userProfile.weight.toString();
    }
    _calorieGoalController.text = provider.dailyCalorieGoal.toString();
    _exerciseMinutesController.text = provider.dailyExerciseMinutesGoal.toString();

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.darkSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildSectionHeader('Profile'),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: AppTheme.primaryOrange),
                    title: const Text('Name'),
                    subtitle: Text(userProfile?.name ?? 'Not set'),
                    onTap: () {},
                  ),
                  const Divider(color: AppTheme.darkSurfaceVariant),
                  ListTile(
                    leading: const Icon(Icons.cake, color: AppTheme.primaryOrange),
                    title: const Text('Age'),
                    subtitle: Text(userProfile?.age.toString() ?? 'Not set'),
                    onTap: () {},
                  ),
                  const Divider(color: AppTheme.darkSurfaceVariant),
                  ListTile(
                    leading: const Icon(Icons.flag, color: AppTheme.primaryOrange),
                    title: const Text('Fitness Goal'),
                    subtitle: Text(userProfile?.fitnessGoal ?? 'Not set'),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Update Weight
            _buildSectionHeader('Update Weight'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppTheme.lightText),
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        prefixIcon: Icon(Icons.monitor_weight, color: AppTheme.primaryOrange),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final weight = double.tryParse(_weightController.text);
                      if (weight != null) {
                        provider.updateWeight(weight);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Weight updated!'),
                            backgroundColor: AppTheme.successGreen,
                          ),
                        );
                      }
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Goals Section
            _buildSectionHeader('Goals'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _calorieGoalController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: AppTheme.lightText),
                          decoration: const InputDecoration(
                            labelText: 'Daily Calorie Goal (kcal)',
                            prefixIcon: Icon(Icons.local_fire_department, color: AppTheme.primaryOrange),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _exerciseMinutesController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: AppTheme.lightText),
                          decoration: const InputDecoration(
                            labelText: 'Daily Exercise Minutes Goal',
                            prefixIcon: Icon(Icons.timer, color: AppTheme.primaryOrange),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final calorieGoal = double.tryParse(_calorieGoalController.text);
                        final exerciseMinutes = int.tryParse(_exerciseMinutesController.text);
                        provider.updateGoals(
                          calorieGoal: calorieGoal,
                          exerciseMinutesGoal: exerciseMinutes,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Goals updated!'),
                            backgroundColor: AppTheme.successGreen,
                          ),
                        );
                      },
                      child: const Text('Save Goals'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Theme Section
            _buildSectionHeader('Appearance'),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SwitchListTile(
                secondary: const Icon(Icons.dark_mode, color: AppTheme.primaryOrange),
                title: const Text('Dark Mode'),
                value: provider.isDarkMode,
                onChanged: (value) {
                  provider.toggleTheme();
                },
              ),
            ),

            const SizedBox(height: 24),

            // Data Section
            _buildSectionHeader('Data'),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.download, color: AppTheme.primaryOrange),
                    title: const Text('Export Data'),
                    onTap: () {},
                  ),
                  const Divider(color: AppTheme.darkSurfaceVariant),
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: AppTheme.errorRed),
                    title: const Text('Clear All Data'),
                    subtitle: const Text('This action cannot be undone'),
                    onTap: () => _confirmClearData(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorRed,
                ),
                onPressed: () => _confirmLogout(context),
                child: const Text('Logout'),
              ),
            ),

            const SizedBox(height: 32),

            // App Version
            Center(
              child: Text(
                'Fitness Tracker v1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTextSecondary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryOrange,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            onPressed: () {
              context.read<FitnessProvider>().logout();
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _confirmClearData(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: const Text('Clear All Data'),
        content: const Text(
            'This will delete all your exercises and body stats. Your profile will be preserved. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            onPressed: () {
              // Clear exercises
              for (var exercise in [...context.read<FitnessProvider>().exercises]) {
                context.read<FitnessProvider>().deleteExercise(exercise.id);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared!'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }
}
