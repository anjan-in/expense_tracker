import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpensePieChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpensePieChart({super.key, required this.expenses});

  Map<String, double> get categoryTotals {
    final Map<String, double> data = {};
    for (var e in expenses) {
      data[e.category.toString()] =
          (data[e.category.toString()] ?? 0) + e.amount;
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final entries = categoryTotals.entries.toList();
    final total = entries.fold(0.0, (sum, e) => sum + e.value);

    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 40,
              sections: List.generate(entries.length, (index) {
                final e = entries[index];
                final percent = (e.value / total * 100).toStringAsFixed(1);
                final color = Colors.primaries[index % Colors.primaries.length];
                return PieChartSectionData(
                  color: color,
                  value: e.value,
                  title: '$percent%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   final categoryTotals = <Category, double>{};

  //   for (var expense in expenses) {
  //     categoryTotals.update(
  //       expense.category,
  //       (value) => value + expense.amount,
  //       ifAbsent: () => expense.amount,
  //     );
  //   }

  //   final colors = {
  //     Category.food: Colors.redAccent,
  //     Category.travel: Colors.blue,
  //     Category.shopping: Colors.purple,
  //     Category.bills: Colors.orange,
  //     Category.others: Colors.green,
  //   };

  //   final sections =
  //       categoryTotals.entries.map((entry) {
  //         final value = entry.value;
  //         return PieChartSectionData(
  //           value: value,
  //           title: '₹${value.toStringAsFixed(0)}',
  //           color: colors[entry.key],
  //           radius: 60,
  //           titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
  //         );
  //       }).toList();

  //   if (sections.isEmpty) {
  //     return const Center(child: Text('No data to show'));
  //   }

  //   return SizedBox(
  //     height: 250,
  //     child: PieChart(
  //       PieChartData(
  //         sections: sections,
  //         sectionsSpace: 2,
  //         centerSpaceRadius: 40,
  //       ),
  //     ),
  //   );
  // }
}
