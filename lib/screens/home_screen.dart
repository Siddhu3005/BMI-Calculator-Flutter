import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bmi_result_card.dart';
import '../widgets/bmi_gauge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double? _bmiResult;
  String _bmiCategory = '';
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadLastResult();
    _loadThemePreference();
  }

  _loadLastResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _bmiResult = prefs.getDouble('last_bmi');
      _bmiCategory = prefs.getString('last_category') ?? '';
    });
  }

  _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  _saveResult(double bmi, String category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('last_bmi', bmi);
    await prefs.setString('last_category', category);
  }

  _toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await prefs.setBool('dark_mode', _isDarkMode);
  }

  void _calculateBMI() {
    final double height = double.tryParse(_heightController.text) ?? 0;
    final double weight = double.tryParse(_weightController.text) ?? 0;

    if (height > 0 && weight > 0) {
      final double bmi = weight / ((height / 100) * (height / 100));
      String category;

      if (bmi < 18.5) {
        category = 'Underweight';
      } else if (bmi < 25) {
        category = 'Normal';
      } else if (bmi < 30) {
        category = 'Overweight';
      } else {
        category = 'Obese';
      }

      setState(() {
        _bmiResult = bmi;
        _bmiCategory = category;
      });

      _saveResult(bmi, category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'BMI Calculator',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 500,
                    child: TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Height (cm)',
                        labelStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 500,
                    child: TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        labelStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _calculateBMI,
                    child: const Text('Calculate BMI'),
                  ),
                  const SizedBox(height: 30),
                  if (_bmiResult != null)
                    Column(
                      children: [
                        BMIGauge(bmi: _bmiResult!),
                        const SizedBox(height: 20),
                        BMIResultCard(
                          bmi: _bmiResult!,
                          category: _bmiCategory,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}