import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import '../models/models.dart';
import '../theme.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  String _selectedType = 'Running';
  final List<String> _exerciseTypes = [
    'Running',
    'Cycling',
    'Swimming',
    'Walking',
    'Weight Training',
    'Yoga',
    'HIIT',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _saveExercise() {
    if (_formKey.currentState!.validate()) {
      final duration = int.parse(_durationController.text);
      final calories = FitnessProvider.calculateCalories(_selectedType, duration);

      final exercise = Exercise(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        durationMinutes: duration,
        caloriesBurned: calories,
        date: DateTime.now(),
        type: _selectedType,
      );

      context.read<FitnessProvider>().addExercise(exercise);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exercise saved! $calories kcal burned'),
          backgroundColor: AppTheme.successGreen,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FitnessProvider>();

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Log Exercise'),
        backgroundColor: AppTheme.darkSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Exercise',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),

                    // Exercise Type Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      dropdownColor: AppTheme.darkSurface,
                      decoration: const InputDecoration(
                        labelText: 'Exercise Type',
                        prefixIcon: Icon(Icons.fitness_center, color: AppTheme.primaryOrange),
                      ),
                      items: _exerciseTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type, style: const TextStyle(color: AppTheme.lightText)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Exercise Name
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: AppTheme.lightText),
                      decoration: const InputDecoration(
                        labelText: 'Exercise Name',
                        prefixIcon: Icon(Icons.label, color: AppTheme.primaryOrange),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter exercise name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Duration
                    TextFormField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppTheme.lightText),
                      decoration: const InputDecoration(
                        labelText: 'Duration (minutes)',
                        prefixIcon: Icon(Icons.timer, color: AppTheme.primaryOrange),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter duration';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Calculate estimated calories
                    if (_durationController.text.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: AppTheme.primaryOrange),
                            const SizedBox(width: 12),
                            Text(
                              'Estimated: ${FitnessProvider.calculateCalories(_selectedType, int.tryParse(_durationController.text) ?? 0).toStringAsFixed(0)} kcal',
                              style: const TextStyle(
                                color: AppTheme.primaryOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveExercise,
                        child: const Text('Save Exercise'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Today's Exercises List
            Text(
              "Today's Exercises",
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
                        color: AppTheme.primaryOrange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.fitness_center,
                        color: AppTheme.primaryOrange,
                      ),
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
                            '${exercise.durationMinutes} min • ${exercise.type}',
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
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppTheme.errorRed),
                          onPressed: () {
                            provider.deleteExercise(exercise.id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }
}
