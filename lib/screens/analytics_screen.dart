import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/currency_helper.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedCurrency = 'USD';
  bool _showBarChart = true;

  @override
  void initState() {
    super.initState();
    _loadCurrencyPreference();
  }

  Future<void> _loadCurrencyPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCurrency = prefs.getString('selectedCurrency') ?? 'USD';
    });
  }

  @override
  Widget build(BuildContext context) {
    final symbol = getCurrencySymbol(selectedCurrency);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          Row(
            children: [
              const Icon(Icons.bar_chart),
              Switch(
                value: _showBarChart,
                onChanged: (val) {
                  setState(() {
                    _showBarChart = val;
                  });
                },
              ),
              const Icon(Icons.pie_chart),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _showBarChart ? buildBarChart(symbol) : buildPieChart(symbol),
      ),
    );
  }

  Widget buildBarChart(String symbol) {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: 1500,
                width: 22,
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(6),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 2000,
                  color: Colors.deepPurple.shade100,
                ),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: 1000,
                width: 22,
                color: Colors.orange,
                borderRadius: BorderRadius.circular(6),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 2000,
                  color: Colors.orange.shade100,
                ),
              ),
            ],
          ),
        ],
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '$symbol ${rod.toY.toStringAsFixed(0)}',
                const TextStyle(color: Colors.white, fontSize: 14),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final labels = ['Jan', 'Feb'];
                return Text(labels[value.toInt()]);
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
        maxY: 2000,
      ),
    );
  }

  Widget buildPieChart(String symbol) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 1500,
            title: '$symbol 1500',
            color: Colors.deepPurple,
            radius: 70,
            titleStyle: const TextStyle(color: Colors.white),
          ),
          PieChartSectionData(
            value: 1000,
            title: '$symbol 1000',
            color: Colors.orange,
            radius: 70,
            titleStyle: const TextStyle(color: Colors.white),
          ),
        ],
        sectionsSpace: 4,
        centerSpaceRadius: 40,
      ),
    );
  }
}

// class _AnalyticsScreenState extends State<AnalyticsScreen> {
//   bool showPieChart = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Analytics'),
//         actions: [
//           Row(
//             children: [
//               const Icon(Icons.pie_chart_outline),
//               Switch(
//                 value: showPieChart,
//                 onChanged: (val) => setState(() => showPieChart = val),
//               ),
//               const Icon(Icons.bar_chart),
//               const SizedBox(width: 16),
//             ],
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: showPieChart ? _buildPieChart() : _buildBarChart(),
//       ),
//     );
//   }

//   Widget _buildPieChart() {
//     return PieChart(
//       PieChartData(
//         sections: [
//           PieChartSectionData(
//             value: 40,
//             color: Colors.deepPurple,
//             title: 'Food\n40%',
//             radius: 60,
//             titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
//           ),
//           PieChartSectionData(
//             value: 30,
//             color: Colors.orange,
//             title: 'Travel\n30%',
//             radius: 55,
//             titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
//           ),
//           PieChartSectionData(
//             value: 20,
//             color: Colors.green,
//             title: 'Bills\n20%',
//             radius: 50,
//             titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
//           ),
//           PieChartSectionData(
//             value: 10,
//             color: Colors.red,
//             title: 'Other\n10%',
//             radius: 45,
//             titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
//           ),
//         ],
//         centerSpaceRadius: 40,
//       ),
//     );
//   }

//   Widget _buildBarChart() {
//     return BarChart(
//       BarChartData(
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 final labels = ['Food', 'Travel', 'Bills', 'Other'];
//                 return Text(labels[value.toInt()]);
//               },
//             ),
//           ),
//         ),
//         barGroups: [
//           _buildBarData(0, 40, Colors.deepPurple),
//           _buildBarData(1, 30, Colors.orange),
//           _buildBarData(2, 20, Colors.green),
//           _buildBarData(3, 10, Colors.red),
//         ],
//         barTouchData: BarTouchData(
//           enabled: true,
//           touchTooltipData: BarTouchTooltipData(
//             tooltipBgColor: Colors.black87,
//             getTooltipItem: (group, groupIndex, rod, rodIndex) {
//               return BarTooltipItem(
//                 '${rod.toY.toInt()}%',
//                 const TextStyle(color: Colors.white),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   BarChartGroupData _buildBarData(int x, double y, Color color) {
//     return BarChartGroupData(
//       x: x,
//       barRods: [
//         BarChartRodData(
//           toY: y,
//           color: color,
//           width: 22,
//           borderRadius: BorderRadius.circular(8),
//           rodStackItems: [BarChartRodStackItem(0, y, color)],
//           backDrawRodData: BackgroundBarChartRodData(
//             show: true,
//             toY: 100,
//             color: Colors.grey.shade200,
//           ),
//         ),
//       ],
//     );
//   }
// }
