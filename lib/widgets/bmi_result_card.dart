import 'package:flutter/material.dart';

class BMIResultCard extends StatelessWidget {
  final double bmi;
  final String category;

  const BMIResultCard({
    super.key,
    required this.bmi,
    required this.category,
  });

  Color _getCategoryColor() {
    switch (category) {
      case 'Underweight':
        return Colors.blue;
      case 'Normal':
        return Colors.green;
      case 'Overweight':
        return Colors.orange;
      case 'Obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Your BMI',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              bmi.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: _getCategoryColor(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category,
              style: TextStyle(
                fontSize: 20,
                color: _getCategoryColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}