import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'providers/fitness_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/exercise_screen.dart';
import 'screens/body_stats_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/daily_log_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FitnessProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/profileSetup': (context) => const ProfileSetupScreen(),
        '/home': (context) => const MainScreen(),
        '/exercise': (context) => const ExerciseScreen(),
        '/bodyStats': (context) => const BodyStatsScreen(),
        '/progress': (context) => const ProgressScreen(),
        '/dailyLog': (context) => const DailyLogScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ExerciseScreen(),
    const BodyStatsScreen(),
    const ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Row(
        children: [
          // Side Navigation Rail
          SizedBox(
            width: 80,
            child: NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: AppTheme.darkSurface,
              indicatorColor: AppTheme.primaryOrange.withOpacity(0.3),
              selectedIconTheme: const IconThemeData(color: AppTheme.primaryOrange),
              unselectedIconTheme: const IconThemeData(color: AppTheme.lightTextSecondary),
              selectedLabelTextStyle: const TextStyle(color: AppTheme.primaryOrange),
              unselectedLabelTextStyle: const TextStyle(color: AppTheme.lightTextSecondary),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.fitness_center_outlined),
                  selectedIcon: Icon(Icons.fitness_center),
                  label: Text('Exercise'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.monitor_weight_outlined),
                  selectedIcon: Icon(Icons.monitor_weight),
                  label: Text('Body Stats'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.insights_outlined),
                  selectedIcon: Icon(Icons.insights),
                  label: Text('Progress'),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1, color: AppTheme.darkSurfaceVariant),
          // Main Content
          Expanded(
            child: Scaffold(
              backgroundColor: AppTheme.darkBackground,
              appBar: AppBar(
                backgroundColor: AppTheme.darkBackground,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/dailyLog'),
                    icon: const Icon(Icons.list_alt),
                    tooltip: 'Daily Log',
                  ),
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/settings'),
                    icon: const Icon(Icons.settings),
                    tooltip: 'Settings',
                  ),
                ],
              ),
              body: _screens[_currentIndex],
            ),
          ),
        ],
      ),
    );
  }
}
