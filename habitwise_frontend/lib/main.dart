import 'package:flutter/material.dart';

// Color scheme based on requirements
const Color kPrimaryColor = Color(0xFF4CAF50);
const Color kSecondaryColor = Color(0xFF2196F3);
const Color kAccentColor = Color(0xFFFFC107);

// PUBLIC_INTERFACE
void main() {
  runApp(const HabitWiseApp());
}

// PUBLIC_INTERFACE
class HabitWiseApp extends StatelessWidget {
  const HabitWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
        ),
        primaryColor: kPrimaryColor,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kAccentColor,
          foregroundColor: Colors.white,
        ),
        cardTheme: const CardTheme(
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.black54,
          backgroundColor: Colors.white,
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}

// Onboarding Screen – shown the first time
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // For demo, always show onboarding then go to MainNavigation
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Center(
                child: Icon(Icons.track_changes,
                    color: kPrimaryColor, size: 64),
              ),
              const SizedBox(height: 32),
              const Text(
                "Welcome to HabitWise",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Build better habits, track your daily streaks, and reach your goals with a simple, beautiful experience. All works offline too.",
                style: TextStyle(fontSize: 17, color: Colors.black87),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Text('Get Started', style: TextStyle(fontSize: 18)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (c) => const MainNavigationScreen(),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Root scaffold with a bottom navigation bar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const ProgressScreen(),
    const SettingsScreen(),
  ];

  // PUBLIC_INTERFACE
  void _onTab(int idx) {
    setState(() => _selectedIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// HomeScreen - shows current habits in card layout + FAB for add/edit modal
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today"),
        centerTitle: true,
      ),
      body: HabitCardsList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: kAccentColor,
        onPressed: () async {
          await showModalBottomSheet(
              context: context,
              useSafeArea: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(18))),
              builder: (context) => const HabitEditModal());
        },
      ),
    );
  }
}

// Habit list using cards – dummy data for illustration
class HabitCardsList extends StatelessWidget {
  final List<Map<String, dynamic>> habits = const [
    {
      'name': 'Drink Water',
      'streak': 7,
      'goal': '8 glasses',
      'color': kPrimaryColor,
      'completed': false,
    },
    {
      'name': 'Read Book',
      'streak': 3,
      'goal': '30 min',
      'color': kSecondaryColor,
      'completed': true,
    },
    {
      'name': 'Morning Run',
      'streak': 2,
      'goal': '5 km',
      'color': kAccentColor,
      'completed': false,
    },
  ];

  const HabitCardsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      children: habits.map((habit) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color.fromRGBO(
                (habit['color'] as Color).r.toInt(),
                (habit['color'] as Color).g.toInt(),
                (habit['color'] as Color).b.toInt(),
                0.14, // opacity
              ),
              child: Icon(
                habit['completed']
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: habit['color'] as Color,
              )
            ),
            title: Text(
              habit['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            subtitle: Text('Goal: ${habit['goal']} • Streak: ${habit['streak']}d'),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: kAccentColor),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  useSafeArea: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
                  builder: (context) => HabitEditModal(
                    habitName: habit['name'],
                    goal: habit['goal'],
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Modal sheet for adding/editing habits – minimal, for extension
class HabitEditModal extends StatelessWidget {
  final String? habitName;
  final String? goal;
  const HabitEditModal({super.key, this.habitName, this.goal});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: habitName ?? "");
    final goalController = TextEditingController(text: goal ?? "");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            habitName == null ? "Add Habit" : "Edit Habit",
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: kPrimaryColor),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              labelText: "Habit Name",
              border: OutlineInputBorder(),
            ),
            controller: nameController,
          ),
          const SizedBox(height: 14),
          TextField(
            decoration: const InputDecoration(
              labelText: "Goal (e.g., 8 glasses, 30 min)",
              border: OutlineInputBorder(),
            ),
            controller: goalController,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kSecondaryColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      // Save habit logic. (scaffolding – to be implemented)
                      Navigator.of(context).pop();
                    },
                    child: Text(habitName == null ? 'Add' : 'Save'),
                  )),
            ],
          )
        ],
      ),
    );
  }
}

// ProgressScreen - shows progress visualization, placeholder for now
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder: Would include streaks, charts, etc.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 84, color: kPrimaryColor),
            const SizedBox(height: 16),
            const Text(
              "Visualize your progress here.",
              style: TextStyle(fontSize: 19),
            ),
            const SizedBox(height: 6),
            const Text(
              "Charts, streaks, analytics – coming soon.",
              style: TextStyle(fontSize: 15, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}

// SettingsScreen – for app/user/config preferences
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder with minimal content
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          ListTile(
            leading: const Icon(Icons.cloud_off_outlined, color: kAccentColor),
            title: const Text('Offline Support'),
            subtitle: const Text(
                'All features will work without internet. Data sync coming soon.'),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              showDialog(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Offline Support'),
                  content: const Text(
                      'Your habits and progress are saved on your device. You can use HabitWise anytime.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(c).pop(),
                        child: const Text('OK'))
                  ],
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.dark_mode_outlined, color: kSecondaryColor),
              title: const Text('Light Theme'),
              subtitle: const Text('Modern minimal UI, always bright.'),
              onTap: () {},
          ),
          // More settings to be added
        ],
      ),
    );
  }
}
