import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool showPieChart = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          Row(
            children: [
              const Icon(Icons.pie_chart_outline),
              Switch(
                value: showPieChart,
                onChanged: (val) => setState(() => showPieChart = val),
              ),
              const Icon(Icons.bar_chart),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: showPieChart ? _buildPieChart() : _buildBarChart(),
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 40,
            color: Colors.deepPurple,
            title: 'Food\n40%',
            radius: 60,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          PieChartSectionData(
            value: 30,
            color: Colors.orange,
            title: 'Travel\n30%',
            radius: 55,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          PieChartSectionData(
            value: 20,
            color: Colors.green,
            title: 'Bills\n20%',
            radius: 50,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          PieChartSectionData(
            value: 10,
            color: Colors.red,
            title: 'Other\n10%',
            radius: 45,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final labels = ['Food', 'Travel', 'Bills', 'Other'];
                return Text(labels[value.toInt()]);
              },
            ),
          ),
        ),
        barGroups: [
          _buildBarData(0, 40, Colors.deepPurple),
          _buildBarData(1, 30, Colors.orange),
          _buildBarData(2, 20, Colors.green),
          _buildBarData(3, 10, Colors.red),
        ],
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toInt()}%',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }

  BarChartGroupData _buildBarData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 22,
          borderRadius: BorderRadius.circular(8),
          rodStackItems: [BarChartRodStackItem(0, y, color)],
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';

// class AnalyticsScreen extends StatelessWidget {
//   const AnalyticsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Analytics Screen'));
//   }
// }
