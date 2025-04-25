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
  int _chartIndex = 0; // 0 = Bar, 1 = Pie
  // bool _showBarChart = true;

  final List<Map<String, dynamic>> _expenses = [
    {'category': 'Food', 'amount': 1200.0, 'color': Colors.deepPurple},
    {'category': 'Transport', 'amount': 800.0, 'color': Colors.orange},
    {'category': 'Shopping', 'amount': 650.0, 'color': Colors.teal},
    {'category': 'Bills', 'amount': 400.0, 'color': Colors.blue},
  ];

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
      appBar: AppBar(title: const Text('Analytics')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          ToggleButtons(
            isSelected: [_chartIndex == 0, _chartIndex == 1],
            onPressed: (index) => setState(() => _chartIndex = index),
            borderRadius: BorderRadius.circular(12),
            selectedColor: Colors.white,
            fillColor: Colors.deepPurple,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Bar Chart'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Pie Chart'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child:
                  _chartIndex == 0
                      ? buildBarChart(symbol)
                      : buildPieChart(symbol),
            ),
          ),
          buildLegend(),
        ],
      ),
    );
  }

  Widget buildBarChart(String symbol) {
    return BarChart(
      BarChartData(
        barGroups:
            _expenses.asMap().entries.map((entry) {
              int index = entry.key;
              var e = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: e['amount'],
                    color: e['color'],
                    width: 20,
                    borderRadius: BorderRadius.circular(6),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 1500,
                      color: e['color'].withOpacity(0.2),
                    ),
                  ),
                ],
              );
            }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget:
                  (value, _) => Text(_expenses[value.toInt()]['category']),
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '$symbol ${rod.toY.toStringAsFixed(0)}',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
        maxY: 1500,
      ),
    );
  }

  Widget buildPieChart(String symbol) {
    final total = _expenses.fold(0.0, (sum, item) => sum + item['amount']);
    return PieChart(
      PieChartData(
        sections:
            _expenses.map((e) {
              final percent = (e['amount'] / total * 100).toStringAsFixed(1);
              return PieChartSectionData(
                value: e['amount'],
                title: '$percent%',
                color: e['color'],
                radius: 70,
                titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
              );
            }).toList(),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  Widget buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        children:
            _expenses.map((e) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: e['color'],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(e['category']),
                ],
              );
            }).toList(),
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   final symbol = getCurrencySymbol(selectedCurrency);

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Analytics'),
  //       actions: [
  //         Row(
  //           children: [
  //             const Icon(Icons.bar_chart),
  //             Switch(
  //               value: _showBarChart,
  //               onChanged: (val) {
  //                 setState(() {
  //                   _showBarChart = val;
  //                 });
  //               },
  //             ),
  //             const Icon(Icons.pie_chart),
  //           ],
  //         ),
  //       ],
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: _showBarChart ? buildBarChart(symbol) : buildPieChart(symbol),
  //     ),
  //   );
  // }

  // Widget buildBarChart(String symbol) {
  //   return BarChart(
  //     BarChartData(
  //       barGroups: [
  //         BarChartGroupData(
  //           x: 0,
  //           barRods: [
  //             BarChartRodData(
  //               toY: 1500,
  //               width: 22,
  //               color: Colors.deepPurple,
  //               borderRadius: BorderRadius.circular(6),
  //               backDrawRodData: BackgroundBarChartRodData(
  //                 show: true,
  //                 toY: 2000,
  //                 color: Colors.deepPurple.shade100,
  //               ),
  //             ),
  //           ],
  //         ),
  //         BarChartGroupData(
  //           x: 1,
  //           barRods: [
  //             BarChartRodData(
  //               toY: 1000,
  //               width: 22,
  //               color: Colors.orange,
  //               borderRadius: BorderRadius.circular(6),
  //               backDrawRodData: BackgroundBarChartRodData(
  //                 show: true,
  //                 toY: 2000,
  //                 color: Colors.orange.shade100,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //       barTouchData: BarTouchData(
  //         enabled: true,
  //         touchTooltipData: BarTouchTooltipData(
  //           tooltipBgColor: Colors.black87,
  //           getTooltipItem: (group, groupIndex, rod, rodIndex) {
  //             return BarTooltipItem(
  //               '$symbol ${rod.toY.toStringAsFixed(0)}',
  //               const TextStyle(color: Colors.white, fontSize: 14),
  //             );
  //           },
  //         ),
  //       ),
  //       titlesData: FlTitlesData(
  //         bottomTitles: AxisTitles(
  //           sideTitles: SideTitles(
  //             showTitles: true,
  //             getTitlesWidget: (value, meta) {
  //               final labels = ['Jan', 'Feb'];
  //               return Text(labels[value.toInt()]);
  //             },
  //           ),
  //         ),
  //         leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
  //       ),
  //       gridData: FlGridData(show: true),
  //       borderData: FlBorderData(show: false),
  //       maxY: 2000,
  //     ),
  //   );
  // }

  // Widget buildPieChart(String symbol) {
  //   return PieChart(
  //     PieChartData(
  //       sections: [
  //         PieChartSectionData(
  //           value: 1500,
  //           title: '$symbol 1500',
  //           color: Colors.deepPurple,
  //           radius: 70,
  //           titleStyle: const TextStyle(color: Colors.white),
  //         ),
  //         PieChartSectionData(
  //           value: 1000,
  //           title: '$symbol 1000',
  //           color: Colors.orange,
  //           radius: 70,
  //           titleStyle: const TextStyle(color: Colors.white),
  //         ),
  //       ],
  //       sectionsSpace: 4,
  //       centerSpaceRadius: 40,
  //     ),
  //   );
  // }
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
