import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import '../models/models.dart';
import '../theme.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedGoal = 'Lose Weight';
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _fitnessGoals = [
    'Lose Weight',
    'Build Muscle',
    'Stay Active',
    'Improve Endurance',
    'Increase Flexibility',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final profile = UserProfile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        fitnessGoal: _selectedGoal,
        createdAt: DateTime.now(),
      );

      context.read<FitnessProvider>().saveUserProfile(profile);

      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Create Your Profile',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'This helps us personalize your fitness journey',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTextSecondary,
                    ),
              ),
              const SizedBox(height: 32),

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
                    children: [
                      // Name
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: AppTheme.lightText),
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person, color: AppTheme.primaryOrange),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Age
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppTheme.lightText),
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          prefixIcon: Icon(Icons.cake, color: AppTheme.primaryOrange),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          }
                          if (int.tryParse(value) == null || int.parse(value) < 13 || int.parse(value) > 120) {
                            return 'Please enter a valid age';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Gender Selection
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        dropdownColor: AppTheme.darkSurface,
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          prefixIcon: Icon(Icons.person, color: AppTheme.primaryOrange),
                        ),
                        items: _genders.map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender, style: const TextStyle(color: AppTheme.lightText)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Weight and Height Row
                      Row(
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _heightController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: AppTheme.lightText),
                              decoration: const InputDecoration(
                                labelText: 'Height (cm)',
                                prefixIcon: Icon(Icons.height, color: AppTheme.primaryOrange),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Fitness Goal
                      DropdownButtonFormField<String>(
                        value: _selectedGoal,
                        dropdownColor: AppTheme.darkSurface,
                        decoration: const InputDecoration(
                          labelText: 'Fitness Goal',
                          prefixIcon: Icon(Icons.flag, color: AppTheme.primaryOrange),
                        ),
                        items: _fitnessGoals.map((goal) {
                          return DropdownMenuItem(
                            value: goal,
                            child: Text(goal, style: const TextStyle(color: AppTheme.lightText)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGoal = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 32),

                      // BMI Preview
                      if (_weightController.text.isNotEmpty && _heightController.text.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.analytics, color: AppTheme.primaryOrange),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your BMI: ${_calculateBMI().toStringAsFixed(1)}',
                                    style: const TextStyle(
                                      color: AppTheme.primaryOrange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _getBMICategory(),
                                    style: const TextStyle(
                                      color: AppTheme.lightTextSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 32),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          child: const Text('Create Profile'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateBMI() {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final height = double.tryParse(_heightController.text) ?? 0;
    if (height <= 0) return 0;
    return weight / ((height / 100) * (height / 100));
  }

  String _getBMICategory() {
    final bmi = _calculateBMI();
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal weight';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }
}
